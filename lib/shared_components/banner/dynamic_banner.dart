
import 'package:compound/utils/view_utils.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';


class DynamicBannerView extends StatefulWidget {

  final ImageViewHelper viewImage;
  DynamicBannerView({Key key, 
                     this.viewImage}) : super(key: key);

  @override
  _DynamicBannerViewState createState() => _DynamicBannerViewState();
}


class _DynamicBannerViewState extends State<DynamicBannerView> {

  Widget _content(BuildContext context){
     return Container();
  }

  @override
  Widget build(BuildContext context) {


    var height = this.widget.viewImage == null? 250.0 : this.widget.viewImage.getViewHeight(context);
    return Stack(fit: StackFit.loose,
                  children: [
                            SizedBox(height: height, 
                                        child: Center(child: CircularProgressIndicator())),
                            this.widget.viewImage != null? Center(child: FadeInImage(placeholder: MemoryImage(kTransparentImage),
                                                        height: height,
                                                        image:  this.widget.viewImage.imageProvider,
                                                        fit: BoxFit.fitWidth,
                                                        alignment: Alignment.center,
                                                        fadeInDuration:  Duration(milliseconds: 200),
                                                        fadeInCurve: Curves.linear
                                                        )) : SizedBox(),
                            SizedBox(height: height,
                                      child: _content(context),           
               )]);
  }
}