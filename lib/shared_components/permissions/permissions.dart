import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/router.dart';
import 'package:compound/shared_components/buttons/button_blue.dart';
import 'package:compound/shared_components/buttons/button_primary.dart';
import 'package:compound/shared_components/permissions/permissions_view_model.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class PermissionsView extends StatelessWidget {
  const PermissionsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PermissionsViewModel>.reactive(
        viewModelBuilder: () => PermissionsViewModel(),
        onModelReady: (model) {
          model.load();
        },
        builder: (context, model, child) => WillPopScope(
            onWillPop: () => Future.value(false),
            child: Container(
              color: Colors.white,
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
              child: Column(
                children: [
                  Text('Permissions',
                      style: AppTheme.instance.textStyleTitles(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff000000).withOpacity(1))),
                  SizedBox(height: 20.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on,
                          size: 20.0,
                          color: AppTheme.instance.primaryColorBlue),
                      Expanded(
                        child: Text(
                            'Hello Doorstep would like to access your location. We\'ll track your location for the service check-in and check-out.',
                            style: AppTheme.instance.textStyleSmall(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff000000).withOpacity(1))),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on,
                          size: 20.0,
                          color: AppTheme.instance.primaryColorBlue),
                      Expanded(
                        child: Text(
                            'Hello Doorstep collects location data to enable check-in & check-out even when the app is closed or not in use.',
                            style: AppTheme.instance.textStyleSmall(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff000000).withOpacity(1))),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Spacer(),
                  ButtonPrimary(
                      title: 'Get started',
                      onPressed: () async {
                        await model.confirmPermissions();
                      }),
                  Spacer(),
                ],
              ),
            )));
  }
}
