part of properties_view;

class _PropertiesMobile extends StatefulWidget {
  @override
  __PropertiesMobileState createState() => __PropertiesMobileState();
}

class __PropertiesMobileState extends State<_PropertiesMobile> {
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
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 40.0,
                            width: 230.w,
                            child: _streets(model, context),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    'Show inactive Properties',
                                    style: AppTheme.instance.textStyleSmall(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                ),
                                Switch(
                                  value: model.activeProperties,
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
                          ),
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
                          : ListView.builder(
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
                                  propertyFlagFunction: () {
                                    if (!model.properties[i].flagged) {
                                      showAlert(context, model, i);
                                    } else {
                                      setState(() {
                                        model.propertyFlag(
                                            model.properties[i].id,
                                            model.properties[i].flagged,
                                            model.properties[i]
                                                .specialInstructions);
                                        model.properties[i].flagged =
                                            !model.properties[i].flagged;
                                      });
                                    }
                                  })),
                    ),
                    Expanded(
                        flex: 2,
                        child: BigRoundActionButtonView(
                            () => {model.navigateAddProperty()},
                            "Add Property",
                            "assets/icons/add_property.png"))
                  ],
                ),
              ));
  }

  Future<dynamic> showAlert(
    BuildContext context,
    PropertiesViewModel model,
    int i,
  ) {
    final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
    final TextEditingController instructionController = TextEditingController();
    instructionController.text = model.properties[i].specialInstructions ?? '';
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Stack(
              clipBehavior: Clip.hardEdge,
              children: <Widget>[
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: CircleAvatar(
                      child: Icon(Icons.close),
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
                FormBuilder(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _addPropertyInstructionsTextField(
                          model.properties[i], instructionController),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                            child: Text("Flag Property"),
                            onTap: () {
                              try {
                                setState(() {
                                  model.propertyFlag(
                                      model.properties[i].id,
                                      model.properties[i].flagged,
                                      model.properties[i].flagged
                                          ? model
                                              .properties[i].specialInstructions
                                          : instructionController.text);
                                  model.properties[i].flagged =
                                      !model.properties[i].flagged;
                                  model.properties[i].specialInstructions =
                                      model.properties[i].flagged
                                          ? model
                                              .properties[i].specialInstructions
                                          : instructionController.text;
                                });
                                Navigator.pop(context);
                              } catch (e) {
                                Navigator.pop(context);
                              }
                            }),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _addPropertyInstructionsTextField(
      PropertyModel property, TextEditingController instructionController) {
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
            // focusNode: focusInstructions,
            maxLines: 5,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(context),
            ]),
            controller: instructionController,
            style: AppTheme.instance.textStyleSmall(
                fontWeight: FontWeight.w500, color: Color(0xFFAEAEAE)),
            decoration: InputDecoration(
                filled: true,
                contentPadding: EdgeInsets.all(10.0),
                fillColor: Colors.white,
                hintText: 'Take a photo of unit 221',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
          ),
        ],
      ),
    );
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
            contentPadding: EdgeInsets.all(8.w),
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
            hintText: 'Sort by: Property Name'),
      ),
      suggestionsCallback: (pattern) async {
        List<PropertyModel> data = await model.getProperties(pattern);
        model.notifyListeners();
        return data;
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

  Widget _propertyCard(
      {String propertyOrder,
      String propertyName,
      bool flagged,
      String market,
      String unit,
      Timestamp update,
      String propertyId,
      Function propertyFlagFunction,
      PropertiesViewModel model}) {
    DateTime convertedDate;
    String formatedDate;
    if (update != null) {
      convertedDate =
          DateTime.fromMillisecondsSinceEpoch(update.millisecondsSinceEpoch);
      formatedDate = DateFormat('M/d/y').format(convertedDate);
    }
    return Column(
      children: [
        GestureDetector(
          onTap: () => model.navigateToEditProperty(propertyId),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: _propertyTitle(
                          title: 'Property: ',
                          value: propertyName,
                          titleColor: AppTheme.instance.primaryColorBlue),
                    ),
                    // Expanded(
                    //     flex: 4,
                    //     child: GestureDetector(
                    //       onTap: propertyFlagFunction,
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           Text(
                    //             flagged ? 'Clear Flag' : 'Flag This',
                    //             style: TextStyle(
                    //                 color: Colors.red,
                    //                 fontSize: 10.w,
                    //                 decoration: TextDecoration.none),
                    //           ),
                    //           SizedBox(width: 10.w),
                    //           Image.asset(
                    //             flagged
                    //                 ? 'assets/icons/flag_red_full.png'
                    //                 : 'assets/icons/flag_red.png',
                    //             height: 20.w,
                    //           )
                    //         ],
                    //       ),
                    //     ))
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: _propertyTitle(
                          title: 'Market: ',
                          value: market == null ? '' : market),
                    ),
                    Expanded(
                      flex: 4,
                      child: _propertyTitle(title: 'Unit: ', value: unit),
                    ),
                    if (formatedDate != null)
                      Expanded(
                        flex: 8,
                        child: _propertyTitle(
                            title: 'Update: ', value: formatedDate),
                      ),
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
  //   return Expanded(
  //     flex: 1,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         InkWell(
  //           onTap:
  //               model.prevExist ? () => model.paginatedProperties(false) : null,
  //           child: Container(
  //             height: 30.w,
  //             width: 35.w,
  //             decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.only(
  //                     topLeft: Radius.circular(5),
  //                     bottomLeft: Radius.circular(5)),
  //                 border: Border.all(color: _prevButtonColor, width: 2.w)),
  //             child: Center(
  //               child: Icon(
  //                 Icons.chevron_left,
  //                 color: _prevButtonColor,
  //               ),
  //             ),
  //           ),
  //         ),
  //         SizedBox(
  //           width: 10.w,
  //         ),
  //         InkWell(
  //           onTap:
  //               model.nextExist ? () => model.paginatedProperties(true) : null,
  //           child: Container(
  //             height: 30.w,
  //             width: 35.w,
  //             decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.only(
  //                     topRight: Radius.circular(5),
  //                     bottomRight: Radius.circular(5)),
  //                 border: Border.all(color: _nextButtonColor, width: 2.w)),
  //             child: Center(
  //                 child: Icon(
  //               Icons.chevron_right,
  //               color: _nextButtonColor,
  //             )),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  RichText _propertyTitle(
      {String title = '', String value = '', Color titleColor = Colors.black}) {
    return RichText(
        text: TextSpan(
            text: title,
            style: TextStyle(color: titleColor, fontWeight: FontWeight.bold),
            children: [
          TextSpan(
              text: value,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.normal))
        ]));
  }

  Widget _divider() {
    return Divider(
      thickness: 0.8.w,
      height: 0.8.w,
      color: AppTheme.instance.primaryDarker,
    );
  }
}
