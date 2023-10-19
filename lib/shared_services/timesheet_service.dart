import 'dart:async';
import 'package:compound/core/base/base_service.dart';
import 'package:compound/core/services/checkIn_service/_checkin_repository_movile.dart';
import 'package:compound/core/services/generic_firestore/generic_firestore.dart';
import 'package:compound/locator.dart';
import 'package:compound/shared_models/days_selected.dart';
import 'package:compound/shared_models/porter_model.dart';
import 'package:compound/shared_models/timesheet_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/shared_services/property_service.dart';
import 'package:compound/utils/colors_util.dart';
import 'package:compound/utils/timestamp_util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimesheetService extends BaseService {
  static const String DatabaseRef = "timesheet";
  CheckInRepository _repository;
  TimesheetService() {
    _repository = CheckInRepository();
  }
  final PropertyService _propertyService = locator<PropertyService>();
  StreamController<List<TimesheetModel>> _streamController;

  void dispose() {
    if (_streamController != null) {
      //_streamController.close();
    }
  }

  Future<dynamic> getTimeSheet(String id) async {
    try {
      var timesheetdata =
          await Firestore.instance.collection(DatabaseRef).document(id).get();
      var timesheet = TimesheetModel.fromJson(timesheetdata.data);
      var checkIn = await _repository.getCheckIn(timesheet.checkInId);
      checkIn.property = await _propertyService.getProperty(checkIn.propertyId);
      return {"timesheet": timesheet, "checkin": checkIn};
    } catch (e, st) {
      handleException(e, "getTimeSheet", st);
      return null;
    }
  }

  Future<String> setTimesheet(TimesheetModel timesheet) async {
    try {
      await GenericFirestoreService.db
          .collection(DatabaseRef)
          .document(timesheet.checkInId)
          .setData(timesheet.toJson());
      return 'success';
    } catch (e) {
      return null;
    }
  }

  Future<void> updateTimeSheet(String checkInId) async {
    try {
      await GenericFirestoreService.db
          .collection(DatabaseRef)
          .document(checkInId)
          .updateData({'dateCheckOut': DateTime.now(), 'status': 'Completed'});
    } catch (e) {
      return null;
    }
  }

  void saveTimesheetTransact(TimesheetModel model, WriteBatch batch) async {
    batch.setData(
        GenericFirestoreService.db.collection(DatabaseRef).document(model.id),
        model.toJson());
  }

  void updateTimeSheetTransact(String checkInId, WriteBatch batch) async {
    batch.updateData(
        GenericFirestoreService.db.collection(DatabaseRef).document(checkInId),
        {
          'dateCheckOut': TimestampUtils.dateNow().utc(),
          'status': 'Completed'
        });
  }

  void loadTimesheetByDate(WrappedDate date) async {
    try {
      var days = [DateFormat('EEEE').format(date.local())];

      var propertiesQuery = GenericFirestoreService.db
          .collection("properties")
          .where('active', isEqualTo: true)
          .where('configProperty.days', arrayContains: days[0])
          .getDocuments();

      var timesheetQuery = GenericFirestoreService.db
          .collection("timesheet")
          .where('dateCheckIn', isGreaterThanOrEqualTo: date.rangeFrom().utc())
          .where('dateCheckIn', isLessThanOrEqualTo: date.rangeTo().utc())
          .getDocuments();

      var data = await Future.wait([propertiesQuery, timesheetQuery]);
      var timesheetSnapshot = data[1];
      var propertiesSnapshot = data[0];

      List<TimesheetModel> timesheets = [];
      List<TimesheetModel> checkInsSlots = [];
      if (timesheetSnapshot.documents.isNotEmpty) {
        timesheets = timesheetSnapshot.documents.map((snapshot) {
          var data = snapshot.data;
          return TimesheetModel.fromJson(data);
        }).toList();
      }

      if (propertiesSnapshot.documents.isNotEmpty) {
        for (var i = 0; i < propertiesSnapshot.documents.length; i++) {
          var property = propertiesSnapshot.documents[i].data;
          var porters = property['configProperty']['porters'];

          var format = DateFormat("HH:mm");
          var start = format.parse(property['configProperty']['startTime']);
          var end = format.parse(property['configProperty']['endTime']);

          if (porters != null) {
            for (var j = 0; j < porters.length; j++) {
              //DaysSelected daySelected = property['configProperty']['daysSelected'].firstWhere((day) => day['nameDay'] == days[0]);

              TimesheetModel timesheetFound;
              var porter = Porter.fromJson(porters[j]);
              if (timesheets.length > 0) {
                timesheetFound =
                    _findTimesheet(timesheets, porter.id, property['id'], date);
                if (timesheetFound != null) {
                  timesheets.remove(timesheetFound);
                }
              }

              bool temporaryEval = false;

              if (timesheetFound == null &&
                  porter.temporary != null &&
                  porter.temporary) {
                if (porter.temporaryDate != null) {
                  if (!TimestampUtils.equalDay(date, porter.temporaryDate)) {
                    continue;
                  } else {
                    temporaryEval = true;
                  }
                }
              }


              var status =
                  _getStatus(date, start, end, timesheetFound, property);

              checkInsSlots.add(
                _getTimesheet(
                    timesheetFound,
                    property['id'],
                    property['propertyName'],
                    porter.id,
                    porter.firstName + " " + porter.lastName,
                    temporaryEval,
                    true,
                    DateFormat.jm().format(start),
                    DateFormat.jm().format(end),
                    status),
              );
            }
          }
        }
      }

      if (timesheets.length > 0) {
        for (var i = 0; i < timesheets.length; i++) {
          checkInsSlots.add(_getTimesheet(
              timesheets[i],
              timesheets[i].propertyId,
              timesheets[i].propertyName,
              timesheets[i].employeId,
              timesheets[i].employeeName,
              timesheets[i].isTemporaryPorter != null
                  ? timesheets[i].isTemporaryPorter
                  : false,
              !timesheets[i].isV2Entity,
              "",
              "",
              "Completed"));
        }
      }

      if (checkInsSlots.length > 0) {
        this._streamController.add(checkInsSlots);
      } else {
        this._streamController.add([_defaultModel()]);
      }
    } catch (e, st) {
      handleException(e, "getAllTimeSheet", st);
      this._streamController.add([_defaultModel()]);
    }
  }

  _defaultModel(){
    return TimesheetModel.fromJson({
      "id": "empty_shifts",
      "colorStatus": Colors.grey[300]
    });
  }


  String _getStatus(WrappedDate date, DateTime from, DateTime to,
      TimesheetModel sheet, Map<String, dynamic> property) {
    var localDate = WrappedDate.now();

    if (sheet == null &&
        date.rangeFrom().local().isBefore(localDate.rangeFrom().local())) {
      return "Missed";
    }

    from = DateTime(date.local().year, date.local().month, date.local().day,
        from.hour, from.minute, from.second);
    to = DateTime(date.local().year, date.local().month, date.local().day,
        to.hour, to.minute, to.second);

    var propertyDateLocal = TimestampUtils.convertToLocalTime(
        property['lat'], property['lng'], localDate.local());

    if (from.isAfter(to)) {
      to = to.add(Duration(days: 1));
    }

    if (sheet != null) {
      return sheet.dateCheckOut != null ? "Completed" : "InProgress";
    }

    if (propertyDateLocal.isBefore(from)) {
      return "Pending";
    }

    if (propertyDateLocal.isAfter(to)) {
      return "Missed";
    }

    return "Pending";
  }


  Color _getStatusColor(String status) {
    switch (status) {
      case 'InProgress':
        return ColorsUtils.getMaterialColor(0xFFFFEC33);
      case 'Missed':
        return ColorsUtils.getMaterialColor(0xFFf44336);
      case 'Completed':
        return ColorsUtils.getMaterialColor(0xFF3a8d1d);
      default:
        return Colors.grey[300];
    }
  }

  _getTimesheet(
      TimesheetModel timesheetFound,
      String propertyId,
      String propertyName,
      String employeeId,
      String employeeName,
      bool temporaryEval,
      bool shiftActive,
      String startTime,
      String endTime,
      String status) {
    var ts2 = TimesheetModel.fromJson({
      "employeId": employeeId,
      "employeeName": employeeName,
      "propertyId": propertyId,
      "propertyName": propertyName,
      "status": status,
      "colorStatus": Colors.grey[300]
    });

    ts2.shiftActive = shiftActive;
    ts2.startTime = startTime;
    ts2.endTime = endTime;
    ts2.colorStatus = _getStatusColor(status);
    if (timesheetFound != null) {
      ts2.id = timesheetFound.id;
      ts2.status = timesheetFound.status;
      ts2.checkInId = timesheetFound.checkInId;
      ts2.dateCheckIn = timesheetFound.dateCheckIn;
      ts2.dateCheckOut = timesheetFound.dateCheckOut;
      ts2.checkInByAdmin = timesheetFound.checkInByAdmin;
      ts2.dateCheckInByAdmin = timesheetFound.dateCheckInByAdmin;
      ts2.commentByAdmin = timesheetFound.commentByAdmin;
      ts2.isTemporaryPorter = (timesheetFound.isTemporaryPorter != null &&
              timesheetFound.isTemporaryPorter) ||
          temporaryEval;
    } else {
      ts2.isTemporaryPorter = temporaryEval;
    }

    return ts2;
  }

  _findTimesheet(List<TimesheetModel> models, String employeeId,
      String propertyId, WrappedDate date) {
    for (var i = 0; i < models.length; i++) {
      if (models[i].dateCheckIn != null) {
        if (models[i].employeId == employeeId &&
            models[i].propertyId == propertyId &&
            TimestampUtils.equalDay(models[i].dateCheckIn, date)) {
          return models[i];
        }
      } else if (models[i].dateCheckInByAdmin != null) {
        if (models[i].employeId == employeeId &&
            models[i].propertyId == propertyId &&
            TimestampUtils.equalDay(models[i].dateCheckInByAdmin, date)) {
          return models[i];
        }
      }
    }

    return null;
  }

  Stream<List<TimesheetModel>> startStream(WrappedDate lastDateLoaded) {
    if (_streamController != null && !_streamController.isClosed) {
      _streamController.close();
    }

    _streamController = StreamController<List<TimesheetModel>>.broadcast();
    loadTimesheetByDate(lastDateLoaded);
    return _streamController.stream;
  }
}
