import 'package:compound/config.dart';
import 'package:compound/constants.dart';
import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/router.dart';
import 'package:compound/shared_models/violation_model.dart';
import 'package:compound/shared_services/property_service.dart';
import 'package:compound/shared_services/reports_service.dart';
import 'package:compound/shared_services/violation_service.dart';
import 'package:intl/intl.dart';

class AuxCheckInModel {
  String checkInId;

  AuxCheckInModel({this.checkInId});
}

class ViolationByPropertyViewModel extends BaseViewModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final ViolationService _violationService = locator<ViolationService>();
  final PropertyService _propertyService = locator<PropertyService>();
  final NavigatorService _navigatorService = locator<NavigatorService>();
  List<ViolationModel> violations = [];
  bool changeFlag = false;
  bool changeTextInstructions = false;
  bool isSingleViolation = false;
  bool isReviewCheckIn = false;
  double _currentPage = 0.0;
  double get currentPage => this._currentPage;
  set currentPage(double currentPage) {
    this._currentPage = currentPage;
    notifyListeners();
  }

  @override
  dispose() async {
    if (isReviewCheckIn) {
      _authenticationService.textAppBarStream.add(ConstantsRoutePage.MANAGE);
    } else {
      _authenticationService.textAppBarStream.add(Config.violations);
    }
    super.dispose();
  }

  Future<void> load(var violation) async {
    setBusy(true);
    if (violation is String) {
      violations = await _violationService.getViolationsById(violation);
    } else if (violation is AuxCheckInModel) {
      isReviewCheckIn = true;
      violations =
          await _violationService.getViolationsByChackInId(violation.checkInId);
    } else if (null != violation) {
      violations.add(violation);
      this.isSingleViolation = true;
      _authenticationService.changeindexMenuButtonStream(4);
    }
    setBusy(false);
  }

  void updatePropertyFlagged(ViolationModel violation, String text,
      {flaged = false}) async {
    this.changeFlag = true;
    if (flaged) {
      bool _flagged = !violation.property.flagged;
      String updateFlagged = await _propertyService.updatePropertyFlag(
          violation.propertyId, !violation.property.flagged, text);
      if (updateFlagged != null) {
        violations.asMap().forEach((index, e) {
          if (e.propertyId == violation.propertyId) {
            violations[index].property = violations[index]
                .property
                .copyWith(flagged: _flagged, specialInstructions: text);
          }
        });
      }
    } else {
      bool _flagged = !violation.property.flagged;
      String updateFlagged = await _propertyService.updatePropertyFlag(
          violation.propertyId,
          !violation.property.flagged,
          violation.property.specialInstructions);
      if (updateFlagged != null) {
        violations.asMap().forEach((index, e) {
          if (e.propertyId == violation.propertyId) {
            violations[index].property =
                violations[index].property.copyWith(flagged: _flagged);
          }
        });
      }
    }
    this.changeFlag = false;
    notifyListeners();
  }

  Future<void> updateTextViolation(
      ViolationModel violation, String text) async {
    await _propertyService.updateTextViolation(violation.id, text);
    violations[violations.indexOf(violation)].description = text;
    this.changeText();
    notifyListeners();
  }

  String loadHours(DateTime date) {
    final DateFormat formatterHour = DateFormat('hh:mm a');
    return formatterHour.format(date);
  }

  void addItemToReport(ViolationModel violation, {bool remove = false}) {
    if (remove) {
      locator<ReportsService>().remove(violation.id);
    } else {
      locator<ReportsService>().add(violation.id);
    }
    notifyListeners();
  }

  String loadDates(DateTime date) {
    final DateFormat formatterDate = DateFormat('MM/dd/yy');
    return formatterDate.format(date);
  }

  Future<dynamic> navigatoToBack() async {
    if (this.isSingleViolation) {
      await _navigatorService.navigateToPageWithReplacement(
          AllViolationViewRoute,
          title: Config.violations);
    } else {
      await _navigatorService.navigateBack();
    }
  }

  Future<void> changeText() async {
    this.changeTextInstructions = !this.changeTextInstructions;
    notifyListeners();
  }
}
