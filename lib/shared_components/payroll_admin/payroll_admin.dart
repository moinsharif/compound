import 'package:compound/shared_components/buttons/button_blue.dart';
import 'package:compound/shared_components/payroll/payroll_view_model.dart';
import 'package:compound/shared_components/payroll_admin/payroll_admin_view_model.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';

class PayrollAdmin extends StatelessWidget {
  const PayrollAdmin({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PayrollAdminViewModel>.reactive(
        viewModelBuilder: () => PayrollAdminViewModel(),
        onModelReady: (model) {
          model.load();
        },
        builder: (context, model, child) => Container(
              color: Color(0xfff9f9f9),
              child: Container(
                margin: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    _PayrollText(
                      model: model,
                    ),
                    _DatePiker(model),
                    _Grid(
                      model: model,
                    )
                  ],
                ),
              ),
            ));
  }
}

class _Grid extends StatelessWidget {
  final PayrollAdminViewModel model;
  const _Grid({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.0.sp,
      child: GridView.count(
        childAspectRatio: 2.0.sp,
        physics: NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(4.0),
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        crossAxisCount: 2,
        addAutomaticKeepAlives: true,
        shrinkWrap: true,
        children: <Widget>[
          _Card(
            title: 'Today\'s Check In',
            value: model.dayChackIn,
          ),
          _Card(
            title: 'Last week\'s Check In',
            value: model.lastWeekCheckIn,
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final String title;
  final String value;
  final Function onPress;
  const _Card({
    Key key,
    this.onPress,
    @required this.title,
    @required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.onPress ?? () {},
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          gradient: LinearGradient(
            colors: [
              AppTheme.instance.colorGradientLightFrom,
              AppTheme.instance.colorGradientLightTo
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: FittedBox(
                fit: BoxFit.fill,
                child: Text(this.title,
                    style: AppTheme.instance.textStyleSmall(
                        color: Colors.white, fontWeight: FontWeight.w600)),
              ),
            ),
            FittedBox(
                fit: BoxFit.fill,
                child: Text(this.value,
                    style: AppTheme.instance.textStyleBigTitle(
                        color: Colors.white, fontWeight: FontWeight.w600))),
          ],
        ),
      ),
    );
  }
}

class _DatePiker extends StatelessWidget {
  final PayrollAdminViewModel model;
  _DatePiker(
    this.model, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              children: [
                Text(
                  model.showDate,
                  style: AppTheme.instance.textStyleSmall(color: Colors.black),
                ),
                InkWell(
                    child: Icon(
                      Icons.keyboard_arrow_up_outlined,
                      color: Colors.black,
                    ),
                    onTap: () {
                      model.getDate('up');
                    }),
                InkWell(
                    child: Icon(
                      Icons.keyboard_arrow_down_outlined,
                      color: Colors.black,
                    ),
                    onTap: () {
                      model.getDate('down');
                    })
              ],
            ),
          ),
          Container(
            child: Text(
              model.hour,
              style: AppTheme.instance.textStyleSmall(
                  color: Color(0XFF707070), fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }
}

class _PayrollText extends StatelessWidget {
  final PayrollAdminViewModel model;
  const _PayrollText({
    Key key,
    this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Text(
            'Check In',
            style: AppTheme.instance.textStyleSmall(
                color: AppTheme.instance.primaryDarkColorBlue,
                fontWeight: FontWeight.bold),
          ),
        ),
        ButtonBlue(
          onpress: () async {
            await model.goToTimeSheets();
          },
        )
      ],
    );
  }
}
