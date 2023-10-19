import 'package:compound/constants.dart';
import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/dialog_service.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/core/services/ui/ui_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/router.dart';
import 'package:compound/shared_models/property_model.dart';
import 'package:compound/shared_models/violation_model.dart';
import 'package:compound/shared_services/property_service.dart';
import 'package:compound/shared_services/reports_service.dart';
import 'package:compound/shared_services/violation_service.dart';
import 'package:compound/utils/timestamp_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

class AllViolationViewModel extends BaseViewModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final ViolationService _violationService = locator<ViolationService>();
  final PropertyService _propertyService = locator<PropertyService>();
  final NavigatorService _navigatorService = locator<NavigatorService>();
  final UIService _uiService = locator<UIService>();
  final TextEditingController propertyController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final ReportsService reportService = locator<ReportsService>();
  PropertyModel propertySelected;
  List<ViolationModel> violations = [];
  List<PropertyModel> properties = [];
  bool changeFlag = false;
  bool sendingReport = false;
  DateTimeRange selectedDateRange;

  bool openBoxProperty = false;
  final SuggestionsBoxController propertyBoxController =
      SuggestionsBoxController();

  @override
  dispose() {
    super.dispose();
    _uiService.hidden(stream: _uiService.filterViolationsHeaderStream);
  }

  Future<void> load() async {
    setBusy(true);
    _authenticationService.changeindexMenuButtonStream(4);
    properties = await _propertyService.getPropertiesAll(true);
    _uiService.show(
        stream: _uiService.filterViolationsHeaderStream,
        function: () => _navigatorService
            .navigateToPageWithReplacement(FilterViolationViewRoute));

    await loadViolations();
    setBusy(false);
  }

  Future<void> loadViolations() async {
    setBusy(true);
    if (kIsWeb) {
      violations = await _violationService.getViolations(
          start: selectedDateRange?.start != null
              ? TimestampUtils.wdRangeFrom(selectedDateRange.start)
              : null,
          end: selectedDateRange?.end != null
              ? TimestampUtils.wdRangeTo(selectedDateRange.end)
              : null,
          propertyId: propertySelected?.id ?? null);
    } else {
      violations = await _violationService.getFirstViolations(
          start: selectedDateRange?.start != null
              ? TimestampUtils.wdRangeFrom(selectedDateRange.start)
              : null,
          end: selectedDateRange?.end != null
              ? TimestampUtils.wdRangeTo(selectedDateRange.end)
              : null,
          propertyId: propertySelected?.id ?? null);
    }
    await Future.forEach(
        violations,
        (ViolationModel element) => {
              if (element.reportWasGenerated == null ||
                  !element.reportWasGenerated)
                {addItemToReport(element)}
            });
    setBusy(false);
  }

  Future<void> loadMoreViolations() async {
    List<ViolationModel> more = await _violationService.getMoreViolations(
        start: selectedDateRange?.start != null
            ? TimestampUtils.wdRangeFrom(selectedDateRange.start)
            : null,
        end: selectedDateRange?.end != null
            ? TimestampUtils.wdRangeTo(selectedDateRange.end)
            : null,
        propertyId: propertySelected?.id ?? null);
    if (more.isNotEmpty) {
      violations = [...violations, ...more];
    }
    notifyListeners();
  }

  void addItemToReport(ViolationModel violation, {bool remove = false}) {
    if (remove) {
      reportService.remove(violation.id);
    } else {
      reportService.add(violation.id);
    }
    notifyListeners();
  }

  void clearReports() {
    this.reportService.clearReports();
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

  String loadHours(DateTime date) {
    final DateFormat formatterHour = DateFormat('hh:mm a');
    return formatterHour.format(date);
  }

  Future<dynamic> goToViolationsProperty(
      int index, ViolationModel violation) async {
    await _navigatorService.navigateTo(ViolationByPropertyViewRoute,
        arguments: violation.propertyId,
        title: violation.property.propertyName);
  }

  String formatDateRange(DateTime date) {
    final DateFormat formatter = DateFormat('MMM dd, yyyy');
    return formatter.format(date);
  }

  Future<void> clearFilters() async {
    selectedDateRange = null;
    propertySelected = null;
    propertyController.text = '';
    reportService.clearReports();
    await loadViolations();
    notifyListeners();
  }

  Future<void> sendReport() async {
    try {
      loadingSending();
      await _violationService.sendReport(reportService.getArray);
      reportService.clearReports();

      loadingSending();
      ScaffoldMessenger.of(locator<DialogService>().scaffoldKey.currentContext)
          .showSnackBar(SnackBar(
        content: Text('Report sent success'),
      ));
      notifyListeners();
    } catch (e) {
      ScaffoldMessenger.of(locator<DialogService>().scaffoldKey.currentContext)
          .showSnackBar(SnackBar(
        content: Text('Something went wrong'),
      ));
      loadingSending();
    }
  }

  void loadingSending() {
    this.sendingReport = !this.sendingReport;
    notifyListeners();
  }

  void selectDateRange(DateTimeRange v) {
    selectedDateRange = v;
    this.loadViolations();
    notifyListeners();
  }

  void changeArrowPositionProperty(bool value, {String opneBox}) {
    this.openBoxProperty = value;
    if (opneBox == 'open') {
      this.propertyBoxController.open();
    } else if (opneBox == 'close') {
      this.propertyBoxController.close();
    }
    notifyListeners();
  }

  void cleanController() {
    this.propertyController.text = '';
    notifyListeners();
  }

  void setTextController(String text) {
    this.propertyController.text = text;
    notifyListeners();
  }

  void textControllerIsEmpty() {
    this.notifyListeners();
  }

  Future<List<PropertyModel>> getProperties(String pattern) async {
    if (properties == null) {
      return List<PropertyModel>.empty();
    }

    return this
        .properties
        .where((PropertyModel element) =>
            element.propertyName.toLowerCase().indexOf(pattern.toLowerCase()) >=
            0)
        .toList();
  }

  Future<void> changeText(ViolationModel violation) async {
    violation.activeEdit = !violation.activeEdit;
    notifyListeners();
  }

  Future<void> updateTextViolation(ViolationModel violation) async {
    await _propertyService.updateTextViolation(
        violation.id, violation.description);
    violations[violations.indexOf(violation)].description =
        violation.description;
    this.changeText(violation);
    notifyListeners();
  }
}
