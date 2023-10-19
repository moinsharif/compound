import 'package:compound/constants.dart';
import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/ui/ui_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/shared_components/general_message/general_message.dart';
import 'package:flutter/material.dart';

class HomePorterViewModel extends BaseViewModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final UIService _uiService = locator<UIService>();
  Future<void> load(BuildContext context) async {
    setBusy(true);
    _authenticationService.textAppBarStream.add(ConstantsRoutePage.PROFILE);
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
    setBusy(false);
  }

  @override
  void dispose() {
    _uiService.hidden(stream: _uiService.emailHeaderStream);
    super.dispose();
  }
}
