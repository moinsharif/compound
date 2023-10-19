part of violation_view;

class _ViolationMobile extends StatefulWidget {
  @override
  __ViolationMobileState createState() => __ViolationMobileState();
}

class __ViolationMobileState extends State<_ViolationMobile> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  final TextEditingController violationController = TextEditingController();

  final FocusNode focusViolation = FocusNode();

  void _onEditImage(ViolationViewModel model) {
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

  _theme(Widget widget) {
    return Theme(
        child: widget,
        data: ThemeData(
            inputDecorationTheme: InputDecorationTheme(
                isDense: false,
                errorMaxLines: 5,
                labelStyle: AppTheme.instance.textStyleSmall(
                    fontWeight: FontWeight.w500, color: Colors.black),
                hintStyle: AppTheme.instance.textStyleSmall(
                    fontWeight: FontWeight.w500, color: Colors.grey),
                fillColor: Color(0XFFF2F2F2),
                contentPadding: EdgeInsets.zero,
                filled: true,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0XFFE9E9E9)),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0XFFE9E9E9)),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0XFFE9E9E9)),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))))));
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ViolationViewModel>.reactive(
        viewModelBuilder: () => ViolationViewModel(),
        onModelReady: (model) {
          model.safeActionRefreshable(() async {
            await model.load();
          });
          focusViolation.addListener(() {
            if (focusViolation.hasFocus) {
              model.changeArrowPositionViolation(true, opneBox: 'open');
            }
          });
          // violationController.addListener(() {
          //   model.updateViolation(violationController.text != null &&
          //           violationController.text != ""
          //       ? violationController.text
          //       : null);
          // });
        },
        builder: (context, model, child) => FormBuilder(
              key: _fbKey,
              child: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                    child: Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: 30.0.w, vertical: 10.0.h),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            _Filter(
                              title: 'Property',
                              selectPropierty: model.showProperty,
                              isEditable: false,
                              onPress: () {},
                            ),
                            Spacer(),
                            _Filter(
                              title: 'Market',
                              selectPropierty: model.showMarket,
                              isEditable: false,
                              onPress: () {},
                            ),
                            Spacer(),
                          ],
                        ),
                        SizedBox(
                          height: 10.0.h,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Unit Number',
                                      style: AppTheme.instance.textStyleSmall(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black)),
                                  SizedBox(
                                    height: 10.0.h,
                                  ),
                                  Container(
                                    // width: 100.0.w,
                                    height: 40.0,
                                    child: Container(
                                      child: FormBuilderTextField(
                                        name: "unit",
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          hintText: 'Type Unit',
                                          hintStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 10.0),
                                          filled: true,
                                          fillColor: Colors.white70,
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12.0)),
                                            borderSide: BorderSide(
                                                color: Color(0xffdbdbdb),
                                                width: 2),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                            borderSide: BorderSide(
                                                color: Color(0xffdbdbdb)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // Container(
                        //   width: double.infinity,
                        //   decoration: BoxDecoration(
                        //     border:
                        //         Border.all(width: 1, color: Color(0xffdbdbdb)),
                        //     borderRadius: BorderRadius.circular(8),
                        //     color: Colors.transparent,
                        //   ),
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal: 16, vertical: 8),
                        //   child: Container(
                        //     child: Text(model.showUnit,
                        //         style: AppTheme.instance.textStyleSmall(
                        //             fontWeight: FontWeight.w500,
                        //             color: Colors.black)),
                        //   ),
                        // ),
                        SizedBox(height: 10.w),
                        Divider(
                          thickness: 1.8,
                        ),
                        SizedBox(height: 10.w),
                        _violations(model, context),
                        if (model.selectedViolation.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: model.selectedViolation
                                    .map((e) => Container(
                                          margin: EdgeInsets.only(bottom: 2.0),
                                          padding: EdgeInsets.all(5.0),
                                          decoration: BoxDecoration(
                                              color: Color(0xffB5B2B2),
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(e,
                                                  style: AppTheme.instance
                                                      .textStyleSmall(
                                                          color: Color(
                                                                  0xff000000)
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
                        if (model.selectedViolation.isNotEmpty)
                          Divider(
                            thickness: 1.8,
                          ),
                        SizedBox(
                          height: 30.0.h,
                        ),
                        _photos(model),
                        SizedBox(
                          height: 30.0.h,
                        ),

                        _theme(
                          FormBuilderTextField(
                            name: "description",
                            style: TextStyle(color: Colors.black),
                            maxLines: 3,
                            decoration: InputDecoration(
                                hintText:
                                    '${Config.oneViolation} Description (Optional)',
                                hintStyle: TextStyle(
                                    color: Colors.black, fontSize: 12.0),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0)),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        SizedBox(
                          height: 30.0.h,
                        ),
                        ButtonsChoose(
                          buttons: [
                            ButtonsChooseModel(
                                icon: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Image.asset(
                                    'assets/icons/camera.png',
                                  ),
                                ),
                                title: Text('Take Photo',
                                    style: AppTheme.instance.textStyleSmall(
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme
                                            .instance.primaryColorBlue)),
                                function: () {
                                  if (model.selectedImages.length < 3) {
                                    _onEditImage(model);
                                  } else {
                                    ScaffoldMessenger.of(
                                            locator<DialogService>()
                                                .scaffoldKey
                                                .currentContext)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          'already exist the maximum number of pictures.'),
                                    ));
                                  }
                                }),
                            ButtonsChooseModel(
                                margin: EdgeInsets.zero,
                                icon: Icon(
                                  FontAwesomeIcons.times,
                                  size: 20.0,
                                  color: Color(0XFF606060),
                                ),
                                title: Text('Cancel',
                                    style: AppTheme.instance.textStyleSmall(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black)),
                                function: () {
                                  model.navigateToManage(
                                      back: Navigator.canPop(context));
                                }),
                            ButtonsChooseModel(
                                icon: model.busy
                                    ? CircularProgressIndicator()
                                    : Icon(Icons.done,
                                        size: 27.0, color: Colors.black),
                                marginText: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 5.0),
                                title: Text('Save',
                                    style: AppTheme.instance.textStyleSmall(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black)),
                                function: () async {
                                  if (!model.busy) {
                                    var state = await model
                                        .createViolation(_fbKey.currentState);
                                    if (state == "success") {
                                      model.navigatoToSuccessData();
                                    } else {
                                      ScaffoldMessenger.of(
                                              locator<DialogService>()
                                                  .scaffoldKey
                                                  .currentContext)
                                          .showSnackBar(SnackBar(
                                        content: Text(state),
                                      ));
                                    }
                                  }
                                }),
                          ],
                        ),
                      ]),
                )),
              ),
            ));
  }

  Container _photos(ViolationViewModel model) {
    return Container(
      height: 45.0,
      child: ListView.builder(
          itemCount: 3,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) => index + 1 <=
                  model.selectedImages.length
              ? Stack(
                  children: [
                    Container(
                      width: 45.w,
                      height: 45.w,
                      margin: EdgeInsets.only(right: 10.0),
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          color: Color(0xffeeefee),
                          image: model.selectedImages[index] != null
                              ? DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(model.selectedImages[index]))
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
                          model.removeImage(model.selectedImages[index]);
                        },
                      ),
                    ),
                  ],
                )
              : Container(
                  width: 45.w,
                  height: 45.w,
                  margin: EdgeInsets.only(right: 10.0),
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      color: Color(0xffeeefee),
                      borderRadius: BorderRadius.circular(10.0)))),
    );
  }

  Widget _violations(ViolationViewModel model, BuildContext context) {
    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: violationController,
        focusNode: focusViolation,
        onSubmitted: (_) {
          model.changeArrowPositionViolation(false);
          violationController.clear();
        },
        enabled: model.selectedViolation.length < 3,
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
              icon: Icon(violationController.text.length > 0
                  ? Icons.close_rounded
                  : !model.openBoxViolation
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_up),
              onPressed: () {
                if (violationController.text.length > 0) {
                  violationController.clear();
                } else if (model.openBoxViolation) {
                  model.changeArrowPositionViolation(false, opneBox: 'close');
                } else {
                  model.changeArrowPositionViolation(true, opneBox: 'open');
                }
              },
              color: Color(0xff004A05),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: ColorsUtils.getMaterialColor(0x304A4A4A),
                    width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(6))),
            hintText: 'SELECT ${Config.oneViolation.toUpperCase()}',
            hintStyle: TextStyle(color: Colors.black)),
      ),
      suggestionsCallback: (pattern) async {
        List<TypeViolationModel> list = await model.getTypeViolations(pattern);
        setState(() {});
        return list;
      },
      suggestionsBoxDecoration: SuggestionsBoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(6))),
      itemBuilder: (context, TypeViolationModel suggestion) {
        return ListTile(
            title: Text(suggestion.name,
                style: AppTheme.instance.textStyleSmall()));
      },
      onSuggestionSelected: (TypeViolationModel suggestion) {
        model.changeArrowPositionViolation(false);
        model.updateViolation(suggestion.name);
        violationController.clear();
      },
      suggestionsBoxController: model.violationBoxController,
    );
  }
}

class _Filter extends StatelessWidget {
  final String title;
  final String selectPropierty;
  final bool isEditable;
  final Function onPress;
  const _Filter(
      {Key key,
      @required this.title,
      @required this.selectPropierty,
      @required this.onPress,
      @required this.isEditable})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                  child: Text(title,
                      style: AppTheme.instance
                          .textStyleSmall(color: Colors.transparent))),
              if (isEditable)
                InkWell(
                  onTap: onPress,
                  child: Container(
                    margin: EdgeInsets.only(left: 10.0),
                    child: FaIcon(
                      FontAwesomeIcons.edit,
                      color: Color(0XFF606060),
                      size: 12.sp,
                    ),
                  ),
                )
            ],
          ),
          Container(
              padding: EdgeInsets.zero,
              child: Row(
                children: [
                  Text(title,
                      style: AppTheme.instance.textStyleSmall(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.instance.primaryDarkColorBlue)),
                  Text(':',
                      style: AppTheme.instance.textStyleSmall(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff545454))),
                ],
              )),
          Container(
              padding: EdgeInsets.zero,
              child: Text(this.selectPropierty,
                  style: AppTheme.instance.textStyleSmall(
                      fontWeight: FontWeight.w500, color: Colors.black)))
        ],
      ),
    );
  }
}
