import 'package:compound/modules/activity_log/activity_log.dart';
import 'package:compound/modules/add_account/add_account_view.dart';
import 'package:compound/modules/add_market/add_market_view.dart';
import 'package:compound/modules/all_employees/all_employees_view.dart';
import 'package:compound/modules/all_markets/all_markets_view.dart';
import 'package:compound/modules/all_timesheet/all_timesheet_view.dart';
import 'package:compound/modules/add_property/add_property_view.dart';
import 'package:compound/modules/all_violations/all_violation_view.dart';
import 'package:compound/modules/all_watchlist/all_watchlist_view.dart';
import 'package:compound/modules/asign_property/asign_property_view.dart';
import 'package:compound/modules/auth/auth_view.dart';
import 'package:compound/modules/calendar/calendar_view.dart';
import 'package:compound/modules/change_password/change_password_view.dart';
import 'package:compound/modules/check_in/check_in_view.dart';
import 'package:compound/modules/check_in/manage_view.dart';
import 'package:compound/modules/create_account/create_account_view.dart';
import 'package:compound/modules/edit_account/edit_account_view.dart';
import 'package:compound/modules/edit_property/edit_property_view.dart';
import 'package:compound/modules/employees/employees_view.dart';
import 'package:compound/modules/employees_payroll/employees_payroll_view.dart';
import 'package:compound/modules/filter_violations/filter_violations_view.dart';
import 'package:compound/modules/issues/issues_view.dart';
import 'package:compound/modules/login/login_view.dart';
import 'package:compound/modules/home/home_view.dart';
import 'package:compound/modules/login/reset_password_view.dart';
import 'package:compound/modules/messaging/views/messaging_person_picker_view.dart';
import 'package:compound/modules/messaging/views/messaging_view_page.dart';
import 'package:compound/modules/payroll_porter/payroll_porter_view.dart';
import 'package:compound/modules/properties/properties_view.dart';
import 'package:compound/modules/timesheet/timesheet_view.dart';
import 'package:compound/modules/violation/violation_view.dart';
import 'package:compound/modules/violations_by_property/violation_by_property_view.dart';
import 'package:compound/modules/watchlist/watchlist_view.dart';
import 'package:compound/shared_components/camera/camera_view.dart';
import 'package:compound/shared_components/confirm_data/confirm_data.dart';
import 'package:compound/shared_components/general_message/general_message.dart';
import 'package:compound/shared_components/permissions/permissions.dart';
import 'package:compound/shared_components/set_rate_property/set_rate_property.dart';

const String AuthViewRoute = "auth";
const String LoginViewRoute = "login";
const String ResetPasswordViewRoute = "reset_password";
const String GeneralMessageViewRoute = "generalMessage";
const String CreateAccountViewRoute = "createaccount";
const String EditAccountViewRoute = "editaccount";
const String AddAccountViewRoute = "addaccount";
const String ChangePasswordViewRoute = "changepassword";

const String FilterViewRoute = "filter";
const String ServicesViewRoute = "services";

const String HomeViewRoute = "home";
const String EmployeesPayrollViewRoute = "employees_payroll";
const String CalendarViewRoute = "calendar";
const String CheckInViewRoute = "chack_in";
const String ManageViewRoute = "manage";
const String WatchlistViewRoute = "watchlist";
const String ViolationViewRoute = "violation";
const String AllTimeSheetViewRoute = "all_timesheet";
const String AllViolationViewRoute = "all_violation";
const String AllWatchlistViewRoute = "all_watchlist";
const String FilterViolationViewRoute = "filter_violation";
const String AllMarketsViewRoute = "all_markets";
const String AddMarketsViewRoute = "add_markets";
const String AllActivitiesViewRoute = "all_activity";
const String TimeSheetViewViewRoute = "timsheet";
const String ViolationByPropertyViewRoute = "violation_by_property";
const String ConfirmationViewRoute = "confirm";
const String PropertiesViewRoute = "properties";
const String AddPropertyViewRoute = "add_property";
const String AddRatePropertyViewRoute = "add_rate_property";
const String EmployeesViewRoute = "employees";
const String AllEmployeesViewRoute = "All_employees";
const String AsignPropertiesViewRoute = "asign_property";
const String EditPropertyViewRoute = "edit_property";
const String PayrollPorterViewRoute = "payroll_porter";

const String CameraViewRoute = "camera";
const String PermissionsViewRoute = "permissions";
const String MessagingViewRoute = "messaging";
const String MessagingPersonPickerViewRoute = "messaging_person_picker";
const String SubscriptionsViewRoute = "subscriptions";
const String IssuesViewRoute = "issues";

final rootPath = {
  '/': () => AuthView(),
  HomeViewRoute: () => HomeView(),
  EmployeesPayrollViewRoute: () => EmployeesPayrollView(),
  CalendarViewRoute: () => CalendarView(),
  CheckInViewRoute: () => CheckInView(),
  ViolationViewRoute: () => ViolationView(),
  AllViolationViewRoute: () => AllViolationView(),
  AllWatchlistViewRoute: () => AllWatchlistView(),
  FilterViolationViewRoute: () => FilterViolationsView(),
  AllTimeSheetViewRoute: () => AllTimeSheetView(),
  AllMarketsViewRoute: () => AllMarketsView(),
  AddMarketsViewRoute: () => AddMarketsView(),
  TimeSheetViewViewRoute: () => TimeSheetView(),
  AllActivitiesViewRoute: () => ActivityLogView(),
  ViolationByPropertyViewRoute: () => ViolationByPropertyView(),
  ManageViewRoute: () => ManageView(),
  WatchlistViewRoute: () => WatchlistView(),
  CameraViewRoute: () => CameraView(),
  PermissionsViewRoute: () => PermissionsView(),
  LoginViewRoute: () => LoginView(),
  AuthViewRoute: () => AuthView(),
  ConfirmationViewRoute: () => ConfirmDataView(),
  CreateAccountViewRoute: () => CreateAccountView(),
  EditAccountViewRoute: () => EditAccountView(),
  AddAccountViewRoute: () => AddAccountView(),
  ResetPasswordViewRoute: () => ResetPasswordView(),
  ChangePasswordViewRoute: () => ChangePasswordView(),
  GeneralMessageViewRoute: () => GeneralMessage(),
  AddRatePropertyViewRoute: () => SetRateProperty(),
  PropertiesViewRoute: () => PropertiesView(),
  AddPropertyViewRoute: () => AddPropertyView(),
  EmployeesViewRoute: () => AllEmployeesView(),
  AllEmployeesViewRoute: () => EmployeesView(),
  AsignPropertiesViewRoute: () => AsignPropertyAsignView(),
  EditPropertyViewRoute: () => EditPropertyView(),
  PayrollPorterViewRoute: () => PayrollPorterView(),
  IssuesViewRoute: () => IssuesView(),
  MessagingViewRoute: () => MessagingViewPage(),
  MessagingPersonPickerViewRoute: () => MessagingPersonPickerView()
};
