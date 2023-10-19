part of all_violation_view;

class __AllWatchlistWebState extends StatefulWidget {
  @override
  ___AllWatchlistWebStateState createState() => ___AllWatchlistWebStateState();
}

class ___AllWatchlistWebStateState extends State<__AllWatchlistWebState> {
  TextEditingController _datecontroller = new TextEditingController();
  final FocusNode focusProperty = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AllWatchlistViewModel>.reactive(
        viewModelBuilder: () => AllWatchlistViewModel(),
        onModelReady: (model) {
          model.safeActionRefreshable(() async {
            await model.load();
          });
        },
        builder: (context, model, child) => Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                      child: Row(
                        children: [
                          Expanded(
                              child:
                                  _calendar(context, model, _datecontroller)),
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
                      padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                      child: Row(
                        children: [
                          Expanded(child: _multiSelected(model, context)),
                          if (model.selectedDateRange != null)
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
                                height: 100.0.h,
                              ),
                              Container(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ],
                          )
                        : model.watchlists.length < 1
                            ? Column(
                                children: [
                                  SizedBox(
                                    height: 100.0.h,
                                  ),
                                  Center(
                                      child: Text("Nothing to show",
                                          style: AppTheme.instance
                                              .textStyleSmall())),
                                ],
                              )
                            : Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        ScaleHelper.rsDoubleW(context, 5)),
                                child: Column(
                                  children: model.watchlists
                                      .map((WatchlistModel violation) =>
                                          InkWell(
                                              onTap: () => null,
                                              child:
                                                  _violation(violation, model)))
                                      .toList(),
                                ),
                              ),
                  ],
                ),
              ),
            ));
  }

  Row _multiSelected(AllWatchlistViewModel model, BuildContext context) {
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
              _properties(model, context),
            ],
          ),
        ),
        SizedBox(
          width: 70.0.w,
        ),
      ],
    );
  }

  Widget _properties(AllWatchlistViewModel model, BuildContext context) {
    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: model.propertyController,
        focusNode: focusProperty,
        onSubmitted: (_) {
          model.changeArrowPositionProperty(false);
          model.cleanController();
        },
        style: AppTheme.instance.textStyleRegular(),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10.0),
            filled: true,
            isDense: true,
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
            suffixIcon: model.selectProperty
                ? InkWell(
                    onTap: () {
                      model.selectProperty = false;
                      model.changeArrowPositionProperty(false);
                      model.propertyController.text = '';
                      model.propertySelected = null;
                      model.loadWatchlists();
                    },
                    child: Icon(
                      Icons.clear_rounded,
                      color: Color(0xff004A05),
                    ),
                  )
                : InkWell(
                    onTap: () {
                      if (model.propertyController.text.length > 0) {
                        model.cleanController();
                      } else if (model.openBoxProperty) {
                        model.changeArrowPositionProperty(false,
                            opneBox: 'close');
                      } else {
                        model.changeArrowPositionProperty(true,
                            opneBox: 'open');
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
        await model.loadWatchlists();
      },
      suggestionsBoxController: model.propertyBoxController,
    );
  }

  Column _calendar(BuildContext context, AllWatchlistViewModel model,
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
      BuildContext context, AllWatchlistViewModel model) async {
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

  Container _violation(WatchlistModel violation, AllWatchlistViewModel model) {
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
          ],
        ),
      ),
    );
  }

  Row _violationInfo(WatchlistModel violation, AllWatchlistViewModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            children: [
              _infoViolation(
                  title: 'Porter: ', description: violation.porterName),
              SizedBox(
                height: 5.0,
              ),
              _infoViolation(title: 'Unit: ', description: violation.name),
              SizedBox(
                height: 5.0,
              ),
              _infoViolation(
                  title: 'Date: ',
                  description: model.formatDateRange(violation.date.local())),
              SizedBox(
                height: 5.0,
              ),
              _infoViolation(
                  title: 'Time: ',
                  description: model.loadHours(violation.date.local())),
            ],
          ),
        ),
        Container(
          child: Image.network(
            violation.image,
            errorBuilder: (BuildContext context, Object exception,
                StackTrace stackTrace) {
              return const Icon(Icons.image);
            },
            width: ScaleHelper.rsDoubleW(context, 10),
            height: ScaleHelper.rsDoubleW(context, 10),
          ),
        ),
      ],
    );
  }

  Row _namePropertyAndFlag(
      WatchlistModel violation, AllWatchlistViewModel model) {
    return Row(
      children: [
        Text(violation.propertyName,
            style: AppTheme.instance.textStyleSmall(
                color: AppTheme.instance.primaryDarkColorBlue,
                fontWeight: FontWeight.w600)),
        Spacer(),
        Text(model.formatDateRange(violation.date.local()),
            style: AppTheme.instance.textStyleSmall(
                color: AppTheme.instance.primaryDarkColorBlue,
                fontWeight: FontWeight.bold)),
        SizedBox(
          width: 10.0,
        ),
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
