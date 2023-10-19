part of calendar_view;

class CalendarMobileState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CalendarViewModel>.reactive(
        viewModelBuilder: () => CalendarViewModel(),
        onModelReady: (model) {
          model.safeActionRefreshable(() async {
            await model.load();
          });
        },
        builder: (context, model, child) => model.busy
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                          offset: Offset(0.0, 2.0),
                          blurRadius: 7,
                          color: Colors.black.withOpacity(0.35))
                    ]),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            if (model.controller.page == 1.0) {
                              model.changePage(0);
                            }
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, top: 15.0, bottom: 15.0),
                                child: Text('Full Schedule',
                                    style: AppTheme.instance.textStyleSmall(
                                        color: model.index == 0
                                            ? AppTheme
                                                .instance.primaryDarkColorBlue
                                            : Colors.black,
                                        fontWeight: FontWeight.w500)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Container(
                                  height: 3.0,
                                  width: 85.0,
                                  decoration: BoxDecoration(
                                      color: model.index == 0
                                          ? AppTheme
                                              .instance.primaryDarkColorBlue
                                          : Colors.transparent),
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (model.controller.page == 0.0) {
                              model.changePage(1);
                            }
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, top: 15.0, bottom: 15.0),
                                child: Text('Unassigned',
                                    style: AppTheme.instance.textStyleSmall(
                                        color: model.index == 1
                                            ? AppTheme
                                                .instance.primaryDarkColorBlue
                                            : Colors.black,
                                        fontWeight: FontWeight.w500)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Container(
                                  height: 3.0,
                                  width: 85.0,
                                  decoration: BoxDecoration(
                                      color: model.index == 1
                                          ? AppTheme
                                              .instance.primaryDarkColorBlue
                                          : Colors.transparent),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: PageView(
                    controller: model.controller,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: [
                      SingleChildScrollView(child: CalendarScheduleState()),
                      CalendarUnassigned()
                    ],
                  ))
                ],
              ));
  }
}
