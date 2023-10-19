part of home_view;

class _HomeViewMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => HomeViewModel(),
        onModelReady: (model) {
          model.safeActionRefreshable(() => model.load());
        },
        builder: (context, model, child) => model.busy
            ? BackgroundPattern(
                child: SingleChildScrollView(
                    child: Column(children: <Widget>[
                SizedBox(height: 100.w),
                Center(
                    child: Image.asset(
                  AppTheme.instance.brandLogo,
                  width: 140.w,
                )),
                SizedBox(height: 40.0.w)
              ])))
            : model.admin == describeEnum(TYPEROLE.super_admin) ||
                    model.admin == describeEnum(TYPEROLE.admin)
                ? BackgroundPattern(
                    child: SingleChildScrollView(
                      child: HomeAdmin(),
                    ),
                  )
                : HomePorter());
  }
}
