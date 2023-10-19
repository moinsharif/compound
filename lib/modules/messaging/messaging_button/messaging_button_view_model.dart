import 'dart:async';

import 'package:compound/constants.dart';
import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/modules/messaging/services/messaging_services.dart';
import 'package:compound/router.dart';

class MessagingButtonViewModel extends BaseViewModel {
  NavigatorService _navigatorService = locator<NavigatorService>();
  MessagingService _messagingService = locator<MessagingService>();
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  int _counter = 0;
  int get counter => _counter;

  bool visible = true;

  void navigateToMessages() {
    _authenticationService.changeindexMenuButtonStream(2);
    _navigatorService.navigateTo(MessagingViewRoute,
        title: ConstantsRoutePage.MESSAGES);
  }

  StreamSubscription<int> _counterSuscription$;
  StreamSubscription<bool> _loginSuscription$;

  @override
  void dispose() {
    if (_counterSuscription$ != null) _counterSuscription$.cancel();

    if (_loginSuscription$ != null) _loginSuscription$.cancel();

    super.dispose();
  }

  void load() {
    /*if(_authenticationService.loginWorkflow != AuthenticationService.athlete &&
         _authenticationService.loginWorkflow != AuthenticationService.recruiter){
           visible = false;
           this.notifyListeners();
           return;
      }*/

    if (_authenticationService.currentUser == null) {
      visible = false;
      this.notifyListeners();
      return;
    }

    _counterSuscription$ =
        _messagingService.pendingReadsCounterStream.listen((value) {
      _counter = value;
      this.notifyListeners();
    });

    _loginSuscription$ =
        _authenticationService.loginStatusChangeStream.listen((value) {
      visible = value;
      this.notifyListeners();
    });
  }
}
