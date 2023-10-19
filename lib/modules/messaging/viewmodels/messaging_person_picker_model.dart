import 'dart:async';

import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/router.dart';
import 'package:compound/shared_models/employee_detail_model.dart';
import 'package:compound/shared_models/user_model.dart';
import 'package:compound/shared_services/employees_service.dart';
import 'package:compound/utils/view_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class MessagingPersonPickerViewModel extends BaseViewModel {
  String selectFilter = '*';

  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final EmployeesService _employeesService = locator<EmployeesService>();
  final NavigatorService _navigatorService = locator<NavigatorService>();
  final List<String> principalSearch = [
    "*",
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z"
  ];

  EmployeeDetailModel _loadingStub =
      EmployeeDetailModel.fromData({"name": ViewUtils.LoadingIndicatorTitle});
  final TextEditingController porterController = TextEditingController();
  bool openBoxPorter = false;
  final SuggestionsBoxController porterBoxController =
      SuggestionsBoxController();

  List<User> items = [];
  List<User> itemsShow = [];

  Future<void> load() async {
    setBusy(true);
    items = await _employeesService.getEmployeesAllLikeUserMessages();
    items = items
        .where((e) => e.id != _authenticationService.currentUser.id)
        .toList();
    itemsShow = [...items];
    setBusy(false);
  }

  void navigateToChatRoom(index) {
    User employee = items[index];
    Map<String, dynamic> chat = Map<String, dynamic>();

    chat["owner"] = _authenticationService.currentUser.id;
    chat["id"] = employee.id;
    chat["nickname"] = employee.userName;
    chat["photoUrl"] = "";

    _navigatorService.navigateToPageWithReplacement(MessagingViewRoute,
        arguments: {"peer": chat});
  }

  List<User> getEmployeesByFilter(String filter) {
    if (items == null) {
      return List<User>.empty();
    }
    return this
        .items
        .where((User element) => (element.lastName
                .toLowerCase()
                .startsWith(filter.toLowerCase()) ||
            element.firstName.toLowerCase().startsWith(filter.toLowerCase())))
        .toList();
  }

  void changeArrowPositionPorter(bool value, {String opneBox}) {
    this.openBoxPorter = value;
    if (opneBox == 'open') {
      this.porterBoxController.open();
    } else if (opneBox == 'close') {
      this.porterBoxController.close();
    }
    notifyListeners();
  }

  List<User> changeFilter(String e) {
    itemsShow = [];
    itemsShow = e != '' ? getEmployeesByFilter(e) : [...items];
    if (this.selectFilter != e) {
      this.selectFilter = e;
      notifyListeners();
    }
    return itemsShow;
  }

  void cleanController() {
    porterController.clear();
    this.notifyListeners();
  }
}
