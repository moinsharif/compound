import 'package:compound/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class DrivingDrireccion extends StatelessWidget {
  final double lat;
  final double lng;

  const DrivingDrireccion({Key key, this.lat, this.lng}) : super(key: key);

  String _getLatLng() {
    if (lat == null || lng == null) {
      return 'Please select a route before check in';
    }
    return 'success';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Get Driving Direction',
            style: AppTheme.instance.textStyleSmall(
                fontWeight: FontWeight.bold,
                color: Color(0xff707070).withOpacity(1))),
        SizedBox(height: 10.w),
        Row(
          children: [
            InkWell(
              onTap: () async {
                if (_getLatLng() == 'success') {
                  var url =
                      'google.navigation:q=${lat.toString()},${lng.toString()}';
                  var fallbackUrl =
                      'https://www.google.com/maps/search/?api=1&query=${lat.toString()},${lng.toString()}';
                  try {
                    bool launched = await launch(url,
                        forceSafariVC: false, forceWebView: false);
                    if (!launched) {
                      await launch(fallbackUrl,
                          forceSafariVC: false, forceWebView: false);
                    }
                  } catch (e) {
                    await launch(fallbackUrl,
                        forceSafariVC: false, forceWebView: false);
                  }
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(_getLatLng())));
                }
              },
              child: Container(
                margin: EdgeInsets.only(right: 15.0.w),
                child: Image.asset(
                  'assets/icons/google-maps.png',
                  width: 50.0,
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                if (_getLatLng() == 'success') {
                  var urlAppleMaps = 'https://maps.apple.com/?q=$lat,$lng';

                  if (await canLaunch(urlAppleMaps)) {
                    await launch(urlAppleMaps);
                  } else {
                    throw 'Could not launch $urlAppleMaps';
                  }
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(_getLatLng())));
                }
              },
              child: Container(
                margin: EdgeInsets.only(right: 15.0.w),
                child: Image.asset(
                  'assets/icons/maps.png',
                  width: 50.0,
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                if (_getLatLng() == 'success') {
                  var url = 'waze://?ll=${lat.toString()},${lng.toString()}';
                  var fallbackUrl =
                      'https://waze.com/ul?ll=${lat.toString()},${lng.toString()}&navigate=yes';
                  try {
                    bool launched = await launch(url,
                        forceSafariVC: false, forceWebView: false);
                    if (!launched) {
                      await launch(fallbackUrl,
                          forceSafariVC: false, forceWebView: false);
                    }
                  } catch (e) {
                    await launch(fallbackUrl,
                        forceSafariVC: false, forceWebView: false);
                  }
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(_getLatLng())));
                }
              },
              child: Container(
                margin: EdgeInsets.only(right: 15.0.w),
                child: Image.asset(
                  'assets/icons/waze.png',
                  width: 50.0,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
