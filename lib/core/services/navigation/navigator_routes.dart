
import 'package:flutter/material.dart';

typedef Widget RoutePageCreator();

class NavigatorRoutes{

    Map<String, RoutePageCreator> routes;

    NavigatorRoutes(this.routes);

    Route<dynamic> generateRoute(RouteSettings settings) {
        return _getPageRoute(
            routeName: settings.name,
            arguments : settings.arguments,
            viewToShow: this.routes[settings.name] != null? this.routes[settings.name]() : this.routes["/"]()
        );
    }

    PageRoute _getPageRoute({String routeName, Widget viewToShow, dynamic arguments}) {
      return MaterialPageRoute(
          settings: RouteSettings(
            name: routeName,
            arguments: arguments
          ),
          builder: (_) => viewToShow);
    }

    PageRoute getPageRouteByRouteName({String routeName, dynamic arguments}) {
      return MaterialPageRoute(
          settings: RouteSettings(
            name: routeName,
            arguments: arguments
          ),
          builder: (_) => this.routes[routeName]());
    }

    getNonFoundPages(RouteSettings settings){
      return  Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}')),
              );
    }
}
