part of employees_payroll;

class _EmployeesPayrollViewWeb extends StatelessWidget {
  final NavigatorService _navigationService = locator<NavigatorService>();
  TextEditingController _datecontroller = new TextEditingController();

  final FocusNode focusPorter = FocusNode();

  final FocusNode focusProperty = FocusNode();

  @override
  Widget build(BuildContext context) {
    return _buildLogin(context);
  }

  _buildLogin(BuildContext context) {
    return ViewModelBuilder<EmployeesPayrollViewModel>.reactive(
      viewModelBuilder: () => EmployeesPayrollViewModel(),
      onModelReady: (model) {
        model.safeActionRefreshable(() => model.load());
      },
      builder: (context, model, child) => ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: Colors.black.withOpacity(0.1),
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(child: _calendar(context, model, _datecontroller)),
                if (model.selectedDateRange != null ||
                    model.porterSelected != null ||
                    model.propertySelected != null)
                  ButtonBlue(
                    onpress: () => model.clearFilters(),
                    text: 'Clear filters',
                  )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
              bottom: 10.h,
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: Offset(0, 20),
                  color: Colors.black.withOpacity(0.03),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(child: _multiSelected(model, context)),
                SizedBox(
                  width: 10.0,
                ),
                if (model.selectedDateRange != null &&
                    model.payrolls.length > 0)
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: ButtonIcon(
                              onPress: () async => await locator<CSVService>()
                                  .generateCsv(model.payrolls),
                              text: ' XLS '),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          model.busy
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : model.payrolls.length < 1
                  ? Center(
                      child: Text("Nothing to show",
                          style: AppTheme.instance.textStyleSmall()))
                  : Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScaleHelper.rsDoubleW(context, 5),
                          vertical: 10.0),
                      child: _tablePayroll(model))
        ],
      ),
    );
  }

  Row _multiSelected(EmployeesPayrollViewModel model, BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0.h),
                  child: Text(
                    'Porter',
                    style: AppTheme.instance.textStyleSmall(
                        fontWeight: FontWeight.bold, color: Color(0xFFAEAEAE)),
                  )),
              _porters(model, context),
            ],
          ),
        ),
        SizedBox(
          width: 30.0.w,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0.h),
                  child: Text(
                    'Property',
                    style: AppTheme.instance.textStyleSmall(
                        fontWeight: FontWeight.bold, color: Color(0xFFAEAEAE)),
                  )),
              _properties(model, context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _properties(EmployeesPayrollViewModel model, BuildContext context) {
    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: model.propertyController,
        focusNode: focusProperty,
        onSubmitted: (_) {
          model.changeArrowPositionProperty(false);
          model.clearController(model.propertyController);
        },
        style: AppTheme.instance.textStyleRegular(),
        decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
            filled: true,
            isDense: true,
            isCollapsed: true,
            fillColor: Colors.white,
            suffixIconConstraints: BoxConstraints(
              minWidth: 32,
            ),
            hintStyle: AppTheme.instance.textStyleRegular(),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: ColorsUtils.getMaterialColor(0x304A4A4A),
                    width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(6))),
            suffixIcon: InkWell(
              onTap: () {
                if (model.propertyController.text.length > 0) {
                  model.clearController(model.propertyController);
                } else if (model.openBoxProperty) {
                  model.changeArrowPositionProperty(false, opneBox: 'close');
                } else {
                  model.changeArrowPositionProperty(true, opneBox: 'open');
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Icon(
                  model.propertyController.text.length > 0
                      ? Icons.close_rounded
                      : !model.openBoxPorter
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_up,
                  color: Color(0xff004A05),
                ),
              ),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: ColorsUtils.getMaterialColor(0x304A4A4A),
                    width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(6))),
            hintText: 'Select Property'),
      ),
      suggestionsCallback: (pattern) async {
        List<PropertyModel> data = await model.getProperties(pattern);
        model.refresh();
        return data;
      },
      noItemsFoundBuilder: (context) => Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
              model.properties.length <= 0
                  ? 'You don\'t have properties yet'
                  : 'this search does not match',
              style: AppTheme.instance.textStyleRegular()),
        ),
      ),
      suggestionsBoxDecoration: SuggestionsBoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(6))),
      itemBuilder: (context, PropertyModel suggestion) {
        return ListTile(
            title: Text('${suggestion.propertyName}',
                style: AppTheme.instance.textStyleRegular()));
      },
      onSuggestionSelected: (PropertyModel suggestion) async {
        model.changeArrowPositionProperty(false);
        model.propertyController.text = '${suggestion.propertyName}';
        model.propertySelected = suggestion;
        await model.loadPayrolls();
      },
      suggestionsBoxController: model.propertyBoxController,
    );
  }

  Widget _porters(EmployeesPayrollViewModel model, BuildContext context) {
    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: model.porterController,
        focusNode: focusPorter,
        onSubmitted: (_) {
          model.changeArrowPositionPorter(false);
          model.clearController(model.porterController);
        },
        style: AppTheme.instance.textStyleRegular(),
        decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
            isDense: true,
            isCollapsed: true,
            filled: true,
            suffixIconConstraints: BoxConstraints(
              minWidth: 32,
            ),
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: ColorsUtils.getMaterialColor(0x304A4A4A),
                    width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(6))),
            suffixIcon: InkWell(
              onTap: () {
                if (model.porterController.text.length > 0) {
                  model.clearController(model.porterController);
                } else if (model.openBoxPorter) {
                  model.changeArrowPositionPorter(false, opneBox: 'close');
                } else {
                  model.changeArrowPositionPorter(true, opneBox: 'open');
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Icon(
                  model.porterController.text.length > 0
                      ? Icons.close_rounded
                      : !model.openBoxPorter
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_up,
                  color: Color(0xff004A05),
                ),
              ),
            ),
            hintStyle: AppTheme.instance.textStyleRegular(),
            border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: ColorsUtils.getMaterialColor(0x304A4A4A),
                    width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(6))),
            hintText: 'Select Porter'),
      ),
      suggestionsCallback: (pattern) async {
        List<EmployeeDetailModel> data = await model.getPorters(pattern);
        model.refresh();
        return data;
      },
      noItemsFoundBuilder: (context) => Container(
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
                model.porters.length <= 0
                    ? 'You don\'t have porters yet'
                    : 'this search does not match',
                style: AppTheme.instance.textStyleRegular())),
      ),
      suggestionsBoxDecoration: SuggestionsBoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(6))),
      itemBuilder: (context, EmployeeDetailModel suggestion) {
        return ListTile(
            title: Text('${suggestion.lastName}, ${suggestion.firstName}',
                style: AppTheme.instance.textStyleRegular()));
      },
      onSuggestionSelected: (EmployeeDetailModel suggestion) async {
        model.changeArrowPositionPorter(false);
        model.porterController.text =
            '${suggestion.lastName}, ${suggestion.firstName}';
        model.porterSelected = suggestion;
        await model.loadPayrolls();
      },
      suggestionsBoxController: model.porterBoxController,
    );
  }

  Column _calendar(BuildContext context, EmployeesPayrollViewModel model,
      TextEditingController _datecontroller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Date',
            style: AppTheme.instance.textStyleSmall(
                fontWeight: FontWeight.bold, color: Color(0xFFAEAEAE))),
        InkWell(
          onTap: () => _selectDate(context, model),
          child: IgnorePointer(
            child: Container(
              height: 35.0,
              child: TextField(
                controller: _datecontroller,
                decoration: InputDecoration(
                    hintStyle: AppTheme.instance
                        .textStyleRegular(color: Colors.black.withOpacity(1)),
                    suffixIcon: Image.asset(
                      'assets/icons/calendar.png',
                      scale: 15,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 9.0),
                    hintText: model.selectedDateRange != null
                        ? '${model.formatDateRange(model.selectedDateRange.start)} - ${model.formatDateRange(model.selectedDateRange.end)}'
                        : 'Select date...'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<Null> _selectDate(
      BuildContext context, EmployeesPayrollViewModel model) async {
    final DateTimeRange picked = await showDateRangePicker(
        context: context,
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: Colors.black,
              colorScheme: ColorScheme.light(primary: Colors.black),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child,
          );
        },
        firstDate: DateTime(2021),
        lastDate: DateTime(2032));
    if (picked != null && picked != model.selectedDateRange)
      model.selectDateRange(picked);
  }

  Table _tablePayroll(EmployeesPayrollViewModel model) {
    return Table(
      // defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
      // columnWidths: {
      //   0: FixedColumnWidth(70.0.sp),
      //   1: FixedColumnWidth(70.0.sp),
      //   2: FixedColumnWidth(180.0.sp),
      //   3: FixedColumnWidth(70.0.sp),
      //   4: FixedColumnWidth(50.0.sp),
      // },
      children: [
        TableRow(children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 5.0),
            child: Text(
              'DATE',
              style: AppTheme.instance.textStyleRegular(
                color: AppTheme.instance.primaryFontColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 5.0),
            child: Text(
              'EMPLOYEE',
              style: AppTheme.instance.textStyleRegular(
                color: AppTheme.instance.primaryFontColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 5.0),
            child: Text(
              'LOCATION',
              style: AppTheme.instance.textStyleRegular(
                color: AppTheme.instance.primaryFontColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 5.0),
            child: Text(
              'PROPERTY',
              style: AppTheme.instance.textStyleRegular(
                color: AppTheme.instance.primaryFontColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 5.0),
            child: Text(
              'WAGE',
              style: AppTheme.instance.textStyleRegular(
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
                        style: AppTheme.instance.textStyleRegular(
                          color: AppTheme.instance.primaryFontColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.only(top: 5.0, left: 5.0, bottom: 10.0),
                      child: Text(
                        e.value.employeeName,
                        maxLines: 2,
                        style: AppTheme.instance.textStyleRegular(
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
                        style: AppTheme.instance.textStyleRegular(
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
                        style: AppTheme.instance.textStyleRegular(
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
                        style: AppTheme.instance.textStyleRegular(
                          color: AppTheme.instance.primaryFontColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ]))
          .toList()),
    );
  }
}
