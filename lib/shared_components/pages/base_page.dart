import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/utils/view_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class BasePage extends StatefulWidget {

  final bool canPop;
  final String title;

  BasePage({Key key, this.canPop = true, this.title = ""}) : super(key: key);
}

abstract class BaseState<Page extends BasePage> extends State<Page> {

  String _title;
  String get title => _title;
  set title(value){ _title = value; WidgetsBinding.instance.addPostFrameCallback((_) => setState(() => {})); }

  ImageViewHelper _imageViewHelper;
  ImageViewHelper get imgViewHelper => _imageViewHelper;
  set imgViewHelper(value){ _imageViewHelper = value; WidgetsBinding.instance.addPostFrameCallback((_) => setState(() => {})); }

  Widget _bannerChild;
  Widget get bannerChild => _bannerChild;
  set bannerChild(value){ _bannerChild = value; WidgetsBinding.instance.addPostFrameCallback((_) => setState(() => {})); }

  double _bannerHeight;
  double get bannerHeight => _bannerHeight != null? _bannerHeight: 120.w;
  set bannerHeight(value){ _bannerHeight = value; WidgetsBinding.instance.addPostFrameCallback((_) => setState(() => {})); }

  double _bannerExpandedHeight;
  double get bannerExpandedHeight => _bannerExpandedHeight != null? _bannerExpandedHeight: 50.0.w;
  set bannerExpandedHeight(value){ _bannerExpandedHeight = value; WidgetsBinding.instance.addPostFrameCallback((_) => setState(() => {})); }
  

  @override
  void initState() {
    super.initState();
    _title = widget.title;
    _bannerChild = Container();
  }
  
  @override
  Widget build(BuildContext context) {
      return WillPopScope(child: scaffold(),                
                          onWillPop: () async {
                            return this.widget.canPop;
                          });
  }

  Widget scaffold(){
      return Scaffold(resizeToAvoidBottomInset: false,
                      appBar: AppBar(title: Text(title),
                                          centerTitle: true,
                                          elevation: 0,
                                          bottom: appBarBottom(),
                                 ),
                                 body: body(context),
                                 bottomNavigationBar: navigator());
  }
 
  Widget body(BuildContext context) => content(context);
  Widget appBarBottom() => null;
  Widget navigator() => null;
  Widget content(BuildContext context);

  Widget getViewModelState(BaseViewModel model){
      return model.errorWidget != null? model.errorWidget : 
             model.busy ? Center(child: CircularProgressIndicator()) : null;
  }
}


