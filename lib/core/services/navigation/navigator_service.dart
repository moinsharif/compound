
import 'dart:async';

import 'package:compound/core/services/navigation/navigator_instance.dart';
import 'package:compound/core/services/navigation/navigator_routes.dart';
import 'package:flutter/material.dart';

class NavigatorService{

    String loginFrom;

    List<NavigatorInstance> _instances = [];
    final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
    final _pageChangeStream = new StreamController<dynamic>.broadcast();

    Stream<dynamic> get onChangePage => _pageChangeStream.stream;

    initialize(Map<String, RoutePageCreator> routes, [String initialRoute]){
        _instances.add(NavigatorInstance("root",  NavigatorRoutes(routes)));
    }

    dispose(){
        _pageChangeStream.close();
    }

    buildNavigator(String name, Map<String, RoutePageCreator> routes, [String initialRoute]){ 
        //assert(_instances.firstWhere((element) => element.name == name, orElse: () => null) == null);

        var existing = _instances.firstWhere((element) => element.name == name, orElse: () => null);
        if(existing != null){
           return Navigator(
            onGenerateRoute: existing.routes.generateRoute,
            key: existing.navigatorKey,
            initialRoute : initialRoute
           );
        }

        var navigatorRoutes = NavigatorRoutes(routes);
        var navigatorInstance = NavigatorInstance(name, navigatorRoutes);

        _instances.add(navigatorInstance);

        return Navigator(
            onGenerateRoute: navigatorRoutes.generateRoute,
            key: navigatorInstance.navigatorKey,
            initialRoute : initialRoute
        );
    }

    navigatorKey([name]){
       return  _findInstanceByName(name)?.navigatorKey;
    }

    generatedRoutes([name]){
       return  _findInstanceByName(name).routes.generateRoute;
    }

    /*Future<T> navigateToPage<T>(MaterialPageRoute<T> pageRoute) async {
        throw 'Uninmplemented method';
    }*/

    void pop<T>([String navigatorName, T result]) {
        _findInstanceByName(navigatorName).pop(result);
    }

    Future<T> navigateToPageWithReplacement<T>(String routeName, {String navigatorName, int menuId, dynamic arguments, String title}){
          var instance = navigatorName != null? _findInstanceByName(navigatorName) : _findInstanceByRouteName(routeName);
      
        _pageChangeStream.sink.add({"route": routeName, "menuId": menuId, "title":title, "args":arguments});
        if(instance != null){
          return instance.navigateToPageWithReplacement(routeName, arguments: arguments);
        }
        return null;
    }

    Future<dynamic> navigateTo(String routeName, {String navigatorName, int menuId, dynamic arguments, String title}) {
        var instance = navigatorName != null? _findInstanceByName(navigatorName) : _findInstanceByRouteName(routeName);
      
        _pageChangeStream.sink.add({"route": routeName, "menuId": menuId, "title":title, "args":arguments});
        if(instance != null){
          return instance.navigateTo(routeName, arguments: arguments);
        }
        return null;
    }

    navigateToAndRemoveUntil(String routeName, bool Function(Route<dynamic>) predicate, {String navigatorName}){
        var instance = navigatorName != null? _findInstanceByName(navigatorName) : _findInstanceByRouteName(routeName);
      
        _pageChangeStream.sink.add(routeName);
        if(instance != null){
          instance.navigateToAndRemoveUntil(routeName, predicate);
        }
    }

    navigateBack({dynamic arguments, String navigatorName, String title}){
      _pageChangeStream.sink.add({"title":title});
       var instance = _findInstanceByName(navigatorName != null? navigatorName : "root");
       instance.pop(arguments);
    }

    NavigatorInstance _findInstanceByRouteName(String routeName){
       assert(_instances != null && _instances.length > 0);

       NavigatorInstance instance;
       for(var i = 0; i < _instances.length; i++){
          if(_containsRoutes(routeName, _instances[i].routes.routes.keys.toList())){
            instance = _instances[i];
            break;
          }
       }

       return instance;
    }

    NavigatorInstance _findInstanceByName([String name]){
       return name == null? _instances.first : _instances.firstWhere((element) => element.name == name);
    }

    bool _containsRoutes(String routeName, List<String> routes){
       return routes.contains(routeName);
    }
}