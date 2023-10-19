import 'package:compound/constants.dart';
import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/router.dart';
import 'package:compound/shared_models/market_model.dart';
import 'package:compound/shared_services/market_service.dart';
import 'package:intl/intl.dart';

class AllMarketsViewModel extends BaseViewModel {
  final NavigatorService _navigatorService = locator<NavigatorService>();
  final MarketService _marketService = locator<MarketService>();

  List<MarketModel> markets = [];
  List<MarketModel> marketsRemoved = [];
  bool loading = true;

  @override
  dispose() {
    super.dispose();
  }

  Future<void> load() async {
    markets = await _marketService.getAllMarkets();
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

  void removeMarket(MarketModel market) {
    marketsRemoved = [...marketsRemoved, market];
    markets.removeWhere((element) => element.id == market.id);
    notifyListeners();
  }

  Future<dynamic> goToAddMarkets() async {
    markets = [...markets, ...marketsRemoved];
    await _navigatorService
        .navigateTo(
      AddMarketsViewRoute,
      arguments: markets,
      title: ConstantsRoutePage.ADDMARKETS,
    )
        .then((value) {
      markets = [...markets, ...value];
      notifyListeners();
    });
  }

  Future<bool> removeMarketsDatabase() async {
    setBusy(true);
    if (await _marketService.removeMarkets(marketsRemoved)) {
      marketsRemoved = [];
      setBusy(false);
      return true;
    } else {
      setBusy(false);
      return false;
    }
  }
}
