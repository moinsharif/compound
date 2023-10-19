import 'package:compound/config.dart';
import 'package:compound/constants.dart';
import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/router.dart';
import 'package:compound/shared_models/violation_model.dart';
import 'package:compound/shared_services/property_service.dart';
import 'package:compound/shared_services/violation_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViolationSummaryViewModel extends BaseViewModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final ViolationService _violationService = locator<ViolationService>();
  final PropertyService _propertyService = locator<PropertyService>();
  final NavigatorService _navigatorService = locator<NavigatorService>();
  final controller = PageController(initialPage: 1);
  List<ViolationModel> violations = [];
  double _currentPage = 0.0;
  double get currentPage => this._currentPage;
  set currentPage(double currentPage) {
    this._currentPage = currentPage;
    notifyListeners();
  }

  Future<void> load() async {
    setBusy(true);
    violations = await _violationService.getLastFiveViolations();
    setBusy(false);
  }

  String getImageExample() {
    return _authenticationService.currentUser.img;
  }

  void updatePropertyFlagged(ViolationModel violation, String text,
      {flaged = false}) async {
    setBusy(true);
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
    setBusy(false);
    notifyListeners();
  }

  String loadDates(DateTime date) {
    final DateFormat formatterHour = DateFormat('MM/dd/yy');
    return formatterHour.format(date);
  }

  Future<dynamic> goToAllViolations() async {
    await _navigatorService.navigateToPageWithReplacement(AllViolationViewRoute,
        title: Config.violations);
  }

  Future<dynamic> goToSingleViolation(ViolationModel e) async {
    await _navigatorService.navigateToPageWithReplacement(
        ViolationByPropertyViewRoute,
        arguments: e,
        title: Config.oneViolation + (this.currentPage.toInt() + 1).toString());
  }
}
