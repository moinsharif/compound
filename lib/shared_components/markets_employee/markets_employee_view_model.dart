import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/shared_models/market_model.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/shared_services/market_service.dart';

class MarketsEmployeeViewModel extends BaseViewModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final MarketService _marketService = locator<MarketService>();
  List<MarketModel> markers = [];

  Future<void> load() async {
    setBusy(true);
    if (_authenticationService.currentEmploye.markers.length > 0) {
      this.markers = await _marketService
          .getMarkets(_authenticationService.currentEmploye.markers);
    }
    setBusy(false);
    notifyListeners();
  }
}
