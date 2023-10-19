
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/locator.dart';
//import 'package:compound/modules/profile/services/profile_service.dart';
import 'package:compound/router.dart';
import 'package:flutter/material.dart';

 
class ContentService { 

    static final String academics = 'Academics';
    static final String nutrition = 'Nutrition';
    static final String generalNews = 'General News';
    static final String recruitingAdvice = 'Recruiting Advice';
    static final String strenghtConditioning = 'Strength & Conditioning';

    dynamic latestArguments;

    List<dynamic> _content;
    final AuthenticationService _authenticationService = locator<AuthenticationService>();
    final NavigatorService _navigatorService  = locator<NavigatorService>();

    ContentService(){
      this.initialize();
    }

    initialize(){

      this._content =  <dynamic>[
        { "role": ["athlete"], "page" : Container(),                    "route": HomeViewRoute,          "titleLabel": "",                 "drawerLabel" : "Home",                      "displayInTabs": false, "icon" : ""},

        { "role": ["athlete", "recruiter"],   "page" : rootPath[MessagingViewRoute],  "route": MessagingViewRoute, "titleLabel": "MESSAGES",      "drawerLabel" : "Messages",   "displayInTabs": false, "icon" : Icons.chat},

        { "role": ["recruiter"],   "page" : "",  "route": "",    "titleLabel": "Divider",      "drawerLabel" : "Divider",   "displayInTabs": false, "icon" : "", "default": true},

        { "role": ["athlete", "recruiter"], "page" : rootPath[SubscriptionsViewRoute],    "route": SubscriptionsViewRoute,      "titleLabel": "",                 "drawerLabel" : "Subscription",                  "displayInTabs": false, "icon" : Icons.subscriptions, "args": { "showdrawer" : false }},
        { "role": ["athlete", "athlete_pending_profile", "admin","recruiter"], "page" : "", "action": _actionLogout,    "titleLabel": "",  "drawerLabel" : "Log Out",          "displayInTabs": false,  "icon" : ""},
      ];  

      for(var i = 0; i < this._content.length; i++){
          if(_content[i]["route"] != null && _content[i]["route"] != ""){
             _content[i]["action"] = () => _actionNavigate(_content[i]);
          }
      }
    }

    _actionLogout() async{
      await _authenticationService.logout();
      _navigatorService.navigateToAndRemoveUntil(HomeViewRoute, (Route<dynamic> route) => false);
    }
    
    _actionNavigate(dynamic menu){
      latestArguments = menu["args"];
      _navigatorService.navigateTo(menu["route"], title:menu["titleLabel"], arguments: menu["args"]);
    }

    int getRouteTabIndex(String route){
       var index = -1;
       for(var i = 0; i < bodyTabs.length; i++){
          if(bodyTabs[i]["route"] == route){
             index = i;
             break;
          }
       }
       return index;
    }

    String getDefaultRoute(){
      var defaultRoute = _content.where((item) => item["default"] == true && this._isActiveRole(item)).toList();
      return defaultRoute.length > 0? defaultRoute[0]["route"] : null;
    }

    List<dynamic> get bodyTabs => _content.where((item) => item["displayInTabs"] == true && this._isActiveRole(item)).toList();
    List<dynamic> get drawer { 
       return _content.where((item) => item["drawerLabel"] != "" && this._isActiveRole(item)).toList();
    }
    List<dynamic> get drawerPendingProfile { 
       return _content.where((item) => (item["role"] as List<String>).contains("athlete_pending_profile")).toList();
    }

    _isActiveRole(item){

       if(_authenticationService.currentRole == null)
        return false;

       return (item["role"] as List<String>).contains(_authenticationService.currentRole.active());
    }
}
