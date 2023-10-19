part of auth_view;

class _AuthWeb extends StatelessWidget {
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
              child: Center(
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
              Center(
                  child: Image.asset(
                AppTheme.instance.brandLogo,
                width: 50.w,
              )),
              _PageWebStatus(model.statusPage)
            ])),
          )),
        ));
  }
}

class _PageWebStatus extends StatelessWidget {
  final AuthStatePage statusPage;
  _PageWebStatus(
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
