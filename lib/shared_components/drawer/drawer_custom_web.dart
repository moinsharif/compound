part of drawer_view;

class DrawerCustomWeb extends StatelessWidget implements PreferredSizeWidget {
  DrawerCustomWeb({Key key}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DrawerCustomViewModel>.reactive(
        viewModelBuilder: () => DrawerCustomViewModel(),
        onModelReady: (model) {
          model.load();
        },
        builder: (context, model, child) => model.hidden
            ? Container()
            : model.isAdmin
                ? DrawerAdminWeb()
                : DrawerPorter());
  }
}
