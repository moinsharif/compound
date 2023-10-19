part of employees_view;

class _EmployeesMobile extends StatelessWidget {
  TextEditingController _datecontroller = new TextEditingController();
  final TextEditingController marketController = TextEditingController();
  final FocusNode focusMarket = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EmployeesViewModel>.reactive(
        viewModelBuilder: () => EmployeesViewModel(),
        onModelReady: (model) {
          model.safeActionRefreshable(() async {
            await model.load();
          });
        },
        builder: (context, model, child) => model.busy
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                ),
              )
            : Container(
                margin: EdgeInsets.symmetric(horizontal: 3.0),
                child: model.employees.isEmpty
                    ? Center(
                        child: Text("Nothing to show",
                            style: AppTheme.instance.textStyleSmall()))
                    : SingleChildScrollView(
                        child: Container(
                            // scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.only(top: 20.0.h),
                            child: _tableSearch(model)),
                      ),
              ));
  }

  Table _tableSearch(EmployeesViewModel model) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
      columnWidths: {
        0: FixedColumnWidth(70.0.sp),
        1: FixedColumnWidth(70.0.sp),
        2: FixedColumnWidth(130.0.sp),
        3: FixedColumnWidth(240.0.sp),
        4: FixedColumnWidth(90.0.sp),
        5: FixedColumnWidth(170.0.sp),
      },
      children: [
        TableRow(children: <Widget>[
          Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                border: Border(
                    bottom:
                        BorderSide(color: Color(0XFF4A4A4A).withOpacity(0.5)))),
            child: Text('First Name',
                style: AppTheme.instance.textStyleSmall(
                    fontWeight: FontWeight.w600, color: Colors.black)),
          ),
          Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                border: Border(
                    bottom:
                        BorderSide(color: Color(0XFF4A4A4A).withOpacity(0.5)))),
            child: Text('Last Name',
                style: AppTheme.instance.textStyleSmall(
                    fontWeight: FontWeight.w600, color: Colors.black)),
          ),
          Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                border: Border(
                    bottom:
                        BorderSide(color: Color(0XFF4A4A4A).withOpacity(0.5)))),
            child: Text('Phone Number',
                style: AppTheme.instance.textStyleSmall(
                    fontWeight: FontWeight.w600, color: Colors.black)),
          ),
          Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                border: Border(
                    bottom:
                        BorderSide(color: Color(0XFF4A4A4A).withOpacity(0.5)))),
            child: Text('Active',
                style: AppTheme.instance.textStyleSmall(
                    fontWeight: FontWeight.w600, color: Colors.black)),
          ),
          Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                border: Border(
                    bottom:
                        BorderSide(color: Color(0XFF4A4A4A).withOpacity(0.5)))),
            child: Text('',
                style: AppTheme.instance.textStyleSmall(
                    fontWeight: FontWeight.w600, color: Colors.black)),
          ),
        ]),
      ]..addAll(model.employees
          .asMap()
          .entries
          .map((e) => TableRow(
                  decoration: BoxDecoration(
                      color: e.key % 2 == 0
                          ? AppTheme.instance.primaryLighter.withOpacity(0.3)
                          : Colors.white),
                  children: <Widget>[
                    Container(
                      padding:
                          EdgeInsets.only(top: 5.0, left: 5.0, bottom: 10.0),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Color(0XFF4A4A4A).withOpacity(0.5)))),
                      child: Text(e.value.firstName ?? '',
                          style: AppTheme.instance.textStyleSmall()),
                    ),
                    Container(
                      padding:
                          EdgeInsets.only(top: 5.0, left: 5.0, bottom: 10.0),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Color(0XFF4A4A4A).withOpacity(0.5)))),
                      child: Text(e.value.lastName ?? '',
                          style: AppTheme.instance.textStyleSmall()),
                    ),
                    Container(
                      padding:
                          EdgeInsets.only(top: 5.0, left: 5.0, bottom: 10.0),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Color(0XFF4A4A4A).withOpacity(0.5)))),
                      child: Text(e.value.phone ?? '',
                          style: AppTheme.instance.textStyleSmall(
                              color: AppTheme.instance.primaryDarkColorBlue,
                              fontWeight: FontWeight.w600)),
                    ),
                    Container(
                      padding:
                          EdgeInsets.only(top: 5.0, left: 5.0, bottom: 10.0),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Color(0XFF4A4A4A).withOpacity(0.5)))),
                      child: Text(e.value.active?.toString() ?? '',
                          style: AppTheme.instance.textStyleSmall()),
                    ),
                    Container(
                      padding:
                          EdgeInsets.only(top: 5.0, left: 5.0, bottom: 10.0),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Color(0XFF4A4A4A).withOpacity(0.5)))),
                      child: Text(model.loadDate(e.value.createdAt),
                          style: AppTheme.instance.textStyleSmall()),
                    ),
                  ]))
          .toList()),
    );
  }

  Container _text(String data) {
    return Container(
      padding: EdgeInsets.only(left: 8.0),
      child: Text(data,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: AppTheme.instance.textStyleSmall(
              fontWeight: FontWeight.w500, color: Colors.black)),
    );
  }
}
