part of filter_violations_view;

class __FilterViolationsMobileState extends StatefulWidget {
  @override
  ___FilterViolationsMobileStateState createState() =>
      ___FilterViolationsMobileStateState();
}

class ___FilterViolationsMobileStateState
    extends State<__FilterViolationsMobileState> {
  TextEditingController _datecontroller = new TextEditingController();
  final TextEditingController marketController = TextEditingController();
  final FocusNode focusMarket = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FilterViolationViewModel>.reactive(
        viewModelBuilder: () => FilterViolationViewModel(),
        onModelReady: (model) {
          model.safeActionRefreshable(() async {
            await model.load();
          });
        },
        builder: (context, model, child) => model.loading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                ),
              )
            : BackgroundPattern(
                child: Container(
                margin:
                    EdgeInsets.symmetric(vertical: 20.0.h, horizontal: 20.0.w),
                child: ListView(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _markets(model, context),
                        ),
                        if (model.propertySelected != null ||
                            model.selectedDate != null)
                          Row(
                            children: [
                              SizedBox(
                                width: 20.0,
                              ),
                              ButtonBlue(
                                onpress: () => {
                                  model.clearFilters(),
                                  marketController.clear(),
                                  _datecontroller.clear()
                                },
                                text: 'Clear filters',
                              ),
                            ],
                          )
                      ],
                    ),
                    SizedBox(
                      height: 60.0.h,
                    ),
                    _buttons(model),
                    SizedBox(
                      height: 40.0.h,
                    ),
                    model.properties.length > 0
                        ? SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: _tableSearch(model))
                        : Center(
                            child: Text("Nothing to show",
                                style: AppTheme.instance.textStyleSmall())),
                    SizedBox(
                      height: 40.0.h,
                    ),
                  ],
                ),
              )));
  }

  Table _tableSearch(FilterViolationViewModel model) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      defaultColumnWidth: FixedColumnWidth(160.0.sp),
      children: [
        TableRow(
            children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0)),
            child: Container(
              padding: EdgeInsets.all(5.0),
              height: 80,
              decoration: BoxDecoration(
                  color: AppTheme.instance.primaryDarkColorBlue,
                  border: Border(
                      bottom: BorderSide(
                          color: Color(0XFF4A4A4A).withOpacity(0.5)))),
              child: Text('Property Name',
                  style: AppTheme.instance.textStyleSmall(
                      fontWeight: FontWeight.w600, color: Colors.white)),
            ),
          ),
        ]..addAll(model.properties.map((e) => Container(
                padding: EdgeInsets.all(4.5),
                height: 80,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Color(0XFF4A4A4A).withOpacity(0.5)))),
                child: _text(e.propertyName))))),
        TableRow(
            children: [
          Container(
            padding: EdgeInsets.all(5.0),
            height: 80,
            decoration: BoxDecoration(
                color: AppTheme.instance.primaryDarkColorBlue,
                border: Border(
                    bottom:
                        BorderSide(color: Color(0XFF4A4A4A).withOpacity(0.5)))),
            child: Text('# of ${Config.violations}',
                style: AppTheme.instance.textStyleSmall(
                    fontWeight: FontWeight.w600, color: Colors.white)),
          ),
        ]..addAll(model.properties.map((e) => Container(
                padding: EdgeInsets.all(4.5),
                height: 80,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Color(0XFF4A4A4A).withOpacity(0.5)))),
                child: _text(e.totalViolations.toString()))))),
        TableRow(
            children: [
          Container(
            padding: EdgeInsets.all(5.0),
            height: 80,
            decoration: BoxDecoration(
                color: AppTheme.instance.primaryDarkColorBlue,
                border: Border(
                    bottom:
                        BorderSide(color: Color(0XFF4A4A4A).withOpacity(0.5)))),
            child: Text('Date Visited',
                style: AppTheme.instance.textStyleSmall(
                    fontWeight: FontWeight.w600, color: Colors.white)),
          ),
        ]..addAll(model.properties.map((e) => Container(
                padding: EdgeInsets.all(4.5),
                height: 80,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Color(0XFF4A4A4A).withOpacity(0.5)))),
                child: _text(model.visitedDateTransform(e.dateVisited)))))),
        TableRow(
            children: [
          ClipRRect(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5.0)),
            child: Container(
              padding: EdgeInsets.all(5.0),
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.instance.primaryDarkColorBlue,
              ),
              child: Text('Address',
                  style: AppTheme.instance.textStyleSmall(
                      fontWeight: FontWeight.w600, color: Colors.white)),
            ),
          ),
        ]..addAll(model.properties
                .map((e) => Container(child: _text(e.address))))),
      ],
    );
  }

  Container _text(String data) {
    return Container(
      padding: EdgeInsets.only(left: 8.0),
      child: Text(data,
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
          style: AppTheme.instance.textStyleSmall(
              fontWeight: FontWeight.w500, color: Colors.black)),
    );
  }

  ButtonsChoose _buttons(FilterViolationViewModel model) {
    return ButtonsChoose(buttons: [
      ButtonsChooseModel(
          margin: EdgeInsets.only(left: 15.0.w),
          icon: Container(
            padding: EdgeInsets.all(10.0),
            child: Image.asset(
              'assets/icons/search.png',
              color: Colors.white,
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
            await model.loadProperties();
          }),
    ]);
  }

  Widget _markets(FilterViolationViewModel model, BuildContext context) {
    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: marketController,
        focusNode: focusMarket,
        onSubmitted: (_) {
          model.changeArrowPositionMarket(false);
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
              icon: Icon(marketController.text.length > 0
                  ? Icons.close_rounded
                  : !model.openBoxMarket
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_up),
              onPressed: () {
                if (marketController.text.length > 0) {
                  marketController.clear();
                } else if (model.openBoxMarket) {
                  model.changeArrowPositionMarket(false, opneBox: 'close');
                } else {
                  model.changeArrowPositionMarket(true, opneBox: 'open');
                }
              },
              color: Color(0xff004A05),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: ColorsUtils.getMaterialColor(0x304A4A4A),
                    width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(6))),
            hintText: 'Filter by property'),
      ),
      suggestionsCallback: (pattern) async {
        List<PropertyModel> data = await model.getMarkets(pattern);
        model.notifyListeners();
        return data;
      },
      noItemsFoundBuilder: (context) => Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(model.propertiesByFilter.length <= 0
              ? 'You don\'t have properties assigned'
              : 'this search does not match'),
        ),
      ),
      suggestionsBoxDecoration: SuggestionsBoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(6))),
      itemBuilder: (context, PropertyModel suggestion) {
        return ListTile(
            title: Text('${suggestion.propertyName}',
                style: AppTheme.instance.textStyleSmall()));
      },
      onSuggestionSelected: (PropertyModel suggestion) {
        model.changeArrowPositionMarket(false);
        marketController.text = '${suggestion.propertyName}';
        model.propertySelected = suggestion;
      },
      suggestionsBoxController: model.marketBoxController,
    );
  }
}
