import 'package:compound/constants.dart';
import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/router.dart';
import 'package:compound/shared_models/employee_detail_model.dart';
import 'package:compound/shared_models/payrrol_model.dart';
import 'package:compound/shared_models/property_model.dart';
import 'package:compound/shared_services/employees_service.dart';
import 'package:compound/shared_services/payrrol_service.dart';
import 'package:compound/shared_services/property_service.dart';
import 'package:compound/utils/timestamp_util.dart';
import 'package:flutter/foundation.dart';
import 'package:compound/core/services/shared_preferences/shared_preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

class EmployeesPayrollViewModel extends BaseViewModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigatorService _navigationService = locator<NavigatorService>();
  final PayrollService _payrollService = locator<PayrollService>();
  final PropertyService _propertyService = locator<PropertyService>();
  final TextEditingController porterController = TextEditingController();
  final TextEditingController propertyController = TextEditingController();
  List<PayrollModel> payrolls = [];
  List<EmployeeDetailModel> porters = [];
  List<PropertyModel> properties = [];
  PropertyModel propertySelected;
  EmployeeDetailModel porterSelected;
  String selectedLocation;
  DateTimeRange selectedDateRange;
  final EmployeesService _employeesService = locator<EmployeesService>();

  final SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();

  bool openBoxPorter = false;
  final SuggestionsBoxController porterBoxController =
      SuggestionsBoxController();

  bool openBoxProperty = false;
  final SuggestionsBoxController propertyBoxController =
      SuggestionsBoxController();

  bool showPassword = true;

  void setAuthStatePage(AuthStatePage statePage) {
    _authenticationService.authStatusPage(statePage);
  }

  void showPass() {
    this.showPassword = !this.showPassword;
    this.notifyListeners();
  }

  String getTitle() {
    return "Login";
  }

  Future<void> load() async {
    setBusy(true);
    porters = await _employeesService.getEmployeesAll(isEmployee: false);
    properties = await _propertyService.getPropertiesAll(true);
    this.loadPayrolls();
    setBusy(false);
  }

  Future<void> loadPayrolls() async {
    setBusy(true);
    payrolls = await _payrollService.getAllPayroll(
        start: selectedDateRange?.start != null
            ? TimestampUtils.wdRangeFrom(selectedDateRange.start)
            : null,
        end: selectedDateRange?.end != null
            ? TimestampUtils.wdRangeTo(selectedDateRange.end)
            : null,
        porterId: porterSelected?.id ?? null,
        propertyId: propertySelected?.id ?? null);
    setBusy(false);
    this.notifyListeners();
  }

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('MMM dd');
    return formatter.format(date);
  }

  void selectLocation(String v) {
    selectedLocation = v;
    notifyListeners();
  }

  void clearFilters() {
    selectedDateRange = null;
    porterSelected = null;
    propertySelected = null;
    porterController.text = '';
    propertyController.text = '';
    loadPayrolls();
    notifyListeners();
  }

  String formatDateRange(DateTime date) {
    final DateFormat formatter = DateFormat('MMM dd, yyyy');
    return formatter.format(date);
  }

  Future<void> editWage(String id, Map<String, dynamic> wage) async =>
      await _employeesService.editWage(id, wage);

  void selectDateRange(DateTimeRange v) {
    selectedDateRange = v;
    this.loadPayrolls();
    notifyListeners();
  }

  Future<void> navigateToHome() async {
    await _navigationService.navigateToPageWithReplacement(HomeViewRoute,
        title: ConstantsRoutePage.PROFILE);
  }

  Future<String> resetPasswordAction({@required String email}) async {
    setBusy(true);
    var result =
        await _authenticationService.sendPasswordResetEmail(email: email);
    setBusy(false);

    return result;
  }

  void navigateToReset() {
    _navigationService.navigateTo(ResetPasswordViewRoute);
  }

  void navigateToSignUp() {
    _navigationService.navigateTo(CreateAccountViewRoute);
  }

  void navigateToLogIn({result}) {
    _navigationService.navigateBack(arguments: result);
  }

  Future<String> navigateToResetPassword() async {
    var result = await _navigationService.navigateTo(ResetPasswordViewRoute);
    return result;
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

  void changeArrowPositionProperty(bool value, {String opneBox}) {
    this.openBoxProperty = value;
    if (opneBox == 'open') {
      this.propertyBoxController.open();
    } else if (opneBox == 'close') {
      this.propertyBoxController.close();
    }
    this.notifyListeners();
  }

  Future<List<EmployeeDetailModel>> getPorters(String pattern) async {
    if (porters == null) {
      return List<EmployeeDetailModel>.empty();
    }

    return this
        .porters
        .where((EmployeeDetailModel element) => (element.lastName
                .toLowerCase()
                .startsWith(pattern.toLowerCase()) ||
            element.firstName.toLowerCase().startsWith(pattern.toLowerCase())))
        .toList();
  }

  Future<List<PropertyModel>> getProperties(String pattern) async {
    if (properties == null) {
      return List<PropertyModel>.empty();
    }

    return this
        .properties
        .where((PropertyModel element) =>
            element.propertyName.toLowerCase().indexOf(pattern.toLowerCase()) >=
            0)
        .toList();
  }

  void clearController(TextEditingController controller) {
    controller.text = '';
    this.notifyListeners();
  }

  void refresh() {
    this.notifyListeners();
  }
}
