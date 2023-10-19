part of all_violation_view;

class __AllViolationWebState extends StatefulWidget {
  @override
  ___AllViolationWebStateState createState() => ___AllViolationWebStateState();
}

class ___AllViolationWebStateState extends State<__AllViolationWebState> {
  TextEditingController _datecontroller = new TextEditingController();
  final FocusNode focusProperty = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AllViolationViewModel>.reactive(
        viewModelBuilder: () => AllViolationViewModel(),
        onModelReady: (model) {
          model.safeActionRefreshable(() async {
            await model.load();
          });
        },
        builder: (context, model, child) => Container(
              child: SingleChildScrollView(
                child: StreamBuilder<List<String>>(
                    stream: locator<ReportsService>().reportsLoaded,
                    initialData: [],
                    builder: (context, snapshot) {
                      return Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: ScaleHelper.rsDoubleW(context, 10),
                                vertical: 10.0),
                            child: Row(
                              children: [
                                Expanded(
                                    child: _calendar(
                                        context, model, _datecontroller)),
                                if (model.selectedDateRange != null ||
                                    model.propertySelected != null)
                                  ButtonBlue(
                                    onpress: () => model.clearFilters(),
                                    text: 'Clear filters',
                                  )
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: ScaleHelper.rsDoubleW(context, 10)),
                            child: Row(
                              children: [
                                Expanded(child: _multiSelected(model, context)),
                                if (snapshot.data.length > 0)
                                  ButtonBlue(
                                    onpress: () => model.sendingReport
                                        ? null
                                        : model.sendReport(),
                                    text: model.sendingReport
                                        ? 'Sending...'
                                        : 'Send report',
                                  )
                              ],
                            ),
                          ),
                          model.busy
                              ? Column(
                                  children: [
                                    SizedBox(
                                      height:
                                          ScaleHelper.rsDoubleH(context, 25),
                                    ),
                                    Container(
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                  ],
                                )
                              : model.violations.length < 1
                                  ? Column(
                                      children: [
                                        SizedBox(
                                          height: ScaleHelper.rsDoubleH(
                                              context, 25),
                                        ),
                                        Center(
                                            child: Text("Nothing to show",
                                                style: AppTheme.instance
                                                    .textStyleSmall())),
                                      ],
                                    )
                                  : Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: ScaleHelper.rsDoubleW(
                                              context, 10)),
                                      child: Column(
                                        children: model.violations
                                            .asMap()
                                            .entries
                                            .map((e) => _violation(
                                                e.key, e.value, model))
                                            .toList(),
                                      ),
                                    ),
                        ],
                      );
                    }),
              ),
            ));
  }

  Row _multiSelected(AllViolationViewModel model, BuildContext context) {
    return Row(
      children: [
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: _properties(model, context),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 70.0.w,
        ),
      ],
    );
  }

  Widget _properties(AllViolationViewModel model, BuildContext context) {
    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: model.propertyController,
        focusNode: focusProperty,
        onSubmitted: (_) {
          model.changeArrowPositionProperty(false);
          model.cleanController();
        },
        style: AppTheme.instance.textStyleSmall(),
        decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            filled: true,
            isDense: true,
            isCollapsed: true,
            fillColor: Colors.white,
            hintStyle: AppTheme.instance.textStyleRegular(),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: ColorsUtils.getMaterialColor(0x304A4A4A),
                    width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(6))),
            suffixIcon: InkWell(
              onTap: () {
                if (model.propertyController.text.length > 0) {
                  model.cleanController();
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
                      : !model.openBoxProperty
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
        model.textControllerIsEmpty();
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
        await model.loadViolations();
      },
      suggestionsBoxController: model.propertyBoxController,
    );
  }

  Column _calendar(BuildContext context, AllViolationViewModel model,
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
      BuildContext context, AllViolationViewModel model) async {
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

  Container _violation(
      int index, ViolationModel violation, AllViolationViewModel model) {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 0.2))),
      child: Container(
        margin: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _namePropertyAndFlag(violation, model),
            _violationInfo(violation, model),
            if (!violation.activeEdit)
              SizedBox(
                height: 5.0,
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                    onTap: () {
                      if (!violation.activeEdit) {
                        model.changeText(violation);
                      } else {
                        model.updateTextViolation(model.violations[index]);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Icon(
                        !violation.activeEdit ? Icons.edit : Icons.save,
                        color: AppTheme.instance.primaryColorBlue,
                        size: 20.0,
                      ),
                    )),
                !violation.activeEdit
                    ? Container(
                        child: _description(violation, index, model),
                      )
                    : Expanded(
                        child: Container(
                          child: _aditPropertyInstructionsTextField(
                              violation, index, model),
                        ),
                      ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _aditPropertyInstructionsTextField(
      ViolationModel violation, int index, AllViolationViewModel model) {
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
            maxLines: 5,
            onChanged: (value) {
              model.violations[index].description = value;
            },
            initialValue: model.violations[index].description,
            style: AppTheme.instance.textStyleSmall(
                fontWeight: FontWeight.w500, color: Color(0xFFAEAEAE)),
            decoration: InputDecoration(
                filled: true,
                contentPadding: EdgeInsets.all(10.0),
                fillColor: Colors.white,
                hintText: 'Take a photo of unit 221',
                enabledBorder: const OutlineInputBorder(
                  // width: 0.0 produces a thin "hairline" border
                  borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
          ),
        ],
      ),
    );
  }

  RichText _description(
      ViolationModel violation, int index, AllViolationViewModel model) {
    return RichText(
      text: new TextSpan(
        style: AppTheme.instance
            .textStyleSmall(color: Colors.black, fontWeight: FontWeight.w600),
        children: <TextSpan>[
          new TextSpan(
              text: '${Config.oneViolation} Description: ',
              style: AppTheme.instance.textStyleSmall(
                  color: Colors.black, fontWeight: FontWeight.w600)),
          new TextSpan(
            text: model.violations[index].description,
            style: AppTheme.instance.textStyleSmall(color: Colors.grey[700]),
          ),
        ],
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Row _violationInfo(ViolationModel violation, AllViolationViewModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              _infoViolation(
                  title: 'Market: ',
                  description: violation.property.marketName),
              SizedBox(
                height: 5.0,
              ),
              _infoViolation(
                  title: 'Property: ',
                  description: violation.property.propertyName),
              SizedBox(
                height: 5.0,
              ),
              _infoViolation(
                  title: 'Date of ${Config.oneViolation}: ',
                  description: model.formatDateRange(violation.createdAt.local())),
              SizedBox(
                height: 5.0,
              ),
              _infoViolation(
                  title: 'Time of ${Config.oneViolation}: ',
                  description: model.loadHours(violation.createdAt.local())),
            ],
          ),
        ),
        Container(
          child: _Slides(
              violation.images
                  .map((img) => Image.network(img, errorBuilder:
                          (BuildContext context, Object exception,
                              StackTrace stackTrace) {
                        return const Icon(Icons.image);
                      }))
                  .toList(),
              violation),
          width: ScaleHelper.rsDoubleW(context, 10),
          height: ScaleHelper.rsDoubleW(context, 10),
        ),
      ],
    );
  }

  Row _namePropertyAndFlag(
      ViolationModel violation, AllViolationViewModel model) {
    return Row(
      children: [
        Text(violation.property.propertyName,
            style: AppTheme.instance.textStyleSmall(
                color: AppTheme.instance.primaryDarkColorBlue,
                fontWeight: FontWeight.w600)),
        Spacer(),
        Row(
          children: [
            Text('Add to report',
                style: AppTheme.instance.textStyleSmall(
                    color: AppTheme.instance.primaryDarkColorBlue,
                    fontWeight: FontWeight.normal)),
            Checkbox(
                activeColor: AppTheme.instance.primaryDarkColorBlue,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                value: locator<ReportsService>()
                    .getArray
                    .any((element) => element == violation.id),
                onChanged: (val) {
                  if (val) {
                    model.addItemToReport(violation);
                  } else {
                    model.addItemToReport(violation, remove: true);
                  }
                }),
          ],
        )
      ],
    );
  }

  Row _infoViolation({@required String title, @required String description}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.instance
              .textStyleSmall(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        Expanded(
          child: Text(
            description,
            style: AppTheme.instance.textStyleSmall(color: Colors.grey[700]),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }
}
