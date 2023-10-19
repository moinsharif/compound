part of edit_property_view;

class _EditPropertyWeb extends StatefulWidget {
  @override
  __EditPropertyWebState createState() => __EditPropertyWebState();
}

class __EditPropertyWebState extends State<_EditPropertyWeb> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final TextEditingController searchPorterController = TextEditingController();
  final FocusNode _focusAddress = FocusNode();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EditPropertyViewModel>.reactive(
      viewModelBuilder: () => EditPropertyViewModel(),
      onModelReady: (model) {
        model.safeActionRefreshable(
            () => model.load(ModalRoute.of(context).settings.arguments));
        model.addressController.addListener(() {
          model.updateAddress(model.addressController.text != null &&
                  model.addressController.text != ""
              ? model.addressController.text
              : null);
        });
      },
      builder: (context, model, child) => model.busy
          ? BackgroundPattern(
              child: SingleChildScrollView(
                  child: Column(children: <Widget>[
              SizedBox(
                height: 100.w,
              ),
              Center(
                  child: Image.asset(
                AppTheme.instance.brandLogo,
                width: 140.w,
              )),
              SizedBox(
                height: 40.w,
              ),
              CircularProgressIndicator(
                backgroundColor: Colors.blue,
              )
            ])))
          : BackgroundPattern(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ScaleHelper.rsDoubleW(context, 15),
                    vertical: 20),
                child: Center(
                  child: SingleChildScrollView(
                    child: FormBuilder(
                      key: _fbKey,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _addPropertyTextField(
                                    name: 'propertyName',
                                    label: 'Property Name',
                                    initialValue:
                                        model.loadedProperty.propertyName),
                              ),
                              Column(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Active',
                                      style: AppTheme.instance.textStyleSmall(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                    ),
                                  ),
                                  Switch(
                                    value: model.activePropertyValue,
                                    onChanged: (active) => {
                                      model.handleRadioValueActiveChange(active)
                                    },
                                    activeColor:
                                        AppTheme.instance.primaryDarkColorBlue,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          _address(model),
                          _addPropertyTextField(
                              name: 'units',
                              label: 'Units',
                              initialValue: model.loadedProperty.units),
                          _addPropertyTextField(
                              name: 'phone',
                              label: 'Phone',
                              initialValue: model.loadedProperty.phone),
                          _emailTags(model),
                          _searchMarket(model),
                          _addPropertyInstructionsTextField(model),
                          _selectRate(model, context),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: model
                                      .loadedProperty.configProperty.porters
                                      .where((element) =>
                                          element.temporary == null ||
                                          (element.temporary != null &&
                                              element.temporary == false))
                                      .map((e) => Container(
                                            margin: EdgeInsets.only(
                                                bottom: 10.0.h,
                                                left: model
                                                            .loadedProperty
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
                                                    BorderRadius.circular(
                                                        10.0)),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                    '${e.lastName}, ${e.firstName} ',
                                                    style: AppTheme.instance
                                                        .textStyleSmall(
                                                            color: Color(
                                                                    0xff000000)
                                                                .withOpacity(
                                                                    1))),
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
                          _textCustomRecurrence(),
                          _choiseDays(model),
                          _radioButtons(model),
                          _selectRangeTimeService(model, context),
                          BigRoundActionButtonViewWeb(
                            () => {model.updateProperty(_fbKey.currentState)},
                            "Edit",
                            "assets/icons/save_new.png",
                            busy: model.busy,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Column _selectRangeTimeService(
      EditPropertyViewModel model, BuildContext context) {
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

  Future<Null> _selectRangeTime(EditPropertyViewModel model) async {
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
        model.selectedTime = picked;
      });
  }

  Container _radioButtons(EditPropertyViewModel model) {
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

  Future<Null> _selectDate(EditPropertyViewModel model) async {
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

  Container _choiseDays(EditPropertyViewModel model) {
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
          if (model.loadedProperty?.configProperty?.daysSelected != null)
            Row(
              children: model.loadedProperty.configProperty.daysSelected
                  .map((e) => model.loadedProperty.configProperty.daysSelected
                              .first ==
                          e
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
                                  style: AppTheme.instance.textStyleVerySmall(
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
                                  style: AppTheme.instance.textStyleVerySmall(
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

  Widget _searchEmployee(EditPropertyViewModel model, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
          controller: searchPorterController,
          onSubmitted: (_) {
            model.changeArrowPositionPorter(false);
            searchPorterController.clear();
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
                  style: AppTheme.instance.textStyleRegular()));
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

  Column _selectRate(EditPropertyViewModel model, BuildContext context) {
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
                      return SetRateProperty(property: model.loadedProperty);
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

  Widget _searchMarket(EditPropertyViewModel model) {
    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: model.searchMarketController,
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
        model.searchMarketController.text =
            '${suggestion.name}, ${suggestion.state}';
      },
      suggestionsBoxController: model.propertyBoxController,
    );
  }

  Widget _address(EditPropertyViewModel model) {
    return TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
          controller: model.addressController,
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
          model.addressController.text = suggestion.name;
          // model.addressSelected = suggestion;
        });
  }

  Widget _addPropertyTextField(
      {String name, String label, String hintText, String initialValue}) {
    return FormBuilderTextField(
      name: name,
      decoration: InputDecoration(hintText: label),
      initialValue: initialValue,
    );
  }

  Widget _addPropertyInstructionsTextField(EditPropertyViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add Special Instructions:',
          style: TextStyle(
              color: Color(0XFF4A4A4A),
              decoration: TextDecoration.none,
              fontSize: 12,
              fontWeight: FontWeight.normal),
        ),
        SizedBox(
          height: 10.h,
        ),
        FormBuilderTextField(
          name: 'specialInstructions',
          initialValue: model.loadedProperty.specialInstructions,
          maxLines: 7,
          decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              filled: true,
              fillColor: Colors.white,
              hintText: 'Take a photo of unit 221',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)))),
        ),
      ],
    );
  }

  Widget _emailTags(EditPropertyViewModel model) {
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
      initialTags: model.loadedProperty.emails,
      textFieldStyler: TextFieldStyler(
        hintText: "emails",
        isDense: false,
        textFieldFocusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1.0),
        ),
        textFieldBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1.0),
        ),
      ),
      onDelete: (tag) {
        model.loadedProperty.emails.remove(tag);
        print('onDelete: $tag');
      },
      onTag: (tag) {
        print('onTag: $tag');
      },
      validator: (String text) {
        print('validator: $text');
        if (!EmailValidator.validate(text)) {
          return "email is incorrect";
        } else if (model.loadedProperty.emails != null &&
            model.loadedProperty.emails.contains(text)) {
          return "email already exist";
        }
        model.loadedProperty = model.loadedProperty
            .copyWith(emails: [...model.loadedProperty.emails, text]);
        return null;
      },
    );
  }

  Widget _marketsSelector(EditPropertyViewModel model) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 100.w),
      child: FormBuilderDropdown(
          name: 'marketName',
          initialValue: model.selectedMarket,
          decoration: InputDecoration(
              labelText: 'Market',
              labelStyle: TextStyle(fontSize: 20, color: Color(0xFF8C8E91))),
          items: model.marketStrings.map((market) {
            return DropdownMenuItem(
              value: market,
              child: Text(market.showName),
            );
          }).toList()),
    );
  }
}
