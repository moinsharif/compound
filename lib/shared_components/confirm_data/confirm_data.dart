import 'package:compound/shared_components/background/background_pattern.dart';
import 'package:compound/shared_components/buttons/buttons_choise.dart';
import 'package:compound/shared_components/confirm_data/confirm_data_view_model.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ConfirmDataView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ConfirmDataViewModel>.reactive(
        viewModelBuilder: () => ConfirmDataViewModel(),
        onModelReady: (model) {
          model.load(ModalRoute.of(context).settings.arguments);
        },
        builder: (context, model, child) => BackgroundPattern(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Image.asset(
                        'assets/icons/check_green.png',
                        width: 150.0,
                      ),
                    ),
                    Text('Success',
                        style: AppTheme.instance.textStyleBigTitle(
                            fontWeight: FontWeight.w600, color: Colors.black)),
                  ],
                ),

                // Spacer(),
                ButtonsChoose(
                  buttons: [
                    ButtonsChooseModel(
                        icon: Center(
                          child: Container(
                            height: 50,
                            width: 50,
                            child: Container(
                              child: Icon(
                                Icons.arrow_back_ios_rounded,
                                color: Colors.white,
                                size: 30.0,
                              ),
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: AppTheme.instance.primaryColorBlue),
                          ),
                        ),
                        title: Container(
                          margin: EdgeInsets.only(top: 10.0),
                          child: Text('Back',
                              style: AppTheme.instance.textStyleSmall(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.instance.primaryColorBlue)),
                        ),
                        function: () {
                          model.navigateToBack(Navigator.canPop(context));
                        }),
                  ],
                ),
              ],
            )));
  }
}
