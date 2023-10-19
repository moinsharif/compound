part of create_account_view;

class _EditAccountWeb extends StatefulWidget {
  @override
  __EditAccountWebState createState() => __EditAccountWebState();
}

class __EditAccountWebState extends State<_EditAccountWeb> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  final TextEditingController searchMarketController = TextEditingController();

  final FocusNode focusSearchMarket = FocusNode();

  final maskFormatter = new MaskTextInputFormatter(
      mask: '(###) ###-####', filter: {"#": RegExp(r'[0-9]')});

  _format(BuildContext context, Widget widget) {
    return Center(
        child: Container(
      width: ScaleHelper.rsDoubleW(context, 30),
      child: Padding(
          padding:
              EdgeInsets.only(top: 15.0, bottom: 0.0, left: 10.0, right: 10.0),
          child: widget),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EditAccountViewModel>.reactive(
      viewModelBuilder: () => EditAccountViewModel(),
      onModelReady: (model) {
        model.safeActionRefreshable(() async {
          await model.load(ModalRoute.of(context).settings.arguments);
        });
      },
      builder: (context, model, child) => Container(
          child: SingleChildScrollView(
        child: FormBuilder(
            key: _fbKey,
            child: Column(children: <Widget>[
              Container(
                width: ScaleHelper.rsDoubleW(context, 60),
                padding: EdgeInsets.all(20.0),
                child: CardWithButtonWeb(
                    busy: model.busy,
                    title: 'Save',
                    width: ScaleHelper.rsDoubleW(context, 40),
                    textStyle: TextStyle(fontSize: 20.0.sp),
                    bordeRadius: 30.0,
                    icon: Icons.arrow_forward_rounded,
                    onPressed: () async {
                      var state =
                          await model.createAccount(_fbKey.currentState);
                      if (state == "success") {
                        ScaffoldMessenger.of(locator<DialogService>()
                                .scaffoldKey
                                .currentContext)
                            .showSnackBar(SnackBar(
                          content: Text('Update client success'),
                        ));
                        model.goToBack();
                      } else {
                        ScaffoldMessenger.of(locator<DialogService>()
                                .scaffoldKey
                                .currentContext)
                            .showSnackBar(SnackBar(
                          content: Text(state),
                        ));
                      }
                    },
                    childCard: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Text(
                                  'Type Employee',
                                  style: AppTheme.instance.textStyleSmall(
                                      color: Color(0xff000000).withOpacity(1.0),
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              if (model.isSuperAdmin && !model.data.isEmployee)
                                Padding(
                                  padding: EdgeInsets.only(top: 5.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Active',
                                          style: AppTheme.instance
                                              .textStyleSmall(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black),
                                        ),
                                      ),
                                      Switch(
                                        value: model.activeUser,
                                        onChanged: (active) => {
                                          model.handleRadioValueActiveChange(
                                              active)
                                        },
                                        activeColor: AppTheme
                                            .instance.primaryDarkColorBlue,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Radio(
                                    value: 0,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: VisualDensity.compact,
                                    groupValue: model.radioValue,
                                    onChanged: model.handleRadioValueChange,
                                    activeColor:
                                        AppTheme.instance.primaryDarkColorBlue,
                                  ),
                                  Text(
                                    'Porter',
                                    style: AppTheme.instance.textStyleRegular(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              if (model.isSuperAdmin)
                                Row(
                                  children: [
                                    Radio(
                                      value: 1,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      visualDensity: VisualDensity.compact,
                                      groupValue: model.radioValue,
                                      onChanged: model.handleRadioValueChange,
                                      activeColor: AppTheme
                                          .instance.primaryDarkColorBlue,
                                    ),
                                    Text(
                                      'Admin',
                                      style: AppTheme.instance.textStyleRegular(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        _format(
                            context,
                            FormBuilderTextField(
                              name: "name",
                              style: TextStyle(color: Colors.black),
                              initialValue: model.data.userName,
                              decoration: InputDecoration(
                                  hintText: "User Name",
                                  suffixIconConstraints: BoxConstraints(
                                      minHeight: 5.0, minWidth: 20.sp),
                                  suffixIcon: Image.asset(
                                    'assets/icons/user-icon.png',
                                    color: Colors.black,
                                    width: 17.sp,
                                  )),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(context),
                                FormBuilderValidators.max(context, 70),
                              ]),
                              keyboardType: TextInputType.text,
                            )),
                        _format(
                            context,
                            FormBuilderTextField(
                              name: "firstname",
                              controller: model.firstNameController,
                              onChanged: (_) {
                                if (!mounted) return;
                                model.notifyListeners();
                              },
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  labelText: "First Name",
                                  suffixIconConstraints: BoxConstraints(
                                      minHeight: 5.0, minWidth: 20.sp),
                                  suffixIcon:
                                      model.firstNameController.text.length > 0
                                          ? IconButton(
                                              icon: Icon(Icons.close_rounded),
                                              onPressed: () {
                                                model.firstNameController
                                                    .clear();
                                                setState(() {});
                                              },
                                              color: Color(0xff004A05),
                                            )
                                          : Image.asset(
                                              'assets/icons/user-icon.png',
                                              color: Colors.black,
                                              width: 17.sp,
                                            )),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(context),
                                FormBuilderValidators.max(context, 70),
                              ]),
                              keyboardType: TextInputType.text,
                            )),
                        _format(
                            context,
                            FormBuilderTextField(
                              name: "lastname",
                              controller: model.lastNameController,
                              onChanged: (_) {
                                if (!mounted) return;
                                model.notifyListeners();
                              },
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  labelText: "Last Name",
                                  suffixIconConstraints: BoxConstraints(
                                      minHeight: 5.0, minWidth: 20.sp),
                                  suffixIcon:
                                      model.lastNameController.text.length > 0
                                          ? IconButton(
                                              icon: Icon(Icons.close_rounded),
                                              onPressed: () {
                                                model.lastNameController
                                                    .clear();
                                                setState(() {});
                                              },
                                              color: Color(0xff004A05),
                                            )
                                          : Image.asset(
                                              'assets/icons/user-icon.png',
                                              color: Colors.black,
                                              width: 17.sp,
                                            )),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(context),
                                FormBuilderValidators.max(context, 70),
                              ]),
                              keyboardType: TextInputType.text,
                            )),
                        _format(
                            context,
                            FormBuilderTextField(
                              name: "phoneNumber",
                              controller: model.phoneController,
                              onChanged: (_) {
                                if (!mounted) return;
                                model.notifyListeners();
                              },
                              inputFormatters: [maskFormatter],
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  labelText: "Phone Number",
                                  suffixIconConstraints: BoxConstraints(
                                      minHeight: 5.0, minWidth: 20.sp),
                                  suffixIcon:
                                      model.phoneController.text.length > 0
                                          ? IconButton(
                                              icon: Icon(Icons.close_rounded),
                                              onPressed: () {
                                                model.phoneController.clear();
                                                setState(() {});
                                              },
                                              color: Color(0xff004A05),
                                            )
                                          : Image.asset(
                                              'assets/icons/phone.png',
                                              color: Colors.black,
                                              width: 17.sp,
                                            )),
                              validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required(context)]),
                              keyboardType: TextInputType.phone,
                            )),
                        _format(
                            context,
                            FormBuilderTextField(
                              name: "password",
                              controller: model.passwordController,
                              onChanged: (_) {
                                if (!mounted) return;
                                model.notifyListeners();
                              },
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  labelText: "New Password",
                                  suffixIconConstraints: BoxConstraints(
                                      minHeight: 5.0, minWidth: 20.sp),
                                  suffixIcon:
                                      model.passwordController.text.length > 0
                                          ? IconButton(
                                              icon: Icon(Icons.close_rounded),
                                              onPressed: () {
                                                model.passwordController
                                                    .clear();
                                                setState(() {});
                                              },
                                              color: Color(0xff004A05),
                                            )
                                          : Icon(
                                              Icons.vpn_key_outlined,
                                              color: Colors.black,
                                              size: 17.sp,
                                            )),
                              keyboardType: TextInputType.text,
                            ))
                      ],
                    )),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                child: ButtonsChooseWeb(
                  buttons: [
                    ButtonsChooseWebModel(
                        margin: EdgeInsets.symmetric(vertical: 10.0),
                        icon: Icon(Icons.arrow_back_ios_sharp,
                            size: 23.0, color: Colors.white),
                        title: Text('Back',
                            style: AppTheme.instance.textStyleSmall(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.instance.primaryColorBlue)),
                        function: () => model.goToBack()),
                  ],
                ),
              ),
              SizedBox(
                height: 40.0,
              )
            ])),
      )),
    );
  }
}
