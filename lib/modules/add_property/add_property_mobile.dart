part of add_property_view;

class _AddPropertyMobile extends StatefulWidget {
  @override
  __AddPropertyMobileState createState() => __AddPropertyMobileState();
}

class __AddPropertyMobileState extends State<_AddPropertyMobile> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final TextEditingController _addressController = new TextEditingController();
  final FocusNode _focusAddress = FocusNode();
  final TextEditingController searchMarketController = TextEditingController();
  final TextEditingController searchPorterController = TextEditingController();
  final FocusNode focusInstructions = FocusNode();
  final FocusNode focusSearchMarket = FocusNode();
  final FocusNode focusSearchPorter = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddPropertyViewModel>.reactive(
        viewModelBuilder: () => AddPropertyViewModel(),
        onModelReady: (model) {
          model.safeActionRefreshable(() {
            model.load();
          });
        },
        builder: (context, model, child) => GestureDetector(
            onTap: () {
              focusInstructions?.unfocus();
            },
            child: BackgroundPattern(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: SingleChildScrollView(
                  child: FormBuilder(
                    key: _fbKey,
                    child: Column(children: [
                      _addPropertyTextField(
                        name: 'propertyName',
                        label: 'Property Name',
                      ),
                      _address(model),
                      _addPropertyTextField(
                          name: 'units', label: 'Total Units'),
                      _addPropertyTextField(name: 'phone', label: 'Phone'),
                      _emailTags(model),
                      _searchMarket(model),
                      _addPropertyInstructionsTextField(),
                      _textCustomRecurrence(),
                      _choiseDays(model),
                      _radioButtons(model),
                      _selectRangeTimeService(model, context),
                      _selectRate(model, context),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: model.newProperty.configProperty.porters
                                  .map((e) => Container(
                                        margin: EdgeInsets.only(
                                            bottom: 10.0.h,
                                            left: model
                                                        .newProperty
                                                        .configProperty
                                                        .porters
                                                        .first !=
                                                    e
                                                ? 8.0
                                                : 0.0),
                                        padding: EdgeInsets.all(5.0),
                                        decoration: BoxDecoration(
                                            color: Color(0xffB5B2B2),
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                                '${e.lastName}, ${e.firstName} ',
                                                style: AppTheme.instance
                                                    .textStyleSmall(
                                                        color: Color(0xff000000)
                                                            .withOpacity(1))),
                                            Container(
                                                height: 20.0,
                                                width: 1.0,
                                                color: Colors.grey[600]),
                                            InkWell(
                                              onTap: () {
                                                model.removeEmployee(e);
                                              },
                                              child: Icon(
                                                Icons.clear,
                                                size: 15.0,
                                              ),
                                            )
                                          ],
                                        ),
                                      ))
                                  .toList()),
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      BigRoundActionButtonView(
                        () => {model.addProperty(_fbKey.currentState)},
                        "Save",
                        "assets/icons/save_new.png",
                        busy: model.busy,
                      ),
                      SizedBox(
                        height: 60.0,
                      ),
                    ]),
                  ),
                ),
              ),
            )));
  }

  Column _selectRate(AddPropertyViewModel model, BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        'Rate',
        style: AppTheme.instance
            .textStyleSmall(fontWeight: FontWeight.w500, color: Colors.black),
      ),
      SizedBox(
        height: 5.0,
      ),
      SizedBox(
        height: 35.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _searchEmployee(model, context)),
            InkWell(
              onTap: () {
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return SetRateProperty(property: model.newProperty);
                    }));
              },
              child: Container(
                decoration: BoxDecoration(
                    color: AppTheme.instance.colorGreyLight,
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: Colors.black)),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Set Daily Rate',
                    style: AppTheme.instance.textStyleSmall(
                        fontWeight: FontWeight.w500, color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    ]);
  }

  Widget _searchEmployee(AddPropertyViewModel model, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
          controller: searchPorterController,
          focusNode: focusSearchPorter,
          onSubmitted: (_) {
            model.changeArrowPositionPorter(false);
            searchPorterController.clear();
          },
          style: AppTheme.instance.textStyleSmall(),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(8.w),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: ColorsUtils.getMaterialColor(0x304A4A4A),
                      width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              suffixIcon: IconButton(
                icon: Icon(searchPorterController.text.length > 0
                    ? Icons.close_rounded
                    : !model.openBoxPorter
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up),
                onPressed: () {
                  if (searchPorterController.text.length > 0) {
                    searchPorterController.clear();
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
              hintText: 'Select a Porter'),
        ),
        suggestionsCallback: (pattern) async {
          List<EmployeeDetailModel> data = await model.getEmployees(pattern);
          model.refresh();
          return data;
        },
        noItemsFoundBuilder: (context) => Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(model.markets.length <= 0
                ? 'We don\'t find porters availables'
                : 'this search does not match'),
          ),
        ),
        suggestionsBoxDecoration: SuggestionsBoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(6))),
        itemBuilder: (context, EmployeeDetailModel suggestion) {
          return ListTile(
              title: Text('${suggestion.lastName}, ${suggestion.firstName}',
                  style: AppTheme.instance.textStyleSmall()));
        },
        onSuggestionSelected: (EmployeeDetailModel suggestion) {
          model.changeArrowPositionPorter(false);
          model.addEmployee(suggestion);
          searchPorterController.text = '';
        },
        suggestionsBoxController: model.porterBoxController,
      ),
    );
  }

  Column _selectRangeTimeService(
      AddPropertyViewModel model, BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        'Time',
        style: AppTheme.instance
            .textStyleSmall(fontWeight: FontWeight.w500, color: Colors.black),
      ),
      SizedBox(
        height: 5.0,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (model.selectedTime == null)
            InkWell(
              onTap: () {
                _selectRangeTime(model);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: AppTheme.instance.colorGreyLight,
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: Colors.black)),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Select time',
                    style: AppTheme.instance.textStyleSmall(
                        fontWeight: FontWeight.w500, color: Colors.black),
                  ),
                ),
              ),
            ),
          if (model.selectedTime != null)
            InkWell(
              onTap: () {
                _selectRangeTime(model);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: Colors.black)),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Start: ${model.selectedTime.startTime.format(context)}',
                    style: AppTheme.instance.textStyleSmall(
                        fontWeight: FontWeight.w500, color: Colors.black),
                  ),
                ),
              ),
            ),
          if (model.selectedTime != null)
            InkWell(
              onTap: () {
                _selectRangeTime(model);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: Colors.black)),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'End: ${model.selectedTime.endTime.format(context)}',
                    style: AppTheme.instance.textStyleSmall(
                        fontWeight: FontWeight.w500, color: Colors.black),
                  ),
                ),
              ),
            ),
        ],
      )
    ]);
  }

  Container _radioButtons(AddPropertyViewModel model) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Theme(
          data: ThemeData(
              unselectedWidgetColor: AppTheme.instance.primaryDarkColorBlue),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ends',
                style: AppTheme.instance.textStyleSmall(
                    fontWeight: FontWeight.w500, color: Colors.black),
              ),
              SizedBox(
                height: 5.0,
              ),
              Row(
                children: [
                  Radio(
                    value: 0,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    groupValue: model.radioValue,
                    onChanged: model.handleRadioValueChange,
                    activeColor: AppTheme.instance.primaryDarkColorBlue,
                  ),
                  Text(
                    'Never',
                    style: AppTheme.instance.textStyleRegular(
                        fontWeight: FontWeight.w500, color: Colors.black),
                  ),
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: 1,
                    groupValue: model.radioValue,
                    onChanged: model.handleRadioValueChange,
                    activeColor: AppTheme.instance.primaryDarkColorBlue,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                  Text(
                    'On',
                    style: AppTheme.instance.textStyleRegular(
                        fontWeight: FontWeight.w500, color: Colors.black),
                  ),
                  SizedBox(
                    width: 70.0.w,
                  ),
                  InkWell(
                    onTap: () {
                      if (model.radioValue == 1) _selectDate(model);
                    },
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          color: model.radioValue == 1
                              ? Colors.white
                              : AppTheme.instance.colorGreyLight,
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(
                              color: model.radioValue == 1
                                  ? Colors.black
                                  : Colors.transparent)),
                      child: Text(
                        model.showDate,
                        style: AppTheme.instance.textStyleSmall(
                            fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  Future<Null> _selectDate(AddPropertyViewModel model) async {
    final DateTime picked = await showDatePicker(
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
        initialDate: DateTime.now(),
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        lastDate: DateTime(2032));
    if (picked != null)
      setState(() {
        model.endDate = picked;
        model.formatDateRange(picked);
      });
  }

  Future<Null> _selectRangeTime(AddPropertyViewModel model) async {
    final TimeRange picked = await showTimeRangePicker(
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
      start:
          TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
      onStartChange: (start) {
        print("start time " + start.toString());
      },
      onEndChange: (end) {
        print("end time " + end.toString());
      },
      interval: Duration(minutes: 30),
      use24HourFormat: false,
      padding: 30,
      strokeWidth: 20,
      handlerRadius: 14,
      strokeColor: AppTheme.instance.primaryDarkColorBlue,
      handlerColor: Colors.black,
      selectedColor: AppTheme.instance.primaryDarkColorBlue,
      backgroundColor: Colors.black.withOpacity(0.3),
      ticks: 12,
      ticksColor: Colors.white,
      snap: true,
      labels: ["12 pm", "3 am", "6 am", "9 am", "12 am", "3 pm", "6 pm", "9 pm"]
          .asMap()
          .entries
          .map((e) {
        return ClockLabel.fromIndex(idx: e.key, length: 8, text: e.value);
      }).toList(),
      labelOffset: -30,
      labelStyle: TextStyle(
          fontSize: 22, color: Colors.grey, fontWeight: FontWeight.bold),
      timeTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold),
      activeTimeTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 26,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold),
    );
    if (picked != null)
      setState(() {
        print(picked);
        model.selectedTime = picked;
      });
  }

  Container _choiseDays(AddPropertyViewModel model) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Repeat on',
            style: AppTheme.instance.textStyleSmall(
                fontWeight: FontWeight.w500, color: Colors.black),
          ),
          SizedBox(
            height: 5.0,
          ),
          if (model.newProperty?.configProperty?.daysSelected != null)
            Row(
              children: model.newProperty.configProperty.daysSelected
                  .map((e) =>
                      model.newProperty.configProperty.daysSelected.first == e
                          ? InkWell(
                              onTap: () {
                                model.selectDay(e);
                              },
                              child: Container(
                                height: 25.0,
                                width: 25.0,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: e.selected
                                        ? AppTheme.instance.primaryDarkColorBlue
                                        : AppTheme.instance.colorGreyLight),
                                child: Center(
                                  child: Text(e.shortNameDay,
                                      style: AppTheme.instance
                                          .textStyleVerySmall(
                                              fontWeight: FontWeight.w500,
                                              color: e.selected
                                                  ? Colors.white
                                                  : Colors.black)),
                                ),
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                model.selectDay(e);
                              },
                              child: Container(
                                height: 25.0,
                                width: 25.0,
                                margin: EdgeInsets.only(left: 8.0),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: e.selected
                                        ? AppTheme.instance.primaryDarkColorBlue
                                        : AppTheme.instance.colorGreyLight),
                                child: Center(
                                  child: Text(e.shortNameDay,
                                      style: AppTheme.instance
                                          .textStyleVerySmall(
                                              fontWeight: FontWeight.w500,
                                              color: e.selected
                                                  ? Colors.white
                                                  : Colors.black)),
                                ),
                              ),
                            ))
                  .toList(),
            )
        ],
      ),
    );
  }

  Container _textCustomRecurrence() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        'Custom recurrence',
        style: AppTheme.instance
            .textStyleSmall(fontWeight: FontWeight.w500, color: Colors.black),
      ),
    );
  }

  Widget _address(AddPropertyViewModel model) {
    return TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
          controller: _addressController,
          focusNode: _focusAddress,
          style: AppTheme.instance.textStyleRegular(),
          decoration: InputDecoration(hintText: 'Address'),
        ),
        suggestionsCallback: (pattern) async {
          return await model.getLocationResults(pattern);
        },
        noItemsFoundBuilder: (context) => Container(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(model.searchAddress.length <= 0
                    ? 'type the property address'
                    : 'this search does not match'),
              ),
            ),
        suggestionsBoxDecoration: SuggestionsBoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(6))),
        itemBuilder: (context, Results suggestion) {
          return ListTile(
              title: Text(suggestion.formattedAddress,
                  style: AppTheme.instance.textStyleSmall()));
        },
        onSuggestionSelected: (Results suggestion) {
          _addressController.text =
              suggestion.formattedAddress ?? suggestion.name;
          model.addressSelected = suggestion;
        });
  }

  Widget _emailTags(AddPropertyViewModel model) {
    return TextFieldTags(
      tagsStyler: TagsStyler(
        tagMargin: const EdgeInsets.only(right: 4.0),
        tagCancelIcon: Icon(Icons.cancel, size: 15.0, color: Colors.black),
        tagCancelIconPadding: EdgeInsets.only(left: 4.0, top: 2.0),
        tagPadding:
            EdgeInsets.only(top: 2.0, bottom: 4.0, left: 8.0, right: 4.0),
        tagDecoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey.shade300,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        tagTextStyle: AppTheme.instance.textStyleSmall(),
      ),
      textFieldStyler: TextFieldStyler(
        hintText: "Email",
        isDense: false,
        textFieldFocusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1.0),
        ),
        textFieldBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1.0),
        ),
      ),
      onDelete: (tag) {
        model.newProperty.emails.remove(tag);
        print('onDelete: $tag');
      },
      onTag: (tag) {
        print('onTag: $tag');
      },
      validator: (String text) {
        print('validator: $text');
        if (!EmailValidator.validate(text)) {
          return "email is incorrect";
        } else if (model.newProperty.emails != null &&
            model.newProperty.emails.contains(text)) {
          return "email already exist";
        }
        model.newProperty = model.newProperty
            .copyWith(emails: [...model.newProperty.emails, text]);
        return null;
      },
    );
  }

  Widget _searchMarket(AddPropertyViewModel model) {
    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: searchMarketController,
        focusNode: focusSearchMarket,
        onSubmitted: (_) {
          model.changeArrowPositionStreet(false);
        },
        style: AppTheme.instance.textStyleRegular(),
        decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(!model.openBoxProperty
                  ? Icons.keyboard_arrow_down
                  : Icons.keyboard_arrow_up),
              onPressed: () {
                if (model.openBoxProperty) {
                  model.changeArrowPositionStreet(false, opneBox: 'close');
                } else {
                  model.changeArrowPositionStreet(true, opneBox: 'open');
                }
              },
              color: Color(0xff004A05),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 12.0),
            hintText: 'Select a Market'),
      ),
      suggestionsCallback: (pattern) async {
        return await model.getMarkets(pattern);
      },
      noItemsFoundBuilder: (context) => Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(model.markets.length <= 0
              ? 'We don\'t find markets availables'
              : 'this search does not match'),
        ),
      ),
      suggestionsBoxDecoration: SuggestionsBoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(6))),
      itemBuilder: (context, MarketModel suggestion) {
        return ListTile(
            title: Text('${suggestion.name}, ${suggestion.state}',
                style: AppTheme.instance.textStyleSmall()));
      },
      onSuggestionSelected: (MarketModel suggestion) {
        model.changeArrowPositionStreet(false);
        model.marketSelected = suggestion;
        searchMarketController.text = '${suggestion.name}, ${suggestion.state}';
      },
      suggestionsBoxController: model.propertyBoxController,
    );
  }

  Widget _addPropertyTextField({String name, String label, String hintText}) {
    return FormBuilderTextField(
      name: name,
      decoration: InputDecoration(labelText: label),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(context),
      ]),
    );
  }

  Widget _addPropertyInstructionsTextField() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Special Instructions:',
            style: AppTheme.instance.textStyleSmall(
                fontWeight: FontWeight.w500, color: Colors.black),
          ),
          SizedBox(
            height: 10.h,
          ),
          FormBuilderTextField(
            name: 'specialInstructions',
            focusNode: focusInstructions,
            maxLines: 5,
            style: AppTheme.instance.textStyleSmall(
                fontWeight: FontWeight.w500, color: Color(0xFFAEAEAE)),
            decoration: InputDecoration(
                filled: true,
                contentPadding: EdgeInsets.all(10.0),
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
          ),
        ],
      ),
    );
  }
}
