import 'package:compound/shared_components/buttons/button_blue.dart';
import 'package:compound/shared_components/payroll/payroll_view_model.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class Payroll extends StatelessWidget {
  const Payroll({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PayrollViewModel>.reactive(
        viewModelBuilder: () => PayrollViewModel(),
        onModelReady: (model) {
          model.load();
        },
        builder: (context, model, child) => Container(
              margin: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _PayrollText(model: model),
                ],
              ),
            ));
  }
}

class _PayrollText extends StatelessWidget {
  final PayrollViewModel model;
  _PayrollText({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Text(
            'Payroll Overview',
            style: AppTheme.instance.textStyleSmall(
                color: AppTheme.instance.primaryColorBlue,
                fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          child: ButtonBlue(onpress: () async {
            await model.goToPayrollPorter();
          }),
        )
      ],
    );
  }
}
