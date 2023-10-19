part of login_view;

class _LoginViewMobile extends StatelessWidget {
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
    return _buildLogin(context);
  }

  _buildLogin(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
        viewModelBuilder: () => LoginViewModel(),
        onModelReady: (model) {
          model.safeActionRefreshable(() => model.load());
        },
        builder: (context, model, child) => SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.only(top: 10.w),
                  child: FormBuilder(
                      key: _fbKey,
                      child: Column(children: <Widget>[
                        Text("Log In",
                            style: AppTheme.instance.textStyleBigTitle(
                                fontWeight: FontWeight.w500,
                                color: Color(0xff000000).withOpacity(1))),
                        CardWithButton(
                          title: 'Log in',
                          busy: model.busy,
                          textStyle: TextStyle(fontSize: 22.0.sp),
                          bordeRadius: 30.0,
                          icon: Icons.arrow_forward_rounded,
                          onPressed: () async {
                            var state = await model.login(
                                _fbKey.currentState, [TYPEROLE.user_tier_1]);
                            if (state == "success") {
                              // model.navigateToHome();
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text(state)));
                            }
                          },
                          childCard: Column(
                            children: [
                              _format(FormBuilderTextField(
                                name: "email",
                                initialValue: model.getUser() ?? "",
                                onChanged: (value) => {
                                  if (value.contains('@'))
                                    {model.showErrorUsername(show: true)}
                                  else
                                    {model.showErrorUsername(show: false)}
                                },
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    labelText: "Username",
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
                                keyboardType: TextInputType.emailAddress,
                              )),
                              if (model.showErroUsername)
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 25.w),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                        'Invalid username. Please use only letters (a-z) and numbers',
                                        style: AppTheme.instance
                                            .textStyleVerySmall(
                                                size: 10.0,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.red)),
                                  ),
                                ),
                              _format(FormBuilderTextField(
                                name: "password",
                                initialValue: model.getPassword() ?? "",
                                style: TextStyle(color: Colors.black),
                                maxLines: 1,
                                obscureText: model.showPassword,
                                decoration: InputDecoration(
                                    labelText: "Password",
                                    suffixIconConstraints: BoxConstraints(
                                        minHeight: 5.0, minWidth: 5.0),
                                    suffixIcon: IconButton(
                                      icon: FaIcon(
                                          model.showPassword
                                              ? FontAwesomeIcons.eye
                                              : FontAwesomeIcons.eyeSlash,
                                          size: 17.sp,
                                          color: Colors.black),
                                      alignment: Alignment.centerRight,
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        model.showPass();
                                      },
                                    )),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(context),
                                ]),
                                keyboardType: TextInputType.visiblePassword,
                              )),
                            ],
                          ),
                        ),
                        Container(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Admin Log In',
                                style: AppTheme.instance.textStyleSmall(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0XFF4A4A4A).withOpacity(0.5))),
                            Container(
                                padding: EdgeInsets.all(3.0),
                                decoration: BoxDecoration(
                                    color: AppTheme.instance.primaryColorBlue,
                                    shape: BoxShape.circle),
                                child: Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: InkWell(
                                    onTap: () async {
                                      var state = await model.login(
                                          _fbKey.currentState, [
                                        TYPEROLE.admin,
                                        TYPEROLE.super_admin
                                      ]);
                                      if (state == "success") {
                                        // model.navigateToHome();
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                                SnackBar(content: Text(state)));
                                      }
                                    },
                                    child: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 14.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ))
                          ],
                        )),
                        TextButton(
                            onPressed: () {
                              _launchUrl();
                            },
                            child: Text(Config.terms,
                                style: AppTheme.instance.textStyleRegular(
                                    fontWeight: FontWeight.w500,
                                    underlined: true,
                                    color: Colors.black))),
                      ]))),
            ));
  }

  void _launchUrl() async {
    if (!await launch(Config.urlTerms))
      throw 'Could not launch ${Config.urlTerms}';
  }
}
