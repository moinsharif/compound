import 'package:compound/shared_components/buttons/buttons_choise.dart';
import 'package:compound/shared_components/general_message/general_message_view_model.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class GeneralMessage extends StatelessWidget {
  final bool isWeb;
  GeneralMessage({Key key, this.isWeb = false}) : super(key: key);

  _theme(Widget widget) {
    return Theme(
        child: widget,
        data: ThemeData(
            inputDecorationTheme: InputDecorationTheme(
                isDense: false,
                errorMaxLines: 5,
                labelStyle: AppTheme.instance.textStyleSmall(
                    fontWeight: FontWeight.w500, color: Colors.black),
                hintStyle: AppTheme.instance.textStyleSmall(
                    fontWeight: FontWeight.w500, color: Colors.grey),
                fillColor: Color(0XFFF2F2F2),
                contentPadding: EdgeInsets.zero,
                filled: true,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0XFFE9E9E9)),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0XFFE9E9E9)),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0XFFE9E9E9)),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))))));
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<GeneralMessageViewModel>.reactive(
        viewModelBuilder: () => GeneralMessageViewModel(),
        onModelReady: (model) {
          model.load();
        },
        builder: (context, model, child) => Scaffold(
              backgroundColor: Colors.black.withOpacity(0.5),
              body: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: isWeb ? 100.w : 20.0.w),
                  child: SingleChildScrollView(
                    child: FormBuilder(
                      key: model.fbKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _theme(
                            FormBuilderTextField(
                              name: "subject",
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  hintText: 'Subject',
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 20.0)),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(context),
                              ]),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                          SizedBox(
                            height: 10.0.h,
                          ),
                          _theme(
                            FormBuilderTextField(
                              name: "describe",
                              style: TextStyle(color: Colors.black),
                              maxLines: 10,
                              decoration: InputDecoration(
                                  hintText: 'Describe the issue',
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0)),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(context),
                              ]),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                          SizedBox(
                            height: 30.0.h,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20.0),
                            child: ButtonsChoose(
                              buttons: [
                                ButtonsChooseModel(
                                    margin:
                                        EdgeInsets.symmetric(vertical: 10.0),
                                    icon: Icon(Icons.arrow_back_ios_sharp,
                                        size: 23.0, color: Colors.white),
                                    title: Text('Back',
                                        style: AppTheme.instance.textStyleSmall(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white)),
                                    isWeb: isWeb,
                                    function: () => model.busy
                                        ? null
                                        : Navigator.of(context).pop()),
                                ButtonsChooseModel(
                                    icon: Image.asset('assets/icons/send.png'),
                                    isWeb: isWeb,
                                    title: Text('Send',
                                        style: AppTheme.instance.textStyleSmall(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white)),
                                    function: () => model.busy
                                        ? null
                                        : _addIssueFunction(context, model))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ));
  }

  void _addIssueFunction(
      BuildContext context, GeneralMessageViewModel model) async {
    final resp = await model.addIssue();
    if (resp != null) Navigator.pop(context);
  }
}
