

import 'package:compound/core/base/base_service.dart';
import 'package:compound/core/services/navigation/navigator_routes.dart';
import 'package:flutter/material.dart';

class NavigatorInstance extends BaseService {
  
  final String name;
  final NavigatorRoutes routes;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  NavigatorInstance(this.name, this.routes);
  

  Future<T> navigateToPage<T>(MaterialPageRoute<T> pageRoute) async {
    log.i('navigateToPage (${this.name}): pageRoute: ${pageRoute.settings.name}');
    if (navigatorKey.currentState == null) {
      log.e('navigateToPage (${this.name}): Navigator State is null');
      return null;
    }
    return navigatorKey.currentState.push(pageRoute);
  }

  Future<dynamic> navigateToPageWithReplacement(String routeName, {dynamic arguments}) async {
    log.i('navigateToPageWithReplacement (${this.name}): '
      'pageRoute: $routeName');
    if (navigatorKey.currentState == null) {
      log.e('navigateToPageWithReplacement (${this.name}): Navigator State is null');
      return null;
    }
    return navigatorKey.currentState.pushReplacement(routes.getPageRouteByRouteName(routeName: routeName, arguments: arguments));
  }

  void pop<T>([T result]) {
    log.i('goBack (${this.name}):');
    if (navigatorKey.currentState == null) {
      log.e('goBack (${this.name}): Navigator State is null');
      return;
    }
    navigatorKey.currentState.pop(result);
  }

  navigateToAndRemoveUntil(String routeName, bool Function(Route<dynamic>) predicate){
    log.i('navigateToPageAndRemoveUntil (${this.name}): pageRoute: $routeName');
    return navigatorKey.currentState.pushNamedAndRemoveUntil(routeName, predicate);
  }

  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    log.i('navigateToPage (${this.name}): pageRoute: $routeName');
    return navigatorKey.currentState.pushNamed(routeName, arguments: arguments);
  }
}