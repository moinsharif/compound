import 'package:compound/constants.dart';
import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/dialog_service.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/router.dart';
import 'package:compound/shared_models/property_model.dart';
import 'package:compound/shared_models/violation_model.dart';
import 'package:compound/shared_models/watchlist_model.dart';
import 'package:compound/shared_services/property_service.dart';
import 'package:compound/shared_services/reports_service.dart';
import 'package:compound/shared_services/violation_service.dart';
import 'package:compound/shared_services/watchlist_service.dart';
import 'package:compound/utils/timestamp_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

class AllWatchlistViewModel extends BaseViewModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final WatchlistService _watchlistService = locator<WatchlistService>();
  final PropertyService _propertyService = locator<PropertyService>();
  final NavigatorService _navigatorService = locator<NavigatorService>();
  final TextEditingController propertyController = TextEditingController();
  PropertyModel propertySelected;
  List<WatchlistModel> watchlists = [];
  List<PropertyModel> properties = [];
  bool changeFlag = false;
  bool sendingReport = false;
  bool selectProperty = false;
  DateTimeRange selectedDateRange;

  bool openBoxProperty = false;
  final SuggestionsBoxController propertyBoxController =
      SuggestionsBoxController();

  @override
  dispose() {
    super.dispose();
  }

  Future<void> load() async {
    setBusy(true);
    _authenticationService.changeindexMenuButtonStream(4);
    properties = await _propertyService.getPropertiesAll(true);
    await loadWatchlists();
    setBusy(false);
  }

  Future<void> loadWatchlists() async {
    setBusy(true);

    WrappedDate startDate;
    if (selectedDateRange != null && selectedDateRange.start != null) {
      startDate = WrappedDate.fromLocal(selectedDateRange.start);
    }
    WrappedDate endDate;
    if (selectedDateRange != null && selectedDateRange.end != null) {
      endDate = WrappedDate.fromLocal(selectedDateRange.end);
    }

    watchlists = await _watchlistService.getWatchlistCompleted(
        start: startDate,
        end: endDate,
        propertyId: propertySelected?.id ?? null);
    setBusy(false);
  }

  String loadHours(DateTime date) {
    final DateFormat formatterHour = DateFormat('hh:mm a');
    return formatterHour.format(date);
  }

  Future<dynamic> goToViolationsProperty(ViolationModel violation) async {
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
    await loadWatchlists();
    notifyListeners();
  }

  Future<void> sendReport() async {
    try {
      loadingSending();
      List<String> ids = watchlists.map((e) => e.id).toList();
      await locator<ViolationService>().sendReportWatchlist(ids);
      loadingSending();
      ScaffoldMessenger.of(locator<DialogService>().scaffoldKey.currentContext)
          .showSnackBar(SnackBar(
        content: Text('Report sent success'),
      ));
      this.clearFilters();
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
    this.loadWatchlists();
    notifyListeners();
  }

  void textControllerIsEmpty() {
    this.notifyListeners();
  }

  void cleanController() {
    this.propertyController.text = '';
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
}
