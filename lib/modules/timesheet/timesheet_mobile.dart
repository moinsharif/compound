part of timesheet_view;

class TimesheetMobileState extends StatelessWidget {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TimesheetViewModel>.reactive(
        viewModelBuilder: () => TimesheetViewModel(),
        onModelReady: (model) {
          model.safeActionRefreshable(() async {
            await model.load(ModalRoute.of(context).settings.arguments);
          });
        },
        builder: (context, model, child) => model.busy
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : BackgroundPattern(
                child: SingleChildScrollView(
                    child: GestureDetector(
                onTap: () {
                  model.focusInstructions.unfocus();
                },
                child: FormBuilder(
                  key: _fbKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoTimesheet(model),
                      Container(
                        margin: EdgeInsets.all(20.0.sp),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (model.checkInModel.image != null)
                              Container(
                                height: 150.0,
                                width: 150.0,
                                margin: EdgeInsets.symmetric(vertical: 10.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            model.checkInModel.image))),
                              ),
                            _textCheck(
                                'Property: ', model.timeSheets.propertyName),
                            SizedBox(
                              height: 10.0,
                            ),
                            _textCheck(
                                'Market: ', model.checkInModel.marketName),
                            SizedBox(
                              height: 10.0,
                            ),
                            _textCheck('Location: ',
                                model.checkInModel?.property?.address ?? ''),
                          ],
                        ),
                      ),
                      if (model.timeSheets.dateCheckOut == null ||
                          model.timeSheets.checkInByAdmin == true)
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.0.sp),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20.0,
                              ),
                              if (model.timeSheets.dateCheckOut == null)
                                Text(
                                  'Manual Check In',
                                  style: AppTheme.instance.textStyleSmall(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                              _addPropertyInstructionsTextField(model, context),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.0.sp),
                          child: _buttons(model)),
                    ],
                  ),
                ),
              ))));
  }

  Row _buttons(TimesheetViewModel model) {
    return Row(
        mainAxisAlignment: model.timeSheets.dateCheckOut == null
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.center,
        crossAxisAlignment: model.timeSheets.dateCheckOut == null
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.center,
        children: [
          Container(
            child: Column(
              children: [
                InkWell(
                  onTap: model.loadCheckOut
                      ? null
                      : () {
                          model.goToBack();
                        },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border:
                            Border.all(color: Color(0XFF606060), width: 1.5),
                        borderRadius: BorderRadius.circular(50.0)),
                    height: kIsWeb ? 30 : 30.w,
                    width: kIsWeb ? 30 : 30.w,
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
          if (model.timeSheets.dateCheckOut == null) Spacer(),
          if (model.timeSheets.dateCheckOut == null)
            Column(
              children: [
                InkWell(
                  onTap: () async {
                    if (!model.loadCheckOut) {
                      if (await model.setCheckIn(_fbKey.currentState)) {
                        ScaffoldMessenger.of(locator<DialogService>()
                                .scaffoldKey
                                .currentContext)
                            .showSnackBar(SnackBar(
                          content: Text('CheckIn manual successs'),
                        ));
                        model.goToBack(reload: true);
                      }
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border:
                            Border.all(color: Color(0XFF606060), width: 1.5),
                        borderRadius: BorderRadius.circular(50.0)),
                    height: kIsWeb ? 30 : 30.w,
                    width: kIsWeb ? 30 : 30.w,
                    child: model.loadCheckOut
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
                          fontWeight: FontWeight.w600,
                          color: Color(0XFF606060))),
                )
              ],
            )
        ]);
  }

  Widget _addPropertyInstructionsTextField(
      TimesheetViewModel model, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (model.timeSheets.dateCheckOut == null)
            Text(
              'Add Comments:',
              style: AppTheme.instance.textStyleSmall(
                  fontWeight: FontWeight.w500, color: Colors.black),
            ),
          SizedBox(
            height: 10.h,
          ),
          FormBuilderTextField(
            name: 'comments',
            focusNode: model.focusInstructions,
            controller: model.controller,
            enabled: model.timeSheets.dateCheckOut == null,
            maxLines: 5,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(context),
            ]),
            style: AppTheme.instance.textStyleSmall(
                fontWeight: FontWeight.w500, color: Color(0xFFAEAEAE)),
            decoration: InputDecoration(
                filled: true,
                contentPadding: EdgeInsets.all(10.0),
                fillColor: Colors.white,
                hintText: 'Comments',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
          ),
        ],
      ),
    );
  }

  Container _infoTimesheet(TimesheetViewModel model) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0.h),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[400]))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _textEmploye('Employee: ', model.timeSheets.employeeName),
              SizedBox(
                height: 10.0,
              ),
              _textCheck(
                  'Check In: ',
                  model.loadHours(
                      TimestampUtils.safeLocal(model.timeSheets.dateCheckIn)))
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _textCheck('Status: ', model.timeSheets.status),
              SizedBox(
                height: 10.0,
              ),
              _textCheck(
                  'Check Out: ',
                  model.loadHours(
                      TimestampUtils.safeLocal(model.timeSheets.dateCheckOut)))
            ],
          ),
        ],
      ),
    );
  }

  Row _textCheck(String title, String description) {
    return Row(
      children: [
        Text(
          title,
          style: AppTheme.instance
              .textStyleSmall(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        Text(
          description.length >= 40
              ? description.substring(1, 40)
              : description ?? '--',
          style: AppTheme.instance.textStyleSmall(color: Colors.grey[700]),
          maxLines: 2,
        )
      ],
    );
  }

  Row _textEmploye(String title, String description) {
    return Row(
      children: [
        Text(
          title,
          style: AppTheme.instance.textStyleSmall(
              color: AppTheme.instance.primaryColorBlue,
              fontWeight: FontWeight.w600),
        ),
        Text(
          description ?? '--',
          style: AppTheme.instance.textStyleSmall(color: Colors.grey[700]),
          maxLines: 2,
        )
      ],
    );
  }
}
