import 'package:compound/shared_components/header/header_view_model.dart';
import 'package:compound/shared_components/location/location.dart';
import 'package:compound/shared_components/profile_picture/profile_picture_web.dart';
import 'package:compound/shared_components/profile_picture/services/profile_picture_service.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:compound/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:stacked/stacked.dart';

class HeaderWebCustom extends StatelessWidget {
  final maskFormatter = new MaskTextInputFormatter(mask: '(###) ###-####');
  HeaderWebCustom({Key key}) : super(key: key);

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
                color: Color(0XFFDEDEDE),
                height: 66.h,
                child: Row(
                  children: [
                    Container(
                      width: 50.w,
                    ),
                    Expanded(
                        child: Container(
                      margin: EdgeInsets.only(bottom: 10.0),
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        model.getUserName(),
                        textAlign: TextAlign.start,
                        style: AppTheme.instance.textStyleBigTitle(
                            color: Colors.black, fontWeight: FontWeight.w500),
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
                            width: 50.w,
                            height: 50.h,
                          ),
                          Expanded(
                              child: Container(
                            margin: EdgeInsets.only(left: 3),
                            alignment: Alignment.bottomLeft,
                            child: Row(
                              children: [
                                Text(
                                  model.getULegend(),
                                  textAlign: TextAlign.start,
                                  style: AppTheme.instance.textStyleSmall(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10.0),
                                  child: FaIcon(
                                    FontAwesomeIcons.edit,
                                    color: Color(0XFF606060),
                                    size: 12.sp,
                                  ),
                                )
                              ],
                            ),
                          )),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 199,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 50.w,
                                    ),
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
                                    SizedBox(
                                      width: 50.w,
                                    ),
                                    Icon(
                                      Icons.alternate_email_outlined,
                                      color: Color(0XFF707070),
                                      size: 15.sp,
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Text(
                                      model.getEmail(),
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
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              color: Color(0XFFDEDEDE),
                              height: 35.h,
                              width: 1,
                            ),
                          ),
                          Expanded(
                            flex: 199,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 50.w,
                                    ),
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
                                    SizedBox(
                                      width: 50.w,
                                    ),
                                    Image.asset(
                                      'assets/icons/user-icon.png',
                                      color: Color(0XFF707070),
                                      width: 15.sp,
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Text(
                                      'Member Sinse ${model.getMemberYear()}',
                                      style: AppTheme.instance.textStyleSmall(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
              top: 25.h,
              child: ProfilePictureWeb(
                profileUpdateMedia: ProfileUpdateMedia(
                    "users", "main_profile", "img", "profiles_resources"),
                url: model.getPhoto(),
              )),
        ],
      ),
    );
  }
}
