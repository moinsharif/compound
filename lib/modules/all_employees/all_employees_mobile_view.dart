part of all_employees_view;

class AllEmployeesMobileView extends StatelessWidget {
  final FocusNode focusPorter = FocusNode();

  dispose() {
    focusPorter?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: ViewModelBuilder<AllEmployeesViewModel>.reactive(
          viewModelBuilder: () => AllEmployeesViewModel(),
          onModelReady: (model) {
            model.safeActionRefreshable(() => model.load());
            focusPorter.addListener(() {
              if (focusPorter.hasFocus) {
                model.changeArrowPositionPorter(true, opneBox: 'open');
              }
            });
          },
          builder: (context, model, child) => GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              focusPorter?.unfocus();
            },
            child: BackgroundPattern(
                child: model.error
                    ? model.errorWidget
                    : model.busy
                        ? Center(child: CircularProgressIndicator())
                        : Stack(
                            children: [
                              Column(
                                children: <Widget>[
                                  _porters(model, context),
                                  model.itemsShow.length > 0
                                      ? Expanded(
                                          child: ListView.builder(
                                              itemCount: model.itemsShow.length,
                                              itemBuilder: (context, index) {
                                                return GestureDetector(
                                                    onTap: () async {
                                                      await model
                                                          .navigateTDetail(
                                                              model.itemsShow[
                                                                  index]);
                                                    },
                                                    child:
                                                        AllEmployeesListItemView(
                                                            data:
                                                                model.itemsShow[
                                                                    index]));
                                              }),
                                        )
                                      : Expanded(
                                          child: Center(
                                              child: Text("Nothing to show",
                                                  style: AppTheme.instance
                                                      .textStyleSmall())),
                                        ),
                                  BigRoundActionButtonView(
                                      () => {model.navigateToEmployeeDetail()},
                                      "View Details",
                                      "assets/icons/eye.png"),
                                  Container(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              child: Text(
                                                'Show Active & Inactive Employees',
                                                style: AppTheme.instance
                                                    .textStyleSmall(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black),
                                              ),
                                            ),
                                          ),
                                          Switch(
                                            value: model.activeUser,
                                            onChanged: (active) => {
                                              model
                                                  .handleRadioValueActiveChange(
                                                      active)
                                            },
                                            activeColor: AppTheme
                                                .instance.primaryDarkColorBlue,
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                right: 0.0,
                                bottom: 50.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: FloatingActionButton(
                                    onPressed: () async =>
                                        await model.navigateToAddEmployee(),
                                    backgroundColor:
                                        AppTheme.instance.primaryColorBlue,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            FontAwesomeIcons.userPlus,
                                            color: Colors.white,
                                            size: 15.0,
                                          ),
                                          Text('Add',
                                              style: AppTheme.instance
                                                  .textStyleVerySmall(
                                                      color: Colors.white,
                                                      size: 8.0)),
                                          Text('User',
                                              style: AppTheme.instance
                                                  .textStyleVerySmall(
                                                      color: Colors.white,
                                                      size: 8.0))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )),
          ),
        ));
  }

  Widget _porters(AllEmployeesViewModel model, BuildContext context) {
    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: model.porterController,
        focusNode: focusPorter,
        onSubmitted: (_) {
          model.changeArrowPositionPorter(false);
          model.cleanController();
        },
        style: AppTheme.instance.textStyleSmall(),
        onChanged: (d) {
          model.changeFilter(d);
        },
        decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
            isDense: true,
            isCollapsed: true,
            filled: true,
            suffixIconConstraints: BoxConstraints(
              minWidth: 32,
            ),
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: ColorsUtils.getMaterialColor(0x304A4A4A),
                    width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(6))),
            suffixIcon: InkWell(
              onTap: () {
                if (model.porterController.text.length > 0) {
                  model.changeFilter('');
                  model.cleanController();
                } else if (model.openBoxPorter) {
                  model.changeArrowPositionPorter(false, opneBox: 'close');
                } else {
                  model.changeArrowPositionPorter(true, opneBox: 'open');
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Icon(
                  model.porterController.text.length > 0
                      ? Icons.close_rounded
                      : !model.openBoxPorter
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_up,
                  color: Color(0xff004A05),
                ),
              ),
            ),
            hintStyle: AppTheme.instance.textStyleVerySmall(),
            border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: ColorsUtils.getMaterialColor(0x304A4A4A),
                    width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(6))),
            hintText: 'Select Employee'),
      ),
      suggestionsCallback: (pattern) {
        List<User> data = model.getEmployeesByFilter(pattern);
        return data;
      },
      noItemsFoundBuilder: (context) => Container(
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
                model.itemsShow.length <= 0
                    ? 'You don\'t have employees yet'
                    : 'this search does not match',
                style: AppTheme.instance.textStyleVerySmall())),
      ),
      suggestionsBoxDecoration: SuggestionsBoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(6))),
      itemBuilder: (context, User suggestion) {
        return ListTile(
            title: Text('${suggestion.lastName}, ${suggestion.firstName}',
                style: AppTheme.instance.textStyleVerySmall()));
      },
      onSuggestionSelected: (User suggestion) {
        model.changeArrowPositionPorter(false);
        model.porterController.text =
            '${suggestion.lastName}, ${suggestion.firstName}';
        model.selectFilter = model.porterController.text;
        model.itemsShow = [suggestion];
      },
      suggestionsBoxController: model.porterBoxController,
    );
  }
}
