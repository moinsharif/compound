import 'dart:convert';

import 'package:compound/constants.dart';
import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/router.dart';
import 'package:compound/shared_models/market_model.dart';
import 'package:compound/shared_models/timesheet_model.dart';
import 'package:compound/shared_services/market_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

Future<List<MarketModel>> fetchMarkets() async {
  final String response =
      await rootBundle.loadString('assets/data/new_table_states_markets.json');
  return compute(parseMarketJson, response);
}

List<MarketModel> parseMarketJson(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<MarketModel>((json) => MarketModel.fromData(json)).toList();
}

class AddMarketsViewModel extends BaseViewModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigatorService _navigatorService = locator<NavigatorService>();
  final MarketService _marketService = locator<MarketService>();
  final SuggestionsBoxController propertyBoxController =
      SuggestionsBoxController();
  bool openBoxProperty = false;
  bool loading = true;

  List<MarketModel> markets = [];
  List<MarketModel> currentMarkets = [];
  List<MarketModel> selectedMarkets = [];

  @override
  dispose() {
    super.dispose();
  }

  Future<void> load(Object arguments) async {
    currentMarkets = arguments;
    markets = await fetchMarkets();
    loading = false;
    notifyListeners();
  }

  String loadHours(DateTime date) {
    final DateFormat formatterHour = DateFormat('hh:mm a');
    return date != null ? formatterHour.format(date) : '--';
  }

  Future<dynamic> goToHome() async {
    await _navigatorService.navigateTo(HomeViewRoute);
  }

  Future<dynamic> goToBack({bool backWithoutSave = false}) async {
    await _navigatorService.navigateBack(
        arguments: backWithoutSave ? [] : selectedMarkets,
        title: ConstantsRoutePage.MARKETS);
  }

  void changeArrowPositionStreet(bool value, {String opneBox}) {
    this.openBoxProperty = value;
    if (opneBox == 'open') {
      this.propertyBoxController.open();
    } else if (opneBox == 'close') {
      this.propertyBoxController.close();
    }
    notifyListeners();
  }

  Future<List<MarketModel>> getMarkets(String pattern) async {
    if (markets == null) {
      return List<MarketModel>.empty();
    }

    return this
        .markets
        .where((MarketModel element) =>
            element.name.toLowerCase().indexOf(pattern.toLowerCase()) >= 0 &&
            currentMarkets.indexWhere((current) => current.id == element.id) ==
                -1)
        .take(5)
        .toList();
  }

  void removeMarket(MarketModel removeMarket) {
    markets = [...markets, removeMarket];
    selectedMarkets.removeWhere((element) => element.id == removeMarket.id);
    notifyListeners();
  }

  void addMarket(MarketModel addMarket) {
    if (currentMarkets.isEmpty ||
        currentMarkets.indexWhere((element) => element.id == addMarket.id) ==
            -1) {
      selectedMarkets = [...selectedMarkets, addMarket];
      markets.removeWhere((element) => element.id == addMarket.id);
      notifyListeners();
    }
  }

  Future<bool> updateMarkets() async {
    setBusy(true);
    if (await _marketService.setMarkets(selectedMarkets)) {
      setBusy(false);
      return true;
    } else {
      setBusy(false);
      return false;
    }
  }
}
