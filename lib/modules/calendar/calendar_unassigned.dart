import 'package:compound/modules/calendar/calendar_unassigned_view_model.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CalendarUnassigned extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CalendarUnassignedViewModel>.reactive(
        viewModelBuilder: () => CalendarUnassignedViewModel(),
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
            : model.properties.length > 0
                ? SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: model.properties
                          .map((e) => ListTile(
                                title: Text(e.propertyName,
                                    style: AppTheme.instance.textStyleSmall()),
                                subtitle: Text(e.address,
                                    style:
                                        AppTheme.instance.textStyleVerySmall()),
                              ))
                          .toList(),
                    ),
                  )
                : Center(
                    child: Text("Nothing to show",
                        style: AppTheme.instance.textStyleSmall())));
  }
}
