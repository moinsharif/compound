import 'package:compound/shared_components/buttons/buttons_choise.dart';
import 'package:compound/shared_components/general_message/general_message_view_model.dart';
import 'package:compound/shared_components/set_rate_property/set_rate_property_view_model.dart';
import 'package:compound/shared_models/days_selected.dart';
import 'package:compound/shared_models/property_model.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SetRateProperty extends StatefulWidget {
  final PropertyModel property;
  SetRateProperty({Key key, this.property}) : super(key: key);

  @override
  _SetRatePropertyState createState() => _SetRatePropertyState();
}

class _SetRatePropertyState extends State<SetRateProperty> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SetRatePropertyViewModel>.reactive(
        viewModelBuilder: () => SetRatePropertyViewModel(),
        onModelReady: (model) {
          model.load();
        },
        builder: (context, model, child) => Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.black.withOpacity(0.5),
              body: Center(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0.w),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _head(),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          decoration: BoxDecoration(
                              color: AppTheme.instance.colorGreyLight),
                          child: Column(
                            children: this
                                .widget
                                .property
                                .configProperty
                                .daysSelected
                                .map((e) => _dayRate(e))
                                .toList()
                                  ..add(_totalRate(this
                                      .widget
                                      .property
                                      .configProperty
                                      .daysSelected
                                      .where((element) => element.selected)
                                      .fold(0, (i, el) => i + el.rate))),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          decoration: BoxDecoration(
                              color: AppTheme.instance.colorGreyLight),
                          child: Column(
                            children: [
                              Divider(
                                endIndent: 10.0,
                                indent: 10.0,
                                color: Colors.black.withOpacity(0.5),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    _botton(Colors.transparent, Colors.grey,
                                        Colors.grey, 'Cancel', () {
                                      Navigator.pop(context);
                                    }),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    _botton(
                                        AppTheme.instance.primaryDarkColorBlue,
                                        Colors.white,
                                        Colors.transparent,
                                        'Save', () {
                                      Navigator.pop(context);
                                    }),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }

  Container _botton(Color background, Color textColor, Color borderColor,
      String text, Function function) {
    return Container(
      width: 70.0.w,
      height: 30.0,
      decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(color: borderColor)),
      child: InkWell(
        onTap: function,
        child: Center(
          child: Text(
            text,
            style: AppTheme.instance
                .textStyleSmall(fontWeight: FontWeight.w500, color: textColor),
          ),
        ),
      ),
    );
  }

  Row _dayRate(DaysSelected day) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          day.nameDay,
          style: AppTheme.instance
              .textStyleSmall(fontWeight: FontWeight.w500, color: Colors.black),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Container(
            width: 70.0.w,
            height: 25.0,
            decoration: BoxDecoration(
                color: day.selected ? Colors.white : Colors.grey[200],
                borderRadius: BorderRadius.circular(3.0)),
            child: Padding(
              padding: EdgeInsets.all(4.0),
              child: TextFormField(
                initialValue: day.rate.toString(),
                onChanged: (String value) {
                  final val = num.tryParse(value);
                  if (val != null) {
                    setState(() {
                      day.rate = val;
                    });
                  }
                },
                keyboardType: TextInputType.number,
                enabled: day.selected,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    filled: true,
                    fillColor: day.selected ? Colors.white : Colors.grey[200],
                    prefix: Text('\$'),
                    contentPadding: EdgeInsets.only(
                      left: 8,
                      bottom: 10,
                      top: 2,
                    )),
                style: AppTheme.instance.textStyleSmall(
                    fontWeight: FontWeight.w500, color: Colors.black),
              ),
            ),
          ),
        )
      ],
    );
  }

  Row _totalRate(int total) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          'TOTAL',
          style: AppTheme.instance.textStyleSmall(
              fontWeight: FontWeight.bold,
              color: AppTheme.instance.primaryDarkColorBlue),
        ),
        Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Container(
                width: 70.0.w,
                height: 25.0,
                decoration: BoxDecoration(color: Colors.white),
                child: Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Padding(
                    padding: EdgeInsets.only(left: 12, top: 2),
                    child: Text('\$ $total',
                        style: AppTheme.instance.textStyleSmall(
                            fontWeight: FontWeight.w600, color: Colors.black)),
                  ),
                )))
      ],
    );
  }

  Container _head() {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: [
            Icon(
              Icons.attach_money_rounded,
              color: AppTheme.instance.primaryDarkColorBlue,
              size: 20.0,
            ),
            SizedBox(
              width: 5.0,
            ),
            Text(
              'Edit Rate',
              style: AppTheme.instance.textStyleRegular(
                  fontWeight: FontWeight.w600, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
