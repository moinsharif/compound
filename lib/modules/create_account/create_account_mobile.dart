part of create_account_view;

class _CreateAccountMobile extends StatelessWidget {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final maskFormatter = new MaskTextInputFormatter(
      mask: '(###) ###-####', filter: {"#": RegExp(r'[0-9]')});

  _format(Widget widget) {
    return AppTheme.instance.formFieldFormat(child: widget);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreateAccountViewModel>.reactive(
      viewModelBuilder: () => CreateAccountViewModel(),
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
                    title: 'Request Access',
                    textStyle: TextStyle(fontSize: 20.0.sp),
                    bordeRadius: 30.0,
                    icon: Icons.arrow_forward_rounded,
                    onPressed: () async {
                      var state =
                          await model.createAccount(_fbKey.currentState);
                      if (state == "success") {
                        model
                            .setAuthStatePage(AuthStatePage.SIGNUPCONFIRMATION);
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
                              labelText: "User Name",
                              suffixIconConstraints: BoxConstraints(
                                  minHeight: 5.0, minWidth: 20.sp),
                              suffixIcon: Image.asset(
                                'assets/icons/user-icon.png',
                                color: Colors.black,
                                width: 17.sp,
                              )),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context),
                            FormBuilderValidators.max(context, 70),
                          ]),
                          keyboardType: TextInputType.text,
                        )),
                        _format(FormBuilderTextField(
                          name: "firstname",
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              labelText: "First Name",
                              suffixIconConstraints: BoxConstraints(
                                  minHeight: 5.0, minWidth: 20.sp),
                              suffixIcon: Image.asset(
                                'assets/icons/user-icon.png',
                                color: Colors.black,
                                width: 17.sp,
                              )),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context),
                            FormBuilderValidators.max(context, 70),
                          ]),
                          keyboardType: TextInputType.text,
                        )),
                        _format(FormBuilderTextField(
                          name: "lastname",
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              labelText: "Last Name",
                              suffixIconConstraints: BoxConstraints(
                                  minHeight: 5.0, minWidth: 20.sp),
                              suffixIcon: Image.asset(
                                'assets/icons/user-icon.png',
                                color: Colors.black,
                                width: 17.sp,
                              )),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context),
                            FormBuilderValidators.max(context, 70),
                          ]),
                          keyboardType: TextInputType.text,
                        )),
                        _format(FormBuilderTextField(
                          name: "phoneNumber",
                          inputFormatters: [maskFormatter],
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              labelText: "Phone Number",
                              suffixIconConstraints: BoxConstraints(
                                  minHeight: 5.0, minWidth: 20.sp),
                              suffixIcon: Image.asset(
                                'assets/icons/phone.png',
                                color: Colors.black,
                                width: 17.sp,
                              )),
                          validator: FormBuilderValidators.compose(
                              [FormBuilderValidators.required(context)]),
                          keyboardType: TextInputType.phone,
                        )),
                        _format(FormBuilderTextField(
                          name: "email",
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              labelText: "Email",
                              suffixIconConstraints: BoxConstraints(
                                  minHeight: 5.0, minWidth: 20.sp),
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
                    )),
                Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: AppTheme.instance.textStyleSmall(
                          color: Color(0XFF4A4A4A).withOpacity(0.5)),
                    ),
                    verticalSpaceLarge,
                    InkWell(
                      onTap: () {
                        model.setAuthStatePage(AuthStatePage.LOGIN);
                      },
                      child: Text(
                        '  Log in here.',
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
