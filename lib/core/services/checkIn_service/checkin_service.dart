import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/core/base/base_service.dart';
import 'package:compound/core/services/checkIn_service/_checkin_repository_movile.dart';
import 'package:compound/shared_models/checkIn_model.dart';
import 'package:compound/shared_models/days_selected.dart';
import 'package:compound/shared_models/property_model.dart';
import 'package:compound/utils/timestamp_util.dart';

class CheckInService extends BaseService {
  CheckInRepository _repository;
  CheckInModel _currentCheckIn;

  CheckInModel get currentCheckIn => _currentCheckIn;

  CheckInService() {
    _repository = CheckInRepository();
  }

  void saveCheckInTransact(CheckInModel checkin, WriteBatch batch) {
    _repository.saveCheckInTransact(checkin, batch);
  }

  void updateCheckInTransact(CheckInModel entity, WriteBatch batch) {
    _repository.updateCheckInTransact(entity, batch);
  }

  Future<String> createCheckIn(CheckInModel checkInModel) async {
    return await _repository.setCheckIn(checkInModel);
  }

  Future<CheckInModel> getLastCheckIn() async {
    return await _repository.lastCheckIn();
  }

  Future<CheckInModel> getfirstCheckIn() async {
    return await _repository.firstCheckIn();
  }

  Future<List<CheckInModel>> getCheckInsByDate(
      WrappedDate star, WrappedDate end) async {
    return await _repository.getCheckInsByDate(star, end);
  }

  Future<List<CheckInModel>> getCheckInsByDateAndEmployee(
      DateTime star, DateTime end, String employeeId) async {
    return await _repository.getCheckInsByDateAndEmployee(
        star, end, employeeId);
  }

  Future<CheckInModel> loadCurrentCheckIn() async {
    try {
      if (_currentCheckIn != null) {
        return _currentCheckIn;
      }
      _currentCheckIn = await _repository.loadCurrentCheckIn();
      if (_currentCheckIn == null) {
        return null;
      }
      var property =
          await _repository.getPropertyCheckIn(_currentCheckIn.propertyId);
      if (property != null) {
        _currentCheckIn.property = property;
      }
      return _currentCheckIn;
    } catch (e, st) {
      handleException(e, "loadCurrentCheckIn", st);
      return null;
    }
  }

  Future<void> updateCheckIn(CheckInModel checkIn) async {
    return await _repository.updateCheckIn(checkIn);
  }

  void updateLocalCheckIn(CheckInModel checkIn) {
    _currentCheckIn = checkIn;
  }

  CheckInModel newCheckInModel(WrappedDate now,
      PropertyModel property, String employeeId, String employeeName) {

    var isTemporaryPorter = property.configProperty.porters.toList().firstWhere(
        (element) =>
            element.id == employeeId &&
            element.temporary != null &&
            element.temporary &&
            TimestampUtils.equalDay(now, element.temporaryDate),
        orElse: () => null);

    this._currentCheckIn = new CheckInModel();
    this._currentCheckIn.id = now.utc().millisecondsSinceEpoch.toString();
    this._currentCheckIn.marketId = property.marketId;
    this._currentCheckIn.marketName = property.marketName;
    this._currentCheckIn.propertyId = property.id;
    this._currentCheckIn.propertyName = property.propertyName;
    this._currentCheckIn.units = property.units;
    this._currentCheckIn.documentIncidents = false;
    this._currentCheckIn.wage = property.configProperty.daysSelected
        .firstWhere(
          (element) => element.id == TimestampUtils.currentWeekDay(),
          orElse: () => new DaysSelected(rate: 15),
        )
        .rate;
    this._currentCheckIn.employeedId = employeeId;
    this._currentCheckIn.employeedName = employeeName;
    this._currentCheckIn.dateCheckIn = now;
    this._currentCheckIn.dateCheckInTz = TimestampUtils.timezone();
    this._currentCheckIn.property = property;
    this._currentCheckIn.isTemporaryPorter = isTemporaryPorter != null;
    return this._currentCheckIn;
  }

  clearCurrentCheckIn() {
    _repository.clearCheckIn();
    this._currentCheckIn = null;
  }
}
