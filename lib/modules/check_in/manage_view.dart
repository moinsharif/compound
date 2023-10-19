import 'package:compound/config.dart';
import 'package:compound/locator.dart';
import 'package:compound/modules/check_in/manage_view_model.dart';
import 'package:compound/shared_components/buttons/button_blue.dart';
import 'package:compound/shared_components/buttons/buttons_choise.dart';
import 'package:compound/shared_components/evidence_picture/evidence_picture.dart';
import 'package:compound/shared_components/evidence_picture/services/evidence_picture_service.dart';
import 'package:compound/shared_components/maps/maps_custom.dart';
import 'package:compound/core/services/dialog_service.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:compound/utils/timestamp_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ManageViewModel>.reactive(
        viewModelBuilder: () => ManageViewModel(),
        onModelReady: (model) {
          model.load();
        },
        builder: (context, model, child) => !model.busy
            ? SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(30.w),
                  child: Column(
                    children: [
                      Container(
                        height: 45.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppTheme.instance.primaryColorBlue,
                        ),
                        child: Center(
                          child: Text('Check In',
                              style: AppTheme.instance.textStyleRegularPlus(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                        ),
                      ),
                      MapCustom(
                        showBanner: true,
                        height: 150.0.h,
                        startLatitude: model.position.latitude,
                        startLongitude: model.position.longitude,
                      ),
                      _InfoPropierty(model),
                      if (model.checkInModel.property.specialInstructions !=
                          null)
                        _InfoBanner(model),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Text('Check Out Picture:',
                              style: AppTheme.instance.textStyleSmall(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _Photos(model),
                          if (model.existViolations)
                            ButtonBlue(onpress: () {
                              model.goToViolationsProperty();
                            })
                        ],
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      _BannerWatchlist(model),
                      SizedBox(
                        height: 10.0,
                      ),
                      ButtonsChoose(
                        buttons: [
                          ButtonsChooseModel(
                              margin: EdgeInsets.only(left: 20.0.w),
                              icon: Icon(
                                Icons.exit_to_app,
                                size: 30.0,
                                color: Colors.white,
                              ),
                              title: Text('Check out',
                                  style: AppTheme.instance.textStyleSmall(
                                      fontWeight: FontWeight.w600,
                                      color:
                                          AppTheme.instance.primaryColorBlue)),
                              function: () async {
                                await model.navigateToWatchlist();
                              }),
                          ButtonsChooseModel(
                              icon: Icon(
                                Icons.arrow_back_ios_sharp,
                                size: 23.0,
                                color: Color(0XFF606060),
                              ),
                              title: Text('Back',
                                  style: AppTheme.instance.textStyleSmall(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0XFF606060))),
                              function: () {
                                model.navigateToHome();
                              }),
                          ButtonsChooseModel(
                              icon: Icon(
                                FontAwesomeIcons.plus,
                                size: 21.0,
                                color: Color(0XFF606060),
                              ),
                              title: Text('${Config.oneViolation}',
                                  style: AppTheme.instance.textStyleSmall(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0XFF606060))),
                              function: () async {
                                model.navigateToViolation();
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            : Container());
  }
}

class _Photos extends StatelessWidget {
  final ManageViewModel model;

  const _Photos(
    this.model, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 20.0),
          child: EvidencePicture(
            iconUrl: 'assets/icons/camera.png',
            evidenceUpdateMedia: EvidenceUpdateMedia(
                "checkIns",
                "check_out",
                "imageCheckOut",
                "checkIn_resources",
                " Uploading checkout image "),
            url: model.checkInModel.imageCheckOut,
          ),
        ),
        if (model.checkInModel.imageCheckOut == null)
          Text('check out picture of waste area',
              style: AppTheme.instance.textStyleVerySmall(
                  fontWeight: FontWeight.w600, color: Colors.red))
      ],
    );
  }
}

class _InfoBanner extends StatelessWidget {
  final ManageViewModel model;

  const _InfoBanner(this.model, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0XFFFEF0D5), borderRadius: BorderRadius.circular(10.0)),
      child: Row(
        children: [
          Container(
            width: 40.w,
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                color: Color(0xffA9E070),
                borderRadius: BorderRadius.circular(10.0)),
            child: Image.asset('assets/icons/info.png'),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: Color(0XFFFEF0D5)),
              child: Row(
                children: [
                  SizedBox(width: 5.w),
                  Text(
                    model.checkInModel.property.specialInstructions?.trim() ??
                        '',
                    style: AppTheme.instance.textStyleSmall(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BannerWatchlist extends StatelessWidget {
  final ManageViewModel model;

  const _BannerWatchlist(
    this.model, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
          color: Color(0XFFFEF0D5), borderRadius: BorderRadius.circular(10.0)),
      child: Row(
        children: [
          Container(
            width: 45.w,
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                color: Color(0xffA9E070),
                borderRadius: BorderRadius.circular(10.0)),
            child: Image.asset('assets/icons/info.png'),
          ),
          SizedBox(width: 5.w),
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Please complete ',
                          textAlign: TextAlign.justify,
                          style: AppTheme.instance
                              .textStyleSmall(color: Colors.black)),
                      InkWell(
                        onTap: () async {
                          await model.navigateToWatchlist();
                        },
                        child: Text('watch list',
                            textAlign: TextAlign.justify,
                            style: AppTheme.instance
                                .textStyleSmall(color: Colors.blue)),
                      ),
                    ],
                  ),
                  Text('to check out',
                      textAlign: TextAlign.justify,
                      style: AppTheme.instance
                          .textStyleSmall(color: Colors.black)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _InfoPropierty extends StatelessWidget {
  final ManageViewModel model;

  const _InfoPropierty(
    this.model, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        children: [
          Container(
            width: 150.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Property:',
                    style: AppTheme.instance
                        .textStyleSmall(fontWeight: FontWeight.bold)),
                Text(model.checkInModel.propertyName,
                    style: AppTheme.instance.textStyleSmall()),
                SizedBox(
                  height: 15.0,
                ),
                Text('Time:',
                    style: AppTheme.instance
                        .textStyleSmall(fontWeight: FontWeight.bold)),
                Text(model.hour,
                    style: AppTheme.instance
                        .textStyleSmall()), //TODO remove hardcoded
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date:',
                  style: AppTheme.instance
                      .textStyleSmall(fontWeight: FontWeight.bold)),
              Text(
                  model.loadDate(
                      TimestampUtils.safeLocal(model.checkInModel.dateCheckIn)),
                  style: AppTheme.instance.textStyleSmall()),
              SizedBox(
                height: 10.0,
              ),
              Text('',
                  style: AppTheme.instance
                      .textStyleSmall(fontWeight: FontWeight.bold)),
              Text('', style: AppTheme.instance.textStyleSmall()),
            ],
          ),
        ],
      ),
    );
  }
}
