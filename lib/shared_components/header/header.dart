import 'package:compound/shared_components/header/header_view_model.dart';
import 'package:compound/shared_components/location/location.dart';
import 'package:compound/shared_components/locationAddress/location_address.dart';
import 'package:compound/shared_components/profile_picture/profile_picture.dart';
import 'package:compound/shared_components/profile_picture/services/profile_picture_service.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:compound/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:stacked/stacked.dart';

class HeaderCustom extends StatelessWidget {
  final maskFormatter = new MaskTextInputFormatter(mask: '(###) ###-####');
  HeaderCustom({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HeaderViewModel>.reactive(
      viewModelBuilder: () => HeaderViewModel(),
      builder: (context, model, child) => Stack(
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                color: AppTheme.instance.primaryDarkColorBlue,
                height: 66.h,
                child: Row(
                  children: [
                    Container(
                      width: 120.w,
                    ),
                    Expanded(
                        child: Container(
                      margin: EdgeInsets.only(bottom: 10.0),
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 30.0),
                            child: Image.asset(
                              'assets/images/logo_doorstep.png',
                              color: Colors.white,
                              scale: 2.0,
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
              Container(
                child: Container(
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: Offset(0, 3))
                      ],
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(15.0),
                          bottomLeft: Radius.circular(15.0)),
                      color: Colors.white),
                  height: 110.h,
                  width: double.infinity,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 120.w,
                            height: 55.h,
                          ),
                          Expanded(
                              child: Container(
                            margin: EdgeInsets.only(left: 3),
                            alignment: Alignment.bottomLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Have a great day,',
                                  textAlign: TextAlign.start,
                                  style: AppTheme.instance.textStyleSmall(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  model.getUserName(),
                                  textAlign: TextAlign.start,
                                  style: AppTheme.instance.textStyleSmall(
                                    color: Colors.black,
                                  ),
                                )
                              ],
                            ),
                          )),
                        ],
                      ),
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/icons/phone.png',
                                    color: Color(0XFF707070),
                                    width: 15.sp,
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    maskFormatter.maskText(model.getPhone()),
                                    style: AppTheme.instance.textStyleSmall(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.verified_user_outlined,
                                    color: Color(0XFF707070),
                                    size: 15.sp,
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    model.getUsername(),
                                    maxLines: 2,
                                    textAlign: TextAlign.left,
                                    softWrap: true,
                                    style: AppTheme.instance.textStyleSmall(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            color: Color(0XFFDEDEDE),
                            height: 35.h,
                            width: 1,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/icons/locaion-icon.png',
                                    color: Color(0XFF707070),
                                    width: 15.sp,
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Location()
                                ],
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/icons/user-icon.png',
                                    color: Color(0XFF707070),
                                    width: 15.sp,
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    'Member Since ${model.getMemberYear()}',
                                    style: AppTheme.instance.textStyleSmall(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          Positioned(
              left: 15.w,
              top: 15.h,
              child: ProfilePicture(
                profileUpdateMedia: ProfileUpdateMedia(
                    "users", "main_profile", "img", "profiles_resources"),
                url: model.getPhoto(),
              )),
        ],
      ),
    );
  }
}
