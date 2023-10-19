import 'package:compound/constants.dart';
import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/router.dart';

class PayrollViewModel extends BaseViewModel {
  final NavigatorService _navigatorService = locator<NavigatorService>();

  Future<void> load() async {}

  Future<void> goToPayrollPorter() async {
    await _navigatorService.navigateToPageWithReplacement(
        PayrollPorterViewRoute,
        title: ConstantsRoutePage.PAYROLLEMPLOYEE,
        menuId: -1);
  }
}
