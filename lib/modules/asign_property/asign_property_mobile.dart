part of add_property_view;

class _AsignPropertyMobile extends StatefulWidget {
  @override
  __AsignPropertyMobileState createState() => __AsignPropertyMobileState();
}

class __AsignPropertyMobileState extends State<_AsignPropertyMobile> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController unitsController = TextEditingController();
  final TextEditingController marketController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: ViewModelBuilder<AsignPropertyViewModel>.reactive(
            viewModelBuilder: () => AsignPropertyViewModel(),
            onModelReady: (model) {
              model.safeActionRefreshable(() async {
                await model.load(unitsController, marketController);
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
                  child: FormBuilder(
                    key: _fbKey,
                    child: Container(
                        padding: EdgeInsets.only(left: 20.w, right: 20.w),
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              flex: 70,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _title("Property"),
                                  _streets(model, context),
                                  _title("Units"),
                                  _addPropertyTextField(unitsController,
                                      value: model.selectedUnit,
                                      name: 'units',
                                      label: 'Units'),
                                  _title("Market"),
                                  _addPropertyTextField(marketController,
                                      value: model.selectedMarket,
                                      name: 'market',
                                      label: 'Market'),
                                  _title("Assign Porter"),
                                  _porterSelector(model)
                                ],
                              ),
                            ),
                            Expanded(
                                flex: 20,
                                child: BigRoundActionButtonView(() async {
                                  var result = await model
                                      .asignProperty(_fbKey.currentState);

                                  if (result != "success") {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(result)));
                                  } else {
                                    model.navigateBack();
                                  }
                                }, "Save", "assets/icons/save_new.png",
                                    busy: model.busy))
                          ],
                        )),
                  ),
                )));
  }

  Widget _title(String text) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
            padding: EdgeInsets.only(top: 4.w),
            child: Text(
              text,
              textAlign: TextAlign.start,
              style: TextStyle(fontWeight: FontWeight.bold),
            )));
  }

  Widget _porterSelector(AsignPropertyViewModel model) {
    return FormBuilderDropdown(
        name: 'employee',
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(8.w),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: ColorsUtils.getMaterialColor(0x304A4A4A),
                    width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(6))),
            border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: ColorsUtils.getMaterialColor(0x304A4A4A),
                    width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(6))),
            hintText: ""),
        onChanged: (value) => {model.updateEmployee(value)},
        items: model.employees.map((employee) {
          return DropdownMenuItem(
            value: employee.id,
            child: Text('${employee.firstName}, ${employee.lastName}'),
          );
        }).toList());
  }

  Widget _streets(AsignPropertyViewModel model, BuildContext context) {
    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: streetController,
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
          child: Text(model.properties.length <= 0
              ? 'You don\'t have properties assigned'
              : 'this search does not match'),
        ),
      ),
      suggestionsBoxDecoration: SuggestionsBoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(6))),
      itemBuilder: (context, PropertyModel suggestion) {
        return ListTile(
            title: Text(suggestion.address,
                style: AppTheme.instance.textStyleSmall()));
      },
      onSuggestionSelected: (PropertyModel suggestion) {
        streetController.text = suggestion.address;
      },
      suggestionsBoxController: model.propertyBoxController,
    );
  }

  Widget _addPropertyTextField(TextEditingController controller,
      {String name, String value, String label, String hintText}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 13.w),
      child: FormBuilderTextField(
        controller: controller,
        name: name,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(8.w),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: ColorsUtils.getMaterialColor(0x304A4A4A),
                    width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(6))),
            border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: ColorsUtils.getMaterialColor(0x304A4A4A),
                    width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(6))),
            hintText: hintText),
      ),
    );
  }
}
