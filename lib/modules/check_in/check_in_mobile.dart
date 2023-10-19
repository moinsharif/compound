part of check_in_view;

class CheckInMobile extends StatefulWidget {
  CheckInMobile({Key key}) : super(key: key);

  @override
  _CheckInMobileState createState() => _CheckInMobileState();
}

class _CheckInMobileState extends State<CheckInMobile> {
  final TextEditingController streetController = TextEditingController();
  final TextEditingController condoController = TextEditingController();
  final TextEditingController unitController = TextEditingController();

  final FocusNode focusStreet = FocusNode();
  final FocusNode focusCondo = FocusNode();
  final FocusNode focusUnit = FocusNode();

  void _onEditImage(CheckInViewModel model) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ImageSourcePicker(
            onImageSelected: (dynamic image) {
              model.selectImage(image);
            },
            croppedImage: true,
            croppedSize: 200,
          );
        });
  }

  @override
  Widget build(BuildContext buildContext) {
    return ViewModelBuilder<CheckInViewModel>.reactive(
        viewModelBuilder: () => CheckInViewModel(),
        onModelReady: (model) {
          model.safeActionRefreshable(() async {
            focusStreet.addListener(() {
              if (focusStreet.hasFocus) {
                model.changeArrowPositionStreet(true);
              }
            });
            await model.load(condoController, unitController);
            streetController.text = model.selectedProperty == null
                ? null
                : model.selectedProperty.toString();
          });
          streetController.addListener(() {
            model.updateProperites(
                streetController.text != null && streetController.text != ""
                    ? streetController.text
                    : null);
          });
        },
        builder: (context, model, child) => BackgroundPattern(
                child: Container(
              margin: EdgeInsets.symmetric(horizontal: 30.0.w),
              child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                    SizedBox(height: 10.w),
                    Center(
                        child: Image.asset(
                      AppTheme.instance.brandLogo,
                      width: 140.w,
                    )),
                    SizedBox(height: 20.0.w),
                    Text('Select a Service Location',
                        style: AppTheme.instance.textStyleSmall(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff000000).withOpacity(1))),
                    SizedBox(height: 10.w),
                    _streets(model, context),
                    SizedBox(height: 10.w),
                    if (model.selectedPropertyModel != null)
                      Column(
                        children: [
                          _address(model, context),
                          SizedBox(height: 10.w),
                          _flag(model),
                          SizedBox(height: 10.w),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Container(
                              height: 200.0,
                              width: double.infinity,
                              child: MapCustom(
                                startLatitude: model.selectedPropertyModel.lat,
                                startLongitude: model.selectedPropertyModel.lng,
                                endLatitude: model.position?.latitude,
                                endLongitude: model.position?.longitude,
                              ),
                            ),
                          ),
                          SizedBox(height: 10.w),
                          DrivingDrireccion(
                            lat: model.position?.latitude,
                            lng: model.position?.longitude,
                          ),
                        ],
                      ),
                    if (model.selectedPropertyModel != null)
                      Column(
                        children: [
                          SizedBox(height: 20.w),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Time',
                                  style: AppTheme.instance.textStyleSmall(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff000000).withOpacity(1))),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5.0),
                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(0.0, 2.0),
                                          blurRadius: 1,
                                          color: Colors.black.withOpacity(0.3))
                                    ]),
                                padding: EdgeInsets.all(5.0),
                                child: Row(
                                  children: [
                                    Text('Start: ',
                                        style: AppTheme.instance.textStyleSmall(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff000000)
                                                .withOpacity(1))),
                                    SizedBox(
                                      width: 2.0,
                                    ),
                                    Text(
                                        model.getHour(model
                                            .selectedPropertyModel
                                            .configProperty
                                            .startTime),
                                        style: AppTheme.instance.textStyleSmall(
                                            color: Color(0xff000000)
                                                .withOpacity(1))),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5.0),
                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(0.0, 2.0),
                                          blurRadius: 1,
                                          color: Colors.black.withOpacity(0.3))
                                    ]),
                                padding: EdgeInsets.all(5.0),
                                child: Row(
                                  children: [
                                    Text('End: ',
                                        style: AppTheme.instance.textStyleSmall(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff000000)
                                                .withOpacity(1))),
                                    SizedBox(
                                      width: 2.0,
                                    ),
                                    Text(
                                        model.getHour(model
                                            .selectedPropertyModel
                                            .configProperty
                                            .endTime),
                                        style: AppTheme.instance.textStyleSmall(
                                            color: Color(0xff000000)
                                                .withOpacity(1))),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          if (model.selectedPropertyModel.specialInstructions !=
                              null)
                            _InfoBanner(model: model),
                          SizedBox(height: 30.w),
                          _photos(model),
                        ],
                      ),
                    ButtonsChoose(
                      buttons: [
                        ButtonsChooseModel(
                            icon: Center(
                              child: Container(
                                height: 50,
                                width: 50,
                                child: model.loadCheckIn
                                    ? LoadingCustom()
                                    : Container(
                                        padding: EdgeInsets.all(10.0),
                                        child: Image.asset(
                                            'assets/icons/done.png'),
                                      ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: AppTheme.instance.primaryColorBlue),
                              ),
                            ),
                            title: Container(
                              margin: EdgeInsets.only(top: 10.0),
                              child: Text('Check In',
                                  style: AppTheme.instance.textStyleSmall(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.instance.primaryColorBlue
                                          .withOpacity(1))),
                            ),
                            function: () async {
                              try {
                                if (!model.loadCheckIn &&
                                    model.selectedPropertyModel != null) {
                                  if (model.selectedImages == null) {
                                    ScaffoldMessenger.of(
                                            locator<DialogService>()
                                                .scaffoldKey
                                                .currentContext)
                                        .showSnackBar(SnackBar(
                                            content: Text(
                                                'Please take a picture of waste area to continue.')));
                                  } else {
                                    model.lockScreen();
                                    if (await model.validateDistance()) {
                                      var state = await model.saveNewCheckIn();
                                      model.unlockScreen();
                                      if (state == "success") {
                                        model.navigateToManageAfterCheckIn();
                                      } else {
                                        ScaffoldMessenger.of(
                                                locator<DialogService>()
                                                    .scaffoldKey
                                                    .currentContext)
                                            .showSnackBar(
                                                SnackBar(content: Text(state)));
                                      }
                                    } else {
                                      model.unlockScreen();
                                      ScaffoldMessenger.of(
                                              locator<DialogService>()
                                                  .scaffoldKey
                                                  .currentContext)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Your location is out of range')));
                                    }
                                  }
                                } else if (model.selectedProperty == null) {
                                  ScaffoldMessenger.of(locator<DialogService>()
                                          .scaffoldKey
                                          .currentContext)
                                      .showSnackBar(SnackBar(
                                          content: Text(
                                              'Please select a route before to continue')));
                                }
                              } catch (e) {
                                model.unlockScreen();
                              }
                            }),
                      ],
                    ),
                    SizedBox(height: 30.w),
                  ])),
            )));
  }

  Row _photos(CheckInViewModel model) {
    return Row(
      children: [
        model.selectedImages != null
            ? Stack(
                children: [
                  Container(
                    width: 45.w,
                    height: 45.w,
                    margin: EdgeInsets.only(right: 10.0),
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: Color(0xffeeefee),
                        image: model.selectedImages != null
                            ? DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(model.selectedImages))
                            : null,
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                  Positioned(
                    top: 0,
                    child: InkWell(
                      child: Icon(
                        Icons.highlight_remove,
                        size: 20.sp,
                      ),
                      onTap: () {
                        model.removeImage(model.selectedImages);
                      },
                    ),
                  ),
                ],
              )
            : InkWell(
                onTap: () {
                  _onEditImage(model);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text('Check In Photo',
                          style: AppTheme.instance.textStyleSmall(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.instance.primaryColorBlue
                                  .withOpacity(1))),
                    ),
                    SizedBox(height: 5.0),
                    Container(
                        width: 45.w,
                        height: 45.w,
                        padding: EdgeInsets.all(5.0),
                        child: Image.asset(
                          'assets/icons/camera.png',
                          color: Colors.black,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10.0))),
                  ],
                ),
              ),
      ],
    );
  }

  Widget _streets(CheckInViewModel model, BuildContext context) {
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
            hintText: 'Select a route'),
      ),
      suggestionsCallback: (pattern) async {
        return await model.getProperties(pattern);
      },
      noItemsFoundBuilder: (context) => Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(model.properties == null || model.properties.length <= 0
              ? 'You don\'t have properties assigned'
              : 'this search does not match'),
        ),
      ),
      suggestionsBoxDecoration: SuggestionsBoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(6))),
      itemBuilder: (context, PropertyModel suggestion) {
        return ListTile(
            title: Text(suggestion.propertyName,
                style: AppTheme.instance.textStyleSmall()));
      },
      onSuggestionSelected: (PropertyModel suggestion) {
        model.changeArrowPositionStreet(false);
        streetController.text = suggestion.propertyName;
      },
      suggestionsBoxController: model.propertyBoxController,
    );
  }

  Widget _address(CheckInViewModel model, BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Color(0xffdbdbdb)),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Container(
        child: Text(model.selectedPropertyModel?.address ?? '',
            style: AppTheme.instance.textStyleSmall(
                fontWeight: FontWeight.w500, color: Colors.black)),
      ),
    );
  }

  Widget _flag(CheckInViewModel model) {
    return model.selectedPropertyModel?.flagged ?? false
        ? Container(
            height: 40.h,
            decoration: BoxDecoration(
                color: Color(0XFFFFD0D1),
                borderRadius: BorderRadius.circular(10.0)),
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  padding: EdgeInsets.all(5.0),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
                  child: Image.asset('assets/icons/info_red.png'),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Text('This Property has been flagged',
                      style: AppTheme.instance
                          .textStyleSmall(color: Colors.black)),
                )
              ],
            ),
          )
        : Container(
            height: 40.h,
          );
  }
}

class _InfoBanner extends StatelessWidget {
  final CheckInViewModel model;

  const _InfoBanner({Key key, this.model}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0XFFFEF0D5), borderRadius: BorderRadius.circular(10.0)),
      child: Row(
        children: [
          Container(
            width: 40.w,
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                color: Color(0xffA9E070),
                borderRadius: BorderRadius.circular(10.0)),
            child: Image.asset(
              'assets/icons/info.png',
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: Color(0XFFFEF0D5)),
              child: Row(
                children: [
                  SizedBox(width: 5.w),
                  Text(
                    model.selectedPropertyModel?.specialInstructions?.trim() ??
                        '',
                    style: AppTheme.instance.textStyleSmall(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
