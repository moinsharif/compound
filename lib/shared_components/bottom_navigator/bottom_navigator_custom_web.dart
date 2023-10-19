part of bottom_navigation_view;

class BottomNavigatorCustomWeb extends StatelessWidget {
  BottomNavigatorCustomWeb({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BottomNavigatorViewModel>.reactive(
        viewModelBuilder: () => BottomNavigatorViewModel(),
        onModelReady: (model) {
          model.load();
        },
        builder: (context, model, child) => model.hidden
            ? SizedBox(height: 1)
            : model.isAdmin
                ? BottomNavigatorAdminWeb()
                : BottomNavigatorPorterWeb());
  }
}
