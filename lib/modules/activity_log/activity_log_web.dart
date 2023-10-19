part of activity_log_view;

class ActivityLogWebState extends StatefulWidget {
  @override
  _ActivityLogWebStateState createState() => _ActivityLogWebStateState();
}

class _ActivityLogWebStateState extends State<ActivityLogWebState> {
  TextEditingController _datecontroller = new TextEditingController();
  final TextEditingController porterController = TextEditingController();
  final FocusNode focusPorter = FocusNode();
  final TextEditingController propertyController = TextEditingController();
  final FocusNode focusProperty = FocusNode();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ActivityLogViewModel>.reactive(
        viewModelBuilder: () => ActivityLogViewModel(),
        onModelReady: (model) {
          model.safeActionRefreshable(() async {
            await model.load();
            model.scroll.addListener(() {
              model.scrollPosition();
            });
          });
        },
        builder: (context, model, child) => BackgroundPattern(
              child: Container(
                  child: model.busy
                      ? Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Container(
                          child: Column(
                            children: [
                              Container(
                                margin:
                                    EdgeInsets.symmetric(horizontal: 20.0.w),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Text(
                                        'Activity Log',
                                        style: AppTheme.instance.textStyleSmall(
                                            color: AppTheme
                                                .instance.primaryColorBlue,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    IconButton(
                                        icon: Image.asset(
                                          'assets/icons/filter.png',
                                          color: Colors.black,
                                          width: 25.0.sp,
                                        ),
                                        onPressed: () {
                                          model.showFiltersContainer();
                                        })
                                  ],
                                ),
                              ),
                              AnimatedContainer(
                                duration: Duration(milliseconds: 600),
                                curve: Curves.bounceInOut,
                                height: model.showFilters ? null : 0.0,
                                margin:
                                    EdgeInsets.symmetric(horizontal: 20.0.w),
                                child: Column(
                                  children: [
                                    _calendar(context, model, _datecontroller),
                                    _multiSelected(model, context),
                                    SizedBox(
                                      height: 20.0.h,
                                    ),
                                    _buttons(model),
                                  ],
                                ),
                              ),
                              _listActivity(model, context)
                            ],
                          ),
                        )),
            ));
  }

  ButtonsChooseWeb _buttons(ActivityLogViewModel model) {
    return ButtonsChooseWeb(buttons: [
      ButtonsChooseWebModel(
          icon: Container(
            padding: EdgeInsets.all(5.0),
            child: Image.asset(
              'assets/icons/search.png',
              color: Colors.white,
              scale: 3.5,
            ),
          ),
          title: Column(
            children: [
              SizedBox(
                height: 5.0,
              ),
              Text('Search',
                  style: AppTheme.instance.textStyleSmall(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.instance.primaryColorBlue)),
            ],
          ),
          function: () async {
            await model.loadActivity();
          }),
    ]);
  }

  Row _multiSelected(ActivityLogViewModel model, BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  child: Text(
                'Porter',
                style: AppTheme.instance.textStyleSmall(
                    fontWeight: FontWeight.bold, color: Color(0xFFAEAEAE)),
              )),
              _markets(model, context),
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

  Column _calendar(BuildContext context, ActivityLogViewModel model,
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
      BuildContext context, ActivityLogViewModel model) async {
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
        firstDate: DateTime(2019),
        lastDate: DateTime(2032));
    if (picked != null && picked != model.selectedDateRange)
      setState(() {
        model.selectedDateRange = picked;
      });
  }

  Expanded _listActivity(ActivityLogViewModel model, BuildContext context) {
    return Expanded(
      child: Container(
          color: model.showFilters || model.results
              ? Colors.white
              : Colors.transparent,
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0.w),
                child: model.activities.length < 1
                    ? Center(
                        child: Text("Nothing to show",
                            style: AppTheme.instance.textStyleSmall()))
                    : ListView(
                        controller: model.scroll,
                        children: model.activities
                            .map((e) => Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                          color: Color(0xff959595),
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            children: [
                                              Container(
                                                height: 20.0,
                                                width: 6.0,
                                                color: Color.fromRGBO(
                                                    e.colors.r,
                                                    e.colors.g,
                                                    e.colors.b,
                                                    1),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(e.description,
                                                  style: AppTheme.instance
                                                      .textStyleSmall(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                              _infoLog(
                                                  title: 'Time: ',
                                                  description: model
                                                      .formatTime(e.createdAt.local())),
                                              Row(
                                                children: [
                                                  _infoLog(
                                                      title: 'Edited by: ',
                                                      description: e.editedBy),
                                                  if (e.adminId != null)
                                                    Text(' (Admin)',
                                                        style: AppTheme.instance
                                                            .textStyleVerySmall(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal))
                                                ],
                                              ),
                                            ],
                                          ),
                                          Spacer(),
                                          Column(
                                            children: [
                                              Text(
                                                  model.formatDate(e.createdAt.local()),
                                                  style: AppTheme.instance
                                                      .textStyleVerySmall(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight
                                                              .normal)),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    )
                                  ],
                                ))
                            .toList(),
                      ),
              ),
              if (model.showArrow && model.activities.length > 3)
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: 30.0,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: Colors.white),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Icon(
                        Icons.keyboard_arrow_down_sharp,
                        size: 40.0.sp,
                        color: Color(0xff959595),
                      ),
                    ),
                  ),
                )
            ],
          )),
    );
  }

  Row _infoLog({@required String title, @required String description}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.instance.textStyleSmall(
              color: Colors.white, fontWeight: FontWeight.normal),
        ),
        Text(
          description,
          style: AppTheme.instance.textStyleSmall(
            color: Colors.white,
          ),
          maxLines: 2,
        )
      ],
    );
  }

  Widget _markets(ActivityLogViewModel model, BuildContext context) {
    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: porterController,
        focusNode: focusPorter,
        onSubmitted: (_) {
          model.changeArrowPositionPorter(false);
          porterController.clear();
        },
        style: AppTheme.instance.textStyleRegular(),
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: ColorsUtils.getMaterialColor(0x304A4A4A),
                    width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(6))),
            suffixIcon: IconButton(
              icon: Icon(porterController.text.length > 0
                  ? Icons.close_rounded
                  : !model.openBoxPorter
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_up),
              onPressed: () {
                if (porterController.text.length > 0) {
                  porterController.clear();
                } else if (model.openBoxPorter) {
                  model.changeArrowPositionPorter(false, opneBox: 'close');
                } else {
                  model.changeArrowPositionPorter(true, opneBox: 'open');
                }
              },
              color: Color(0xff004A05),
            ),
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
          child: Text(model.porters.length <= 0
              ? 'You don\'t have porters yet'
              : 'this search does not match'),
        ),
      ),
      suggestionsBoxDecoration: SuggestionsBoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(6))),
      itemBuilder: (context, EmployeeDetailModel suggestion) {
        return ListTile(
            title: Text('${suggestion.lastName}, ${suggestion.firstName}',
                style: AppTheme.instance.textStyleRegular()));
      },
      onSuggestionSelected: (EmployeeDetailModel suggestion) {
        model.changeArrowPositionPorter(false);
        porterController.text =
            '${suggestion.lastName}, ${suggestion.firstName}';
        model.porterSelected = suggestion;
      },
      suggestionsBoxController: model.porterBoxController,
    );
  }

  Widget _properties(ActivityLogViewModel model, BuildContext context) {
    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: propertyController,
        focusNode: focusProperty,
        onSubmitted: (_) {
          model.changeArrowPositionProperty(false);
          propertyController.clear();
        },
        style: AppTheme.instance.textStyleRegular(),
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: ColorsUtils.getMaterialColor(0x304A4A4A),
                    width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(6))),
            suffixIcon: IconButton(
              icon: Icon(propertyController.text.length > 0
                  ? Icons.close_rounded
                  : !model.openBoxProperty
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_up),
              onPressed: () {
                if (propertyController.text.length > 0) {
                  propertyController.clear();
                } else if (model.openBoxProperty) {
                  model.changeArrowPositionProperty(false, opneBox: 'close');
                } else {
                  model.changeArrowPositionProperty(true, opneBox: 'open');
                }
              },
              color: Color(0xff004A05),
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
          child: Text(model.properties.length <= 0
              ? 'You don\'t have properties yet'
              : 'this search does not match'),
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
      onSuggestionSelected: (PropertyModel suggestion) {
        model.changeArrowPositionProperty(false);
        propertyController.text = '${suggestion.propertyName}';
        model.propertySelected = suggestion;
      },
      suggestionsBoxController: model.propertyBoxController,
    );
  }
}
