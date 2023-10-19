// import 'package:compound/core/models/dialog_models.dart';
// import 'package:compound/core/services/dialog_service.dart';
// import 'package:compound/shared_components/buttons/buttons_choise.dart';
// import 'package:compound/theme/app_theme.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter/material.dart';
// import 'package:compound/locator.dart';

// class DialogManager extends StatefulWidget {
//   final Widget child;
//   DialogManager({Key key, this.child}) : super(key: key);

//   _DialogManagerState createState() => _DialogManagerState();
// }

// class _DialogManagerState extends State<DialogManager> {
//   DialogService _dialogService = locator<DialogService>();
//   final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

//   _theme(Widget widget) {
//     return Theme(
//         child: widget,
//         data: ThemeData(
//             inputDecorationTheme: InputDecorationTheme(
//                 isDense: false,
//                 errorMaxLines: 5,
//                 labelStyle: AppTheme.instance.textStyleSmall(
//                     fontWeight: FontWeight.w500, color: Colors.black),
//                 hintStyle: AppTheme.instance.textStyleSmall(
//                     fontWeight: FontWeight.w500, color: Colors.grey),
//                 fillColor: Color(0XFFF2F2F2),
//                 contentPadding: EdgeInsets.zero,
//                 filled: true,
//                 focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Color(0XFFE9E9E9)),
//                     borderRadius: BorderRadius.all(Radius.circular(10.0))),
//                 enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Color(0XFFE9E9E9)),
//                     borderRadius: BorderRadius.all(Radius.circular(10.0))),
//                 border: OutlineInputBorder(
//                     borderSide: BorderSide(color: Color(0XFFE9E9E9)),
//                     borderRadius: BorderRadius.all(Radius.circular(10.0))))));
//   }

//   @override
//   void initState() {
//     super.initState();
//     _dialogService.registerDialogListener(_showDialog);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return widget.child;
//   }

//   void _showDialog(DialogRequest request) {
//     var isConfirmationDialog = request.cancelTitle != null;
//     showDialog(
//         context: context,
//         builder: (context) => !request.isSendMessage
//             ? AlertDialog(
//                 title: Text(request.title),
//                 content: Text(request.description),
//                 backgroundColor: Colors.transparent,
//                 actions: <Widget>[
//                   if (isConfirmationDialog)
//                     FlatButton(
//                       child: Text(request.cancelTitle),
//                       onPressed: () {
//                         _dialogService
//                             .dialogComplete(DialogResponse(confirmed: false));
//                       },
//                     ),
//                   FlatButton(
//                     child: Text(request.buttonTitle),
//                     onPressed: () {
//                       _dialogService
//                           .dialogComplete(DialogResponse(confirmed: true));
//                     },
//                   ),
//                 ],
//               )
//             : Dialog(
//                 backgroundColor: Colors.transparent,
//                 insetPadding:
//                     EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0.w),
//                 clipBehavior: Clip.antiAliasWithSaveLayer,
//                 elevation: 0,
//                 child: SingleChildScrollView(
//                   child: FormBuilder(
//                     key: _fbKey,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         _theme(
//                           FormBuilderTextField(
//                             name: "subject",
//                             style: TextStyle(color: Colors.black),
//                             decoration: InputDecoration(
//                                 hintText: 'Subject',
//                                 contentPadding:
//                                     EdgeInsets.symmetric(horizontal: 20.0)),
//                             validator: FormBuilderValidators.compose([
//                               FormBuilderValidators.required(context),
//                             ]),
//                             keyboardType: TextInputType.text,
//                           ),
//                         ),
//                         SizedBox(
//                           height: 10.0.h,
//                         ),
//                         _theme(
//                           FormBuilderTextField(
//                             name: "describe",
//                             style: TextStyle(color: Colors.black),
//                             maxLines: 10,
//                             decoration: InputDecoration(
//                                 hintText: 'Describe the issue',
//                                 contentPadding: EdgeInsets.symmetric(
//                                     horizontal: 20.0, vertical: 10.0)),
//                             validator: FormBuilderValidators.compose([
//                               FormBuilderValidators.required(context),
//                             ]),
//                             keyboardType: TextInputType.text,
//                           ),
//                         ),
//                         SizedBox(
//                           height: 30.0.h,
//                         ),
//                         Container(
//                           margin: EdgeInsets.symmetric(horizontal: 20.0),
//                           child: ButtonsChoose(
//                             buttons: [
//                               ButtonsChooseModel(
//                                   margin: EdgeInsets.symmetric(vertical: 10.0),
//                                   icon: Icon(Icons.arrow_back_ios_sharp,
//                                       size: 23.0, color: Colors.white),
//                                   title: Text('Back',
//                                       style: AppTheme.instance.textStyleSmall(
//                                           fontWeight: FontWeight.w600,
//                                           color: Colors.white)),
//                                   function: () {
//                                     Navigator.of(context).pop();
//                                   }),
//                               ButtonsChooseModel(
//                                   icon: Image.asset('assets/icons/send.png'),
//                                   title: Text('Send',
//                                       style: AppTheme.instance.textStyleSmall(
//                                           fontWeight: FontWeight.w600,
//                                           color: Colors.white)),
//                                   function: () {
//                                     // model.navigateToMap();
//                                   }),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ));
//   }
// }
