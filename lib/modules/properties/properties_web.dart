part of properties_view;

class _PropertiesWeb extends StatefulWidget {
  @override
  __PropertiesWebState createState() => __PropertiesWebState();
}

class __PropertiesWebState extends State<_PropertiesWeb> {
  final TextEditingController streetController = TextEditingController();
  final FocusNode focusStreet = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PropertiesViewModel>.reactive(
        viewModelBuilder: () => PropertiesViewModel(),
        onModelReady: (model) {
          model.safeActionRefreshable(() async {
            model.load();
            streetController.addListener(() {
              model.updateProperites(
                  streetController.text != null && streetController.text != ""
                      ? streetController.text
                      : null);
            });
          });
        },
        builder: (context, model, child) => model.busy
            ? BackgroundPattern(
                child: SingleChildScrollView(
                    child: Column(children: <Widget>[
                SizedBox(
                  height: 30.w,
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
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 10.0),
                      child: Row(
                        children: [
                          Container(
                            height: 40.0,
                            width: 230.w,
                            child: _streets(model, context),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: model?.properties?.length == 0
                          ? Center(
                              child: Text(
                                'No more properties',
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    color: Colors.black,
                                    fontSize: 10.h),
                              ),
                            )
                          : Center(
                              child: ListView.builder(
                                  itemCount: model?.properties?.length ?? 0,
                                  itemBuilder: (context, i) => _propertyCard(
                                      model: model,
                                      propertyOrder: '$i',
                                      propertyName:
                                          model.properties[i].propertyName,
                                      flagged: model.properties[i].flagged,
                                      market: model.properties[i].marketName,
                                      unit: model.properties[i].units,
                                      update: model.properties[i].updatedAt,
                                      propertyId: model.properties[i].id,
                                      propertyFlagFunction: () {})),
                            ),
                    ),
                    // _navigationButtons(model),
                  ],
                ),
              ));
  }

  Widget _streets(PropertiesViewModel model, BuildContext context) {
    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: streetController,
        focusNode: focusStreet,
        onSubmitted: (_) {
          model.changeArrowPositionStreet(false);
          streetController.clear();
        },
        style: AppTheme.instance.textStyleSmall(),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(kIsWeb ? 10 : 8.w),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: ColorsUtils.getMaterialColor(0x304A4A4A),
                    width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(6))),
            suffixIcon: IconButton(
              padding: EdgeInsets.only(bottom: 2.0),
              icon: Icon(streetController.text.length > 0
                  ? Icons.close_rounded
                  : !model.openBoxProperty
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_up),
              onPressed: () {
                if (streetController.text.length > 0) {
                  streetController.clear();
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
            hintText: 'Filter by: Property Name'),
      ),
      suggestionsCallback: (pattern) async {
        return await model.getProperties(pattern);
      },
      noItemsFoundBuilder: (context) => Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(model.properties == null || model.properties.length <= 0
              ? 'You don\'t have properties'
              : 'this search does not match'),
        ),
      ),
      suggestionsBoxDecoration: SuggestionsBoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(6))),
      itemBuilder: (context, PropertyModel suggestion) {
        return ListTile(
            title: Text(suggestion.propertyName,
                overflow: TextOverflow.ellipsis,
                style: AppTheme.instance.textStyleSmall()));
      },
      onSuggestionSelected: (PropertyModel suggestion) async {
        model.changeArrowPositionStreet(false);
        streetController.text = suggestion.propertyName;
        model.chooseProperty(suggestion);
        await model.getProperties(suggestion.propertyName);
      },
      suggestionsBoxController: model.propertyBoxController,
    );
  }

  Widget _propertyCard({
    String propertyOrder,
    String propertyName,
    bool flagged,
    String market,
    String unit,
    Timestamp update,
    String propertyId,
    Function propertyFlagFunction,
    PropertiesViewModel model,
  }) {
    DateTime convertedDate;
    String formatedDate;
    if (update != null) {
      convertedDate =
          DateTime.fromMillisecondsSinceEpoch(update.millisecondsSinceEpoch);
      formatedDate = DateFormat('d/M/y').format(convertedDate);
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => model.navigateToEditProperty(propertyId),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    _propertyTitle(
                        title: 'Property $propertyOrder: ',
                        value: propertyName,
                        titleColor: AppTheme.instance.primaryColorBlue),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    _propertyTitle(
                        title: 'Market: ', value: market == null ? '' : market),
                    Spacer(),
                    if (formatedDate != null)
                      _propertyTitle(title: 'Update: ', value: formatedDate),
                  ],
                )
              ],
            ),
          ),
        ),
        _divider(),
      ],
    );
  }

  // Widget _navigationButtons(PropertiesViewModel model) {
  //   Color _prevButtonColor =
  //       model.prevExist ? AppTheme.instance.primaryColorBlue : Colors.grey;
  //   Color _nextButtonColor =
  //       model.nextExist ? AppTheme.instance.primaryColorBlue : Colors.grey;
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       InkWell(
  //         onTap:
  //             model.prevExist ? () => model.paginatedProperties(false) : null,
  //         child: Container(
  //           height: 10.w,
  //           width: 11.6.w,
  //           decoration: BoxDecoration(
  //               borderRadius: BorderRadius.only(
  //                   topLeft: Radius.circular(15),
  //                   bottomLeft: Radius.circular(15)),
  //               border: Border.all(color: _prevButtonColor, width: 0.7.w)),
  //           child: Center(
  //             child: Icon(
  //               Icons.chevron_left,
  //               color: _prevButtonColor,
  //             ),
  //           ),
  //         ),
  //       ),
  //       SizedBox(
  //         width: 10.w,
  //       ),
  //       BigRoundActionButtonView(
  //         () => {model.navigateAddProperty()},
  //         "Add Properties",
  //         "assets/icons/add_property.png",
  //         isWeb: true,
  //       ),
  //       SizedBox(
  //         width: 10.w,
  //       ),
  //       InkWell(
  //         onTap: model.nextExist ? () => model.paginatedProperties(true) : null,
  //         child: Container(
  //           height: 10.w,
  //           width: 11.6.w,
  //           decoration: BoxDecoration(
  //               borderRadius: BorderRadius.only(
  //                   topRight: Radius.circular(15),
  //                   bottomRight: Radius.circular(15)),
  //               border: Border.all(color: _nextButtonColor, width: 0.7.w)),
  //           child: Center(
  //               child: Icon(
  //             Icons.chevron_right,
  //             color: _nextButtonColor,
  //           )),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _propertyTitle(
      {String title = '',
      String value = '',
      Color titleColor = Colors.black,
      int index = 1}) {
    return Align(
      alignment: index == 1
          ? Alignment.centerLeft
          : index == 3
              ? Alignment.centerRight
              : Alignment.center,
      child: RichText(
          text: TextSpan(
              text: title,
              style: TextStyle(
                  color: titleColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.h),
              children: [
            TextSpan(
                text: value,
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.normal))
          ])),
    );
  }

  Widget _divider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 100.w),
      child: Divider(
        thickness: 0.8.h,
        height: 0.8.h,
        color: AppTheme.instance.primaryDarker,
      ),
    );
  }
}
