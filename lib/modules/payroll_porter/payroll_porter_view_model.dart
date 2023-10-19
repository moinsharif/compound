import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/core/services/ui/ui_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/shared_components/general_message/general_message.dart';
import 'package:compound/shared_models/payrrol_model.dart';
import 'package:compound/shared_services/payrrol_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PayrollProterViewModel extends BaseViewModel {
  final NavigatorService _navigatorService = locator<NavigatorService>();
  final UIService _uiService = locator<UIService>();
  final PayrollService _payrollService = locator<PayrollService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  List<PayrollModel> payrolls = [];
  String filter = 'Month';
  DateTimeRange selectedDateRange;
  @override
  dispose() {
    _uiService.hidden(stream: _uiService.emailHeaderStream);
    super.dispose();
  }

  Future<void> load(BuildContext context) async {
    setBusy(true);
    _uiService.show(
      stream: _uiService.emailHeaderStream,
      function: () {
        Navigator.of(context).push(PageRouteBuilder(
            opaque: false,
            pageBuilder: (BuildContext context, _, __) {
              return GeneralMessage();
            }));
      },
    );
    payrolls =
        await _payrollService.getById(_authenticationService.currentUser.id);
    payrolls.sort((a, b) => b.createdAt.local().compareTo(a.createdAt.local()));
    setBusy(false);
  }

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('MMM dd');
    return formatter.format(date);
  }

  String formatOneDate(DateTime date) {
    final DateFormat formatter = DateFormat('MMM dd');
    return formatter.format(date);
  }

  String formatOneMonthDate(DateTime date) {
    final DateFormat formatter = DateFormat('MMM');
    return formatter.format(date);
  }

  String loadHours(DateTime date) {
    final DateFormat formatterHour = DateFormat('hh:mm a');
    return date != null ? formatterHour.format(date) : '--';
  }

  Future<dynamic> goToBack() async {
    await _navigatorService.navigateBack();
  }

  String getUserName() {
    return '${_authenticationService.currentUser?.firstName} ${_authenticationService.currentUser?.lastName}' ??
        '';
  }

  String getUserImage() {
    return _authenticationService.currentUser?.img ?? null;
  }

  DateTime getInitYear() {
    return _authenticationService.currentUser?.createdAt ?? null;
  }

  Future<void> changeFilter(value) async {
    if (filter != value) {
      selectedDateRange = null;
      filter = value;
      payrolls =
          await _payrollService.getById(_authenticationService.currentUser.id);
      payrolls.sort((a, b) => b.createdAt.local().compareTo(a.createdAt.local()));
      notifyListeners();
    }
  }

  Future<void> addFilter(DateTimeRange range) async {
    payrolls = await _payrollService.getByIdAndRangeOfDate(
        _authenticationService.currentUser.id, range);
    notifyListeners();
  }
}
