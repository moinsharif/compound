import 'package:compound/shared_components/buttons/button_blue.dart';
import 'package:compound/shared_components/last_checkIn/last_checkIn_view_model.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class LastCheckIn extends StatelessWidget {
  const LastCheckIn({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LastCheckInViewModel>.reactive(
        viewModelBuilder: () => LastCheckInViewModel(),
        onModelReady: (model) {
          model.load();
        },
        builder: (context, model, child) => Container(
              color: Colors.white,
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Last Check In: ${model.hour}',
                      style: AppTheme.instance.textStyleSmall(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff000000).withOpacity(1))),
                  model.activeCheckIn
                      ? Container(
                          child: ButtonBlue(onpress: () {
                            model.goToCheckIn();
                          }),
                        )
                      : Text(model.lastLocation,
                          style: AppTheme.instance.textStyleSmall(
                              fontWeight: FontWeight.w500,
                              color: Color(0xff000000).withOpacity(1)))
                ],
              ),
            ));
  }
}
