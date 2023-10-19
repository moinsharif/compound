import 'package:compound/modules/login/login_view_model.dart';
import 'package:compound/shared_components/buttons/button_primary.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResetPasswordView extends StatelessWidget {
  _format(Widget widget) {
    return AppTheme.instance.formFieldFormat(child: widget);
  }

  @override
  Widget build(BuildContext context) {
    var _fbKey = GlobalKey<FormBuilderState>();
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: Text("Reset Password",
                       style: AppTheme.instance.textStyleTitles()),
                       elevation: 0,
                       backgroundColor: Colors.white,
                      /*actions: [ Padding(padding: const EdgeInsetsDirectional.only(start: 25.0, end:25),
                                                 child:Icon(Icons.close_sharp, size: 35, color: AppTheme.instance.primaryDarker,),)],*/
                       centerTitle: true,),
        resizeToAvoidBottomInset: false,
        body: ViewModelBuilder<LoginViewModel>.reactive(
          viewModelBuilder: () => LoginViewModel(),
          builder: (context, model, child) => SingleChildScrollView(
              child: FormBuilder(
                  key: _fbKey,
                  child: Column(children: <Widget>[
                     _format(FormBuilderTextField(
                          name: "email",
                          decoration: InputDecoration(
                            labelText: "Email Address",
                            prefixIcon:  Padding(padding: EdgeInsetsDirectional.only(start: 25.w, end:25.w),
                                                 child:Icon(Icons.email, size: 30.sp, color: AppTheme.instance.primaryDarker,),)
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context),
                            FormBuilderValidators.email(context),
                            FormBuilderValidators.max(context, 70),
                          ]),
                          keyboardType: TextInputType.emailAddress,
                     )),
                    _format(
                      ButtonPrimary(
                          title: "Submit",
                          busy: model.busy,
                          onPressed: () async {
                            if (_fbKey.currentState.validate()) {
                              var result = await model.resetPasswordAction(
                                email: _fbKey.currentState.fields['email'].value.trim(),
                              );
                              if (result == null || result == "failure") { 
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "Connection error, check your internet connection and try again")));
                              } else if(result.toLowerCase().indexOf("invalid") >= 0){
                                 Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "Error sending email, please verify the email address")));
                              } else {
                                _fbKey.currentState.reset();
                                _fbKey = GlobalKey<FormBuilderState>();
                                model.navigateToLogIn(result: result);
                              }
                            }
                          }),
                    )
                  ]))),
        ));
  }
}
