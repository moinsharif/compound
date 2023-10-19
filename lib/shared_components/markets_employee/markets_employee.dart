import 'package:compound/shared_components/markets_employee/markets_employee_view_model.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class MarketsEmployee extends StatelessWidget {
  const MarketsEmployee({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MarketsEmployeeViewModel>.reactive(
        viewModelBuilder: () => MarketsEmployeeViewModel(),
        onModelReady: (model) {
          model.load();
        },
        builder: (context, model, child) => Container(
              color: Color(0XFFE2E2E2),
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                children: [
                  Text('Markets',
                      style: AppTheme.instance.textStyleRegular(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.instance.primaryColorBlue)),
                  model.markers.length > 0
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: model.markers
                              .asMap()
                              .entries
                              .map((e) => Row(
                                    children: [
                                      if (e.key != 0)
                                        Container(
                                          height: 10.0,
                                          width: 1,
                                          color: Colors.black,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                        ),
                                      Text('${e.value.name}, ${e.value.state}',
                                          style: AppTheme.instance
                                              .textStyleSmall(
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xff000000)
                                                      .withOpacity(1))),
                                    ],
                                  ))
                              .toList())
                      : Container(
                          width: double.infinity,
                          child: Text('You don\'t have assigned markets yet',
                              textAlign: TextAlign.center,
                              style: AppTheme.instance.textStyleSmall(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff000000).withOpacity(1))),
                        )
                ],
              ),
            ));
  }
}
