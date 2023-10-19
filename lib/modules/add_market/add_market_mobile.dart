part of add_market_view;

class __AddMarketsMobileState extends StatefulWidget {
  @override
  ___AddMarketsMobileStateState createState() =>
      ___AddMarketsMobileStateState();
}

class ___AddMarketsMobileStateState extends State<__AddMarketsMobileState> {
  final TextEditingController searchMarketController = TextEditingController();
  final FocusNode focusSearchMarket = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddMarketsViewModel>.reactive(
        viewModelBuilder: () => AddMarketsViewModel(),
        onModelReady: (model) {
          model.safeActionRefreshable(() async {
            await model.load(ModalRoute.of(context).settings.arguments);
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Add New Market:',
                        style: AppTheme.instance.textStyleSmall(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff000000).withOpacity(1))),
                    SizedBox(
                      height: 20.0.h,
                    ),
                    _searchMarket(model, context),
                    Expanded(
                        child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10.0.h),
                            child: SingleChildScrollView(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: model.selectedMarkets
                                      .map((e) => Container(
                                            margin:
                                                EdgeInsets.only(bottom: 10.0.h),
                                            padding: EdgeInsets.all(5.0),
                                            decoration: BoxDecoration(
                                                color: Color(0xffB5B2B2),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text('${e.name}, ${e.state} ',
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
                                                    model.removeMarket(e);
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
                            ))),
                    _buttons(model),
                  ],
                ),
              )));
  }

  Widget _searchMarket(AddMarketsViewModel model, BuildContext context) {
    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: searchMarketController,
        focusNode: focusSearchMarket,
        onSubmitted: (_) {
          model.changeArrowPositionStreet(false);
          searchMarketController.clear();
          setState(() {});
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
              icon: Icon(searchMarketController.text.length > 0
                  ? Icons.close_rounded
                  : !model.openBoxProperty
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_up),
              onPressed: () {
                if (searchMarketController.text.length > 0) {
                  searchMarketController.clear();
                  setState(() {});
                } else if (model.openBoxProperty) {
                  model.changeArrowPositionStreet(false, opneBox: 'close');
                } else {
                  model.changeArrowPositionStreet(true, opneBox: 'open');
                }
              },
              color: Color(0xff004A05),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: ColorsUtils.getMaterialColor(0x304A4A4A),
                    width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(6))),
            hintText: 'Select a Market'),
      ),
      suggestionsCallback: (pattern) async {
        List<MarketModel> data = await model.getMarkets(pattern);
        setState(() {});
        return data;
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
        model.addMarket(suggestion);
        searchMarketController.text = '';
      },
      suggestionsBoxController: model.propertyBoxController,
    );
  }

  Row _buttons(AddMarketsViewModel model) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    model.goToBack(backWithoutSave: true);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border:
                            Border.all(color: Color(0XFF606060), width: 1.5),
                        borderRadius: BorderRadius.circular(50.0)),
                    height: 30.w,
                    width: 30.w,
                    child: Icon(
                      Icons.arrow_back_ios_sharp,
                      size: 23.0,
                      color: Color(0XFF606060),
                    ),
                  ),
                ),
                Container(
                  child: Text('Back',
                      style: AppTheme.instance.textStyleSmall(
                          fontWeight: FontWeight.w600,
                          color: Color(0XFF606060))),
                )
              ],
            ),
          ),
          Spacer(),
          Column(
            children: [
              InkWell(
                onTap: () async {
                  if (!model.busy) {
                    if (await model.updateMarkets()) {
                      model.goToBack();
                    } else {
                      ScaffoldMessenger.of(locator<DialogService>()
                              .scaffoldKey
                              .currentContext)
                          .showSnackBar(SnackBar(
                        content: Text('No uploaded data'),
                      ));
                      model.goToBack(backWithoutSave: true);
                    }
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Color(0XFF606060), width: 1.5),
                      borderRadius: BorderRadius.circular(50.0)),
                  height: 30.w,
                  width: 30.w,
                  child: model.busy
                      ? CircularProgressIndicator()
                      : Icon(
                          Icons.done,
                          size: 23.0,
                          color: Color(0XFF606060),
                        ),
                ),
              ),
              Container(
                child: Text('Complete',
                    style: AppTheme.instance.textStyleSmall(
                        fontWeight: FontWeight.w600, color: Color(0XFF606060))),
              )
            ],
          )
        ]);
  }
}
