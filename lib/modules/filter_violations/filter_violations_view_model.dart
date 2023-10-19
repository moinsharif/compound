import 'package:compound/constants.dart';
import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/router.dart';
import 'package:compound/shared_models/market_model.dart';
import 'package:compound/shared_models/property_model.dart';
import 'package:compound/shared_models/timesheet_model.dart';
import 'package:compound/shared_services/market_service.dart';
import 'package:compound/shared_services/property_service.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

class FilterViolationViewModel extends BaseViewModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigatorService _navigatorService = locator<NavigatorService>();
  final MarketService _marketService = locator<MarketService>();
  final PropertyService _propertyService = locator<PropertyService>();
  DateTime selectedDate;
  PropertyModel propertySelected;
  bool openBoxMarket = false;
  final SuggestionsBoxController marketBoxController =
      SuggestionsBoxController();

  List<PropertyModel> propertiesByFilter = [];
  List<PropertyModel> properties = [];
  bool loading = true;

  @override
  dispose() {
    super.dispose();
  }

  Future<void> load() async {
    await this.loadProperties();
    loading = false;
    notifyListeners();
  }

  Future<void> loadProperties() async {
    properties = await _propertyService.getPropertiesByFilter(
        date: selectedDate, propertyId: propertySelected?.id ?? null);
    if (propertiesByFilter.isEmpty) {
      propertiesByFilter = properties;
    }
    notifyListeners();
  }

  String loadDate(DateTime date) {
    final DateFormat formatterHour = DateFormat('MM/dd/yyyy');
    return date != null ? formatterHour.format(date) : 'mm/dd/yyyy';
  }

  Future<dynamic> goToHome() async {
    await _navigatorService.navigateTo(HomeViewRoute);
  }

  void changeArrowPositionMarket(bool value, {String opneBox}) {
    this.openBoxMarket = value;
    if (opneBox == 'open') {
      this.marketBoxController.open();
    } else if (opneBox == 'close') {
      this.marketBoxController.close();
    }
    notifyListeners();
  }

  String visitedDateTransform(DateTime date) {
    final DateFormat formatterHour = DateFormat('MM/dd/yyyy');
    return date != null ? formatterHour.format(date) : '--';
  }

  Future<List<PropertyModel>> getMarkets(String pattern) async {
    if (propertiesByFilter == null) {
      return List<PropertyModel>.empty();
    }

    return this
        .propertiesByFilter
        .where((PropertyModel element) =>
            element.propertyName.toLowerCase().indexOf(pattern.toLowerCase()) >=
            0)
        .toList();
  }

  Future<void> clearFilters() async {
    this.selectedDate = null;
    this.propertySelected = null;
    this.openBoxMarket = false;
    this.marketBoxController.close();
    await this.loadProperties();
    notifyListeners();
  }
}
