import 'package:compound/shared_components/upload_progress_bar/upload_progress_bar_view_model.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:stacked/stacked.dart';

class UploadProgressBar extends StatelessWidget {
  UploadProgressBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UploadProgressBarViewModel>.reactive(
        viewModelBuilder: () => UploadProgressBarViewModel(),
        onModelReady: (model) {
          model.load();
        },
        builder: (context, model, child) => model.hidden
            ? Container(height: 0, color: Colors.white)
            : Stack(
                children: <Widget>[
                  Container(
                      height: 12,
                      child: LinearPercentIndicator(
                        padding: EdgeInsets.all(0),
                        animation: true,
                        animationDuration: 1000,
                        lineHeight: 13.0,
                        percent: model.progress,
                        center: model.description != null
                            ? Text(model.description.toUpperCase(),
                                style: TextStyle(fontSize: 8))
                            : Text(""),
                        linearStrokeCap: LinearStrokeCap.butt,
                        progressColor: AppTheme.instance.primaryDarkColorBlue,
                      ))
                ],
              ));
  }
}
