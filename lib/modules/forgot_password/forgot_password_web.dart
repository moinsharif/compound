part of forgot_password_view;

class _ForgotPasswordViewWeb extends StatelessWidget {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  final NavigatorService _navigationService = locator<NavigatorService>();

  _format(Widget widget) {
    return AppTheme.instance.formFieldFormat(child: widget);
  }

  void navigateToHome() {
    _navigationService.navigateToPageWithReplacement(HomeViewRoute);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForgotPasswordViewModel>.reactive(
      viewModelBuilder: () => ForgotPasswordViewModel(),
      builder: (context, model, child) => Container(
          padding: EdgeInsets.only(top: 10.w),
          child: FormBuilder(
              key: _fbKey,
              child: Column(children: <Widget>[
                Text("Forgot Pin?",
                    style: AppTheme.instance.textStyleRegularPlus(
                        fontWeight: FontWeight.w500,
                        color: Color(0xff000000).withOpacity(1))),
                Container(
                  width: 230.w,
                  child: Text(
                      "Enter your name and email address to reset your password",
                      textAlign: TextAlign.center,
                      style: AppTheme.instance.textStyleSmall(
                          color: Color(0XFF4A4A4A).withOpacity(1))),
                ),
                CardWithButton(
                  title: 'Reset Pin',
                  busy: model.busy,
                  textStyle: TextStyle(fontSize: 22.0),
                  bordeRadius: 30.0,
                  icon: FontAwesomeIcons.redo,
                  onPressed: () async {
                    var state =
                        await model.resetPasswordAction(_fbKey.currentState);
                    if (state == "success") {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please check your Email')));
                      model.setAuthStatePage(AuthStatePage.LOGIN);
                    } else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(state)));
                    }
                  },
                  childCard: Column(
                    children: [
                      _format(FormBuilderTextField(
                        name: "name",
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            labelText: "Name",
                            labelStyle: TextStyle(
                                fontSize: 20, color: Color(0xFF8C8E91)),
                            suffixIconConstraints:
                                BoxConstraints(minHeight: 5.0, minWidth: 20.sp),
                            suffixIcon: Image.asset(
                              'assets/icons/user-icon.png',
                              color: Colors.black,
                              width: 17.sp,
                            )),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                        ]),
                        keyboardType: TextInputType.text,
                      )),
                      _format(FormBuilderTextField(
                        name: "email",
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle: TextStyle(
                                fontSize: 20, color: Color(0xFF8C8E91)),
                            suffixIconConstraints:
                                BoxConstraints(minHeight: 5.0, minWidth: 20.sp),
                            suffixIcon: Icon(
                              Icons.alternate_email_outlined,
                              color: Colors.black,
                              size: 17.sp,
                            )),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                          FormBuilderValidators.email(context),
                          FormBuilderValidators.max(context, 70),
                        ]),
                        keyboardType: TextInputType.emailAddress,
                      )),
                    ],
                  ),
                ),
                verticalSpaceLarge,
                Container(
                    padding: EdgeInsets.only(bottom: 30.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account?',
                          style: AppTheme.instance.textStyleSmall(
                              color: Color(0XFF4A4A4A).withOpacity(0.5)),
                        ),
                        InkWell(
                          onTap: () {
                            model.setAuthStatePage(AuthStatePage.LOGIN);
                          },
                          child: Text(
                            '  Sign up here.',
                            style: AppTheme.instance.textStyleSmall(
                                color: Color(0xff000000).withOpacity(1.0)),
                          ),
                        ),
                      ],
                    ))
              ]))),
    );
  }
}
