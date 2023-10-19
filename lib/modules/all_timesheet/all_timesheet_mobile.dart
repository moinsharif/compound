part of all_timesheet_view;

class TimesheetListItemView extends StatelessWidget {
  final TimesheetModel model;
  final AllTimesheetViewModel modelView;
  const TimesheetListItemView({Key key, this.model, this.modelView})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _card(this.model, this.modelView);
  }

  Container _card(TimesheetModel e, AllTimesheetViewModel model) {
    if (e.id == "empty_shifts") {
      return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(10.0.sp),
          child: Text("No available shifts",
              style: AppTheme.instance.textStyleRegular(color: Colors.grey)));
    }

    return Container(
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            color: e.colorStatus.withOpacity(0.25),
            border: Border(
                bottom: BorderSide(color: Colors.grey[600], width: 0.5))),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                  e.status +
                      (e.checkInByAdmin != null && e.checkInByAdmin
                          ? " by Admin"
                          : ""),
                  style: AppTheme.instance.textStyleVerySmall(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      italic: true)),
              Text(
                  e.isTemporaryPorter
                      ? "Temporary shift"
                      : !e.shiftActive
                          ? " Inactive shift"
                          : "",
                  style: AppTheme.instance.textStyleVerySmall(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      italic: true)),
              Text(e.startTime + " " + e.endTime,
                  style: AppTheme.instance.textStyleVerySmall(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      italic: true))
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                              padding: EdgeInsets.only(right: 7.sp),
                              child: Icon(
                                Icons.people_sharp,
                                color: AppTheme.instance.primaryColorBlue,
                              )),
                          Text(
                            e.employeeName +
                                (e.isTemporaryPorter != null &&
                                        e.isTemporaryPorter
                                    ? " (Temp)"
                                    : ""),
                            style: AppTheme.instance.textStyleSmall(
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                              padding: EdgeInsets.only(right: 7.sp),
                              child: Icon(Icons.house,
                                  color: AppTheme.instance.primaryColorBlue)),
                          Text(
                            e.propertyName,
                            style: AppTheme.instance.textStyleSmall(
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      )
                    ],
                  )),
              Expanded(
                  flex: 3,
                  child: Column(children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _textCheck(
                            'In: ',
                            model.loadHours(
                                TimestampUtils.safeLocal(e.dateCheckIn))),
                        Text(
                          ' ' +
                              model.dateToService(
                                  TimestampUtils.safeLocal(e.dateCheckIn)),
                          style: AppTheme.instance.textStyleVerySmall(
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        _textCheck(
                            'Out: ',
                            model.loadHours(
                                TimestampUtils.safeLocal(e.dateCheckOut)))
                      ],
                    )
                  ]))
            ])
          ],
        ));
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
          description ?? '--',
          style: AppTheme.instance.textStyleSmall(color: Colors.grey[700]),
          maxLines: 2,
        )
      ],
    );
  }
}

class __AllTimesheetMobileState extends StatelessWidget {
  Widget _listView(AllTimesheetViewModel model) {
    return ExpandableListView(
      builder: SliverExpandableChildDelegate<TimesheetModel,
              TimesheetModelWrapper>(
          sectionList: model.timeSheets,
          headerBuilder: (context, sectionIndex, index) => Container(
              height: 30.sp,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green[600], width: 0.5),
                gradient: LinearGradient(
                  colors: [
                    Color(0XFF3a8d1d),
                    Color(0XFF55B235),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Text(
                model.dateToHeader(model.timeSheets[sectionIndex].date.local()),
                style: AppTheme.instance.textStyleSmall(
                    color: Colors.white, fontWeight: FontWeight.w600),
              )),
          itemBuilder: (context, sectionIndex, itemIndex, index) {
            return CreationAwareListItem(
                itemCreated: () {
                  SchedulerBinding.instance.addPostFrameCallback((duration) =>
                      model.handleItemCreated(sectionIndex, itemIndex));
                },
                child: InkWell(
                  onTap: () =>
                      model.goToDescriptionTimesheet(sectionIndex, itemIndex),
                  child: TimesheetListItemView(
                      model: model.timeSheets[sectionIndex].items[itemIndex],
                      modelView: model),
                ));
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AllTimesheetViewModel>.reactive(
        viewModelBuilder: () => AllTimesheetViewModel(),
        onModelReady: (model) {
          model.safeActionRefreshable(() async {
            await model.load();
          }, autoUnlock: false);
        },
        builder: (context, model, child) => model.busy
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : BackgroundPattern(
                child: model.timeSheets.length > 0
                    ? _listView(model)
                    : Center(
                        child: Text("Nothing to show",
                            style: AppTheme.instance.textStyleSmall()))));
  }
}
