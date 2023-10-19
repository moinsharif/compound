import 'package:compound/shared_components/buttons/button_primary.dart';
import 'package:compound/shared_components/inputs/white_input.dart';
import 'package:compound/shared_models/employee_detail_model.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' show SizeExtension;

class EditWageDialog extends StatelessWidget {
  final FocusNode baseRateFocusNode = FocusNode();
  final FocusNode mondayFocusNode = FocusNode();
  final FocusNode tuesdayFocusNode = FocusNode();
  final FocusNode wednesdayFocusNode = FocusNode();
  final FocusNode thursdayFocusNode = FocusNode();
  final FocusNode fridayFocusNode = FocusNode();
  final FocusNode saturdayFocusNode = FocusNode();
  final FocusNode sundayFocusNode = FocusNode();
  final FocusNode totalFocusNode = FocusNode();
  final TextEditingController baseRateController = TextEditingController();
  final TextEditingController mondayController = TextEditingController();
  final TextEditingController tuesdayController = TextEditingController();
  final TextEditingController wednesdayController = TextEditingController();
  final TextEditingController thursdayController = TextEditingController();
  final TextEditingController fridayController = TextEditingController();
  final TextEditingController saturdayController = TextEditingController();
  final TextEditingController sundayController = TextEditingController();
  final TextEditingController totalController = TextEditingController();
  final EmployeeDetailModel employee;
  Map<String, dynamic> auxWage = {};

  EditWageDialog({Key key, this.employee}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    auxWage.addAll(employee.wage);
    baseRateController.text = getWageValue('base');
    mondayController.text = getWageValue('monday');
    tuesdayController.text = getWageValue('tuesday');
    wednesdayController.text = getWageValue('wednesday');
    thursdayController.text = getWageValue('thursday');
    fridayController.text = getWageValue('friday');
    saturdayController.text = getWageValue('saturday');
    sundayController.text = getWageValue('sunday');
    if (auxWage != null && auxWage.isNotEmpty)
      totalController.text =
          '${auxWage.values.reduce((value, element) => value + element)}';
    return Dialog(
      backgroundColor: Color(0xFFF3F3F3),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(12.w),
              child: Row(
                children: [
                  Icon(
                    Icons.monetization_on_outlined,
                    color: AppTheme.instance.primaryColorBlue,
                  ),
                  SizedBox(width: 10.w),
                  Text('Edit payroll',
                      style: AppTheme.instance.textStyleRegular()),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 2, color: Color(0xFFEBEBEB)),
                ),
              ),
              child:
                  _rowInput(baseRateController, baseRateFocusNode, 'Base rate'),
            ),
            Container(
              margin: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 2, color: Color(0xFFEBEBEB)),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Default projected payment',
                    style: AppTheme.instance.textStyleVerySmall(
                      color: AppTheme.instance.primaryFontColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    width: 150.w,
                    child: Text(
                      'Set default amount for each day of the week for porter.',
                      style: AppTheme.instance.textStyleVerySmall(
                        color: AppTheme.instance.primaryFontColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  _rowInput(mondayController, mondayFocusNode, 'MONDAY'),
                  SizedBox(height: 15.h),
                  _rowInput(tuesdayController, tuesdayFocusNode, 'TUESDAY'),
                  SizedBox(height: 15.h),
                  _rowInput(
                      wednesdayController, wednesdayFocusNode, 'WEDNESDAY'),
                  SizedBox(height: 15.h),
                  _rowInput(thursdayController, thursdayFocusNode, 'THURSDAY'),
                  SizedBox(height: 15.h),
                  _rowInput(fridayController, fridayFocusNode, 'FRIDAY'),
                  SizedBox(height: 15.h),
                  _rowInput(saturdayController, saturdayFocusNode, 'SATURDAY'),
                  SizedBox(height: 15.h),
                  _rowInput(sundayController, sundayFocusNode, 'SUNDAY'),
                  SizedBox(height: 15.h),
                  _rowInput(totalController, totalFocusNode, 'TOTAL'),
                  SizedBox(height: 15.h),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 25.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ButtonPrimary(
                    width: 68.w,
                    height: 30.h,
                    fillColor: Color(0xFFA4A4A4),
                    title: 'Delete',
                    textStyle: AppTheme.instance.textStyleVerySmall(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    borderColor: Colors.transparent,
                    bordeRadius: 5.w,
                    onPressed: () => Navigator.pop(context, null),
                  ),
                  Row(
                    children: [
                      ButtonPrimary(
                        width: 70.w,
                        height: 30.h,
                        fillColor: Color(0xFFF3F3F3),
                        title: 'Cancel',
                        textStyle: AppTheme.instance.textStyleVerySmall(
                          color: AppTheme.instance.primaryFontColor,
                          fontWeight: FontWeight.bold,
                        ),
                        borderColor: AppTheme.instance.primaryFontColor,
                        bordeRadius: 5.w,
                        onPressed: () => Navigator.pop(context, false),
                      ),
                      SizedBox(width: 10.w),
                      ButtonPrimary(
                        width: 68.w,
                        height: 30.h,
                        fillColor: AppTheme.instance.primaryColorBlue,
                        title: 'Save',
                        textStyle: AppTheme.instance.textStyleVerySmall(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        borderColor: Colors.transparent,
                        bordeRadius: 5.w,
                        onPressed: () => Navigator.pop(context, auxWage),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getWageValue(String key) {
    if (auxWage != null && auxWage.isNotEmpty && auxWage.containsKey(key))
      return '${auxWage[key]}';
    return '';
  }

  Widget _rowInput(TextEditingController c, FocusNode f, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          text,
          style: AppTheme.instance.textStyleVerySmall(
            color: AppTheme.instance.primaryFontColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 10.w),
        WhiteInput(
          focusNode: f,
          controller: c,
          onChange: (c) {
            auxWage[text.split(' ')[0].toLowerCase()] = double.parse(c);
            totalController.text =
                '${auxWage.values.reduce((value, element) => value + element)}';
          },
        ),
      ],
    );
  }
}
