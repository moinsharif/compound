import 'package:compound/modules/home/home_porter_view_model.dart';
import 'package:compound/shared_components/bottoms_pages/bottoms_page.dart';
import 'package:compound/shared_components/header/header.dart';
import 'package:compound/shared_components/last_checkIn/last_checkIn.dart';
import 'package:compound/shared_components/markets_employee/markets_employee.dart';
import 'package:compound/shared_components/payroll/payroll.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class HomePorter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomePorterViewModel>.reactive(
        viewModelBuilder: () => HomePorterViewModel(),
        onModelReady: (model) {
          model.safeActionRefreshable(() => model.load(context));
        },
        builder: (context, model, child) => SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child: HeaderCustom(),
                  ),
                  Container(
                    child: BottomPage(),
                  ),
                  MarketsEmployee(),
                  LastCheckIn(),
                  Payroll()
                ],
              ),
            ));
  }
}
