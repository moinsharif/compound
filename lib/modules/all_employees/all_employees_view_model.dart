import 'dart:async';

import 'package:compound/constants.dart';
import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/router.dart';
import 'package:compound/shared_models/employee_detail_model.dart';
import 'package:compound/shared_models/user_model.dart';
import 'package:compound/shared_services/employees_service.dart';
import 'package:compound/utils/view_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class AllEmployeesViewModel extends BaseViewModel {
  bool activeUser = false;

  final EmployeesService _employeesService = locator<EmployeesService>();
  final NavigatorService _navigatorService = locator<NavigatorService>();
  final TextEditingController porterController = TextEditingController();
  bool openBoxPorter = false;
  final SuggestionsBoxController porterBoxController =
      SuggestionsBoxController();

  List<User> items = [];
  List<User> itemsShow = [];
  bool isSuperAdmin = false;
  String selectFilter = '';

  Future<void> load() async {
    setBusy(true);
    items = await _employeesService.getEmployeesAllLikeUser(
        active: !this.activeUser);
    itemsShow = [...items];
    setBusy(false);
  }

  Future<void> handleRadioValueActiveChange(bool value) async {
    this.activeUser = value;
    setBusy(true);
    items = await _employeesService.getEmployeesAllLikeUser(
        active: !this.activeUser);
    itemsShow = [...items];
    setBusy(false);
    notifyListeners();
  }

  void cleanController() {
    porterController.clear();
    this.notifyListeners();
  }

  void refresh() {
    this.notifyListeners();
  }

  void navigateToEmployeeDetail() {
    _navigatorService.navigateToPageWithReplacement(AllEmployeesViewRoute);
  }

  Future<void> navigateTDetail(User data) async {
    await _navigatorService
        .navigateTo(
          EditAccountViewRoute,
          arguments: data,
          title: ConstantsRoutePage.EDITUSER,
        )
        .then((value) => {
              if (value != null)
                {
                  this.load(),
                }
            });
  }

  Future<void> navigateToAddEmployee() async {
    return _navigatorService
        .navigateTo(AddAccountViewRoute, title: ConstantsRoutePage.ADDEMPLOYEE)
        .then((value) async {
      if (value) await load();
    });
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

  void changeArrowPositionPorter(bool value, {String opneBox}) {
    this.openBoxPorter = value;
    if (opneBox == 'open') {
      this.porterBoxController.open();
    } else if (opneBox == 'close') {
      this.porterBoxController.close();
    }
    notifyListeners();
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
}
