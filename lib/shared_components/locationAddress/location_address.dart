import 'package:compound/shared_components/locationAddress/location_address_view_model.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class LocationAddress extends StatelessWidget {
  LocationAddress({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LocationAddressViewModel>.reactive(
        viewModelBuilder: () => LocationAddressViewModel(),
        onModelReady: (model) {
          model.load();
        },
        builder: (context, model, child) => Container(
              child: Text(
                model.data,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: AppTheme.instance.textStyleSmall(
                    color: Colors.black, fontWeight: FontWeight.w400),
              ),
            ));
  }
}
