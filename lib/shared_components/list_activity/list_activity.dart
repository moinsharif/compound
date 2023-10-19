import 'package:compound/shared_components/list_activity/list_activity_view_model.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';

class ListActivity extends StatelessWidget {
  const ListActivity({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ListActivityViewModel>.reactive(
        viewModelBuilder: () => ListActivityViewModel(),
        onModelReady: (model) {
          model.safeActionRefreshable(() async {
            model.load();
            model.scroll.addListener(() {
              model.scrollPosition();
            });
          });
        },
        builder: (context, model, child) => Stack(
              children: [
                Container(
                  margin: EdgeInsets.all(20.0),
                  child: model.activities.length < 1
                      ? Center(
                          child: Text("Nothing to show",
                              style: AppTheme.instance.textStyleSmall()))
                      : ListView(
                          controller: model.scroll,
                          children: model.activities
                              .map((e) => Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                            color: Color(0xff959595),
                                            borderRadius:
                                                BorderRadius.circular(15.0)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              children: [
                                                Container(
                                                  height: 20.0,
                                                  width: 6.0,
                                                  color: Color.fromRGBO(
                                                      e.colors.r,
                                                      e.colors.g,
                                                      e.colors.b,
                                                      1),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 5.0,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(e.description,
                                                    style: AppTheme.instance
                                                        .textStyleSmall(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                _infoLog(
                                                    title: 'Time: ',
                                                    description:
                                                        model.formatTime(
                                                            e.createdAt.local())),
                                                Row(
                                                  children: [
                                                    _infoLog(
                                                        title: 'Edited by: ',
                                                        description:
                                                            e.editedBy),
                                                    if (e.adminId != null)
                                                      Text(' (Admin)',
                                                          style: AppTheme
                                                              .instance
                                                              .textStyleVerySmall(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal))
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Spacer(),
                                            Column(
                                              children: [
                                                Text(
                                                    model.formatDate(
                                                        e.createdAt.local()),
                                                    style: AppTheme.instance
                                                        .textStyleVerySmall(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal)),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      )
                                    ],
                                  ))
                              .toList(),
                        ),
                ),
                if (model.showArrow)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 60.0,
                      width: MediaQuery.of(context).size.width * 0.3,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      child: Center(
                        child: Icon(
                          Icons.keyboard_arrow_down_sharp,
                          size: 60.0.sp,
                          color: Color(0xff959595),
                        ),
                      ),
                    ),
                  )
              ],
            ));
  }

  Row _infoLog({@required String title, @required String description}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.instance.textStyleSmall(
              color: Colors.white, fontWeight: FontWeight.normal),
        ),
        Text(
          description,
          style: AppTheme.instance.textStyleSmall(
            color: Colors.white,
          ),
          maxLines: 2,
        )
      ],
    );
  }
}
