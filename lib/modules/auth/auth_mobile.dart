part of auth_view;

class _AuthMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: ViewModelBuilder<AuthViewModel>.reactive(
          viewModelBuilder: () => AuthViewModel(),
          onModelReady: (model) {
            model.load();
          },
          builder: (context, model, child) => BackgroundPattern(
              child: SingleChildScrollView(
                  child: model.busy
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Column(children: <Widget>[
                          SizedBox(height: 100.w),
                          Center(
                              child: Image.asset(
                            AppTheme.instance.brandLogo,
                            width: 140.w,
                          )),
                          SizedBox(height: 40.0.w),
                          _PageStatus(model.statusPage)
                        ]))),
        ));
  }
}

class _PageStatus extends StatelessWidget {
  final AuthStatePage statusPage;
  _PageStatus(
    this.statusPage, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (this.statusPage) {
      case AuthStatePage.LOGIN:
        return LoginView();
      case AuthStatePage.SIGNUP:
        return CreateAccountView();
      case AuthStatePage.FORGOTPIN:
        return ForgotPasswordView();
      case AuthStatePage.SIGNUPCONFIRMATION:
        return ChangePasswordView();
      default:
        return Container();
    }
  }
}
