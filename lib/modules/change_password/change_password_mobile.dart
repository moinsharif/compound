part of change_password_view;

class _ChangePasswordMobile extends StatelessWidget {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  _format(Widget widget) {
    return AppTheme.instance.formFieldFormat(child: widget);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChangePasswordViewModel>.reactive(
      viewModelBuilder: () => ChangePasswordViewModel(),
      builder: (context, model, child) => Container(
          padding: EdgeInsets.only(top: 10.w),
          child: FormBuilder(
              key: _fbKey,
              child: Column(children: <Widget>[
                Text("Sign Up",
                    style: AppTheme.instance.textStyleBigTitle(
                        fontWeight: FontWeight.w500,
                        color: Color(0xff000000).withOpacity(1))),
                CardWithButton(
                    busy: model.busy,
                    title: 'Continue',
                    textStyle: TextStyle(fontSize: 22.0),
                    bordeRadius: 30.0,
                    icon: Icons.arrow_forward_rounded,
                    onPressed: () async {
                      var state =
                          await model.changePassword(_fbKey.currentState);
                      if (state == "success") {
                        await model.updateUser();
                        await model.navigateToHome();
                      } else if (state ==
                          "Please try to log in again to complete this option.") {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(state)));
                        await model.logOut();
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
                          initialValue: model.getUserName(),
                          enabled: false,
                          decoration: InputDecoration(
                              labelText: "Username",
                              suffixIconConstraints: BoxConstraints(
                                  minHeight: 5.0, minWidth: 20.sp),
                              suffixIcon: Image.asset(
                                'assets/icons/user-icon.png',
                                color: Colors.black,
                                width: 17.sp,
                              )),
                          keyboardType: TextInputType.text,
                        )),
                        _format(FormBuilderTextField(
                          name: "temporaryPassword",
                          maxLines: 1,
                          obscureText: model.showTemporaryPassword,
                          decoration: InputDecoration(
                              labelText: "Temporary Password",
                              suffixIconConstraints:
                                  BoxConstraints(minHeight: 5.0, minWidth: 5.0),
                              suffixIcon: IconButton(
                                icon: FaIcon(
                                    model.showTemporaryPassword
                                        ? FontAwesomeIcons.eye
                                        : FontAwesomeIcons.eyeSlash,
                                    size: 17.sp,
                                    color: AppTheme.instance.primaryDarker),
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  model.hideTemporaryPassword();
                                },
                              )),
                          validator: FormBuilderValidators.compose(
                              [FormBuilderValidators.required(context)]),
                          keyboardType: TextInputType.visiblePassword,
                        )),
                        _format(FormBuilderTextField(
                          name: "newPassword",
                          maxLines: 1,
                          obscureText: model.showNewPassword,
                          decoration: InputDecoration(
                              labelText: "New Password",
                              suffixIconConstraints:
                                  BoxConstraints(minHeight: 5.0, minWidth: 5.0),
                              suffixIcon: IconButton(
                                icon: FaIcon(
                                    model.showNewPassword
                                        ? FontAwesomeIcons.eye
                                        : FontAwesomeIcons.eyeSlash,
                                    size: 17.sp,
                                    color: AppTheme.instance.primaryDarker),
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  model.hideNewPassword();
                                },
                              )),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context),
                            FormBuilderValidators.minLength(context, 6),
                            FormBuilderValidators.match(
                                context, '^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])',
                                errorText:
                                    'should contain at least one upper case, one lower case and one digit.')
                          ]),
                          keyboardType: TextInputType.visiblePassword,
                        )),
                        _format(FormBuilderTextField(
                          name: "confirmPassword",
                          maxLines: 1,
                          obscureText: model.showConfirmPassword,
                          decoration: InputDecoration(
                              labelText: "Confirm Password",
                              suffixIconConstraints:
                                  BoxConstraints(minHeight: 5.0, minWidth: 5.0),
                              suffixIcon: IconButton(
                                icon: FaIcon(
                                    model.showConfirmPassword
                                        ? FontAwesomeIcons.eye
                                        : FontAwesomeIcons.eyeSlash,
                                    size: 17.sp,
                                    color: AppTheme.instance.primaryDarker),
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  model.hideConfirmPassword();
                                },
                              )),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context),
                            FormBuilderValidators.minLength(context, 6),
                            FormBuilderValidators.match(
                                context, '^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])',
                                errorText:
                                    'should contain at least one upper case, one lower case and one digit.')
                          ]),
                          keyboardType: TextInputType.visiblePassword,
                        )),
                      ],
                    )),
              ]))),
    );
  }
}
