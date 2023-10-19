part of payroll_porter_view;

class PayrollProterMobileState extends StatefulWidget {
  @override
  _PayrollProterMobileStateState createState() =>
      _PayrollProterMobileStateState();
}

class _PayrollProterMobileStateState extends State<PayrollProterMobileState> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PayrollProterViewModel>.reactive(
        viewModelBuilder: () => PayrollProterViewModel(),
        onModelReady: (model) {
          model.safeActionRefreshable(() => model.load(context));
        },
        builder: (context, model, child) => model.busy
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    _headerPictureAndName(model),
                    _actionsButtons(model),
                    SizedBox(
                      height: 10.0,
                    ),
                    model.payrolls.length > 0
                        ? SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: _tablePayroll(model))
                        : Center(
                            child: Text("Nothing to show",
                                style: AppTheme.instance.textStyleSmall())),
                  ])));
  }

  Table _tablePayroll(PayrollProterViewModel model) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
      columnWidths: {
        0: FixedColumnWidth(70.0.sp),
        1: FixedColumnWidth(180.0.sp),
        2: FixedColumnWidth(70.0.sp),
        3: FixedColumnWidth(50.0.sp),
      },
      children: [
        TableRow(children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 5.0),
            child: Text(
              'DATE',
              style: AppTheme.instance.textStyleVerySmall(
                color: AppTheme.instance.primaryFontColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 5.0),
            child: Text(
              'LOCATION',
              style: AppTheme.instance.textStyleVerySmall(
                color: AppTheme.instance.primaryFontColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 5.0),
            child: Text(
              'PROPERTY',
              style: AppTheme.instance.textStyleVerySmall(
                color: AppTheme.instance.primaryFontColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 5.0),
            child: Text(
              'WAGE',
              style: AppTheme.instance.textStyleVerySmall(
                color: AppTheme.instance.primaryFontColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ]),
      ]..addAll(model.payrolls
          .asMap()
          .entries
          .map((e) => TableRow(
                  decoration: BoxDecoration(color: Colors.white),
                  children: <Widget>[
                    Container(
                      padding:
                          EdgeInsets.only(top: 5.0, left: 5.0, bottom: 10.0),
                      child: Text(
                        model.formatDate(e.value.createdAt.local()),
                        style: AppTheme.instance.textStyleVerySmall(
                          color: AppTheme.instance.primaryFontColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.only(top: 5.0, left: 5.0, bottom: 10.0),
                      child: Text(
                        e.value.propertyAddress,
                        maxLines: 2,
                        style: AppTheme.instance.textStyleVerySmall(
                          color: AppTheme.instance.primaryFontColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.only(top: 5.0, left: 5.0, bottom: 10.0),
                      child: Text(
                        e.value.propertyName,
                        style: AppTheme.instance.textStyleVerySmall(
                          color: AppTheme.instance.primaryFontColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.only(top: 5.0, left: 5.0, bottom: 10.0),
                      child: Text(
                        e.value.wage.toString(),
                        style: AppTheme.instance.textStyleVerySmall(
                          color: AppTheme.instance.primaryFontColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ]))
          .toList()),
    );
  }

  Container _actionsButtons(PayrollProterViewModel model) {
    return Container(
      child: Container(
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: Offset(0, 3))
            ],
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0)),
            color: Colors.white),
        height: 70.h,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _filterMonthDay(model),
            _calendar(model),
          ],
        ),
      ),
    );
  }

  Theme _calendar(PayrollProterViewModel model) {
    return Theme(
        data: ThemeData.light().copyWith(
          primaryColor: Colors.black,
          colorScheme: ColorScheme.light(primary: Colors.black),
          buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
        ),
        child: InkWell(
          onTap: () => _selectDate(context, model),
          child: Container(
            height: 30.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(
                  color: Colors.grey[400],
                )),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 30.0,
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(
                    color: Colors.grey[400],
                  ))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 15.0,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(
                    model.selectedDateRange != null
                        ? model.filter == 'Month'
                            ? '${model.selectedDateRange.start.day} - ${model.selectedDateRange.end.day} ${model.formatOneMonthDate(model.selectedDateRange.start)}'
                            : '${model.formatOneDate(model.selectedDateRange.start)}'
                        : 'Select Date',
                    style: AppTheme.instance.textStyleSmall(
                        color: AppTheme.instance.primaryDarkColorBlue,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  height: 30.0,
                  decoration: BoxDecoration(
                      border: Border(
                          left: BorderSide(
                    color: Colors.grey[400],
                  ))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 15.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future<Null> _selectDate(
      BuildContext context, PayrollProterViewModel model) async {
    final DateTime picked = model.filter == 'Month'
        ? await showMonthPicker(
            context: context,
            // builder: (BuildContext context, Widget child) {
            //   return Theme(
            //     data: ThemeData.light().copyWith(
            //       primaryColor: Colors.black,
            //       colorScheme: ColorScheme.light(primary: Colors.black),
            //       buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            //     ),
            //     child: child,
            //   );
            // },
            firstDate: model.getInitYear() != null
                ? DateTime(model.getInitYear().year, model.getInitYear().month)
                : DateTime(DateTime.now().year),
            initialDate: model.selectedDateRange != null
                ? model.selectedDateRange.start
                : DateTime.now(),
            lastDate: DateTime.now())
        : await showDatePicker(
            context: context,
            builder: (BuildContext context, Widget child) {
              return Theme(
                data: ThemeData.light().copyWith(
                  primaryColor: Colors.black,
                  colorScheme: ColorScheme.light(primary: Colors.black),
                  buttonTheme:
                      ButtonThemeData(textTheme: ButtonTextTheme.primary),
                ),
                child: child,
              );
            },
            firstDate: model.getInitYear() ?? DateTime(DateTime.now().year),
            initialDate: DateTime.now(),
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            lastDate: DateTime.now());
    if (picked != null && model.filter == 'Month') {
      model.selectedDateRange = DateTimeRange(
          start: DateTime(picked.year, picked.month, 1),
          end: DateTime(picked.year, picked.month,
              DateUtils.getDaysInMonth(picked.year, picked.month), 23, 59, 59));
      await model.addFilter(model.selectedDateRange);
    } else if (picked != null) {
      model.selectedDateRange = DateTimeRange(
          start: DateTime(picked.year, picked.month, picked.day),
          end: DateTime(picked.year, picked.month, picked.day, 23, 59, 59));
      await model.addFilter(model.selectedDateRange);
    }
  }

  Container _filterMonthDay(PayrollProterViewModel model) {
    return Container(
      padding: EdgeInsets.only(left: 5.0),
      height: 30.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(
            color: Colors.grey[400],
          )),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Date Range: ',
            style: AppTheme.instance.textStyleSmall(
                color: Colors.black, fontWeight: FontWeight.w500),
          ),
          Container(
            child: DropdownButton<String>(
              items: <String>['Month', 'Day'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              value: model.filter,
              onChanged: (value) async {
                await model.changeFilter(value);
              },
              dropdownColor: Colors.white,
              underline: Container(),
              style: AppTheme.instance.textStyleSmall(
                  color: Colors.black, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Container _headerPictureAndName(PayrollProterViewModel model) {
    return Container(
      width: double.infinity,
      color: AppTheme.instance.primaryDarkColorBlue,
      height: 66.h,
      child: Row(
        children: [
          SizedBox(
            width: 15.0.w,
          ),
          Container(
            height: 60,
            width: 60,
            child: Container(
              margin: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.circular(50),
                  color: Color(0XFFF2F2F2)),
              child: Container(
                margin: EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.circular(50),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: model.getUserImage() != null
                            ? NetworkImage(model.getUserImage())
                            : AssetImage('assets/icons/calvin-icon.png'))),
              ),
            ),
          ),
          SizedBox(
            width: 15.0.w,
          ),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(bottom: 10.0),
            alignment: Alignment.center,
            child: Text(
              model.getUserName(),
              textAlign: TextAlign.start,
              style: AppTheme.instance.textStyleBigTitle(
                  color: Colors.white, fontWeight: FontWeight.w500),
            ),
          )),
          SizedBox(
            width: 15.0.w,
          ),
        ],
      ),
    );
  }
}
