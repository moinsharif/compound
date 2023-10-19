
import 'package:compound/utils/scale_helper.dart';
import 'package:compound/utils/view_utils.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:compound/utils/string_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class ImageView extends StatefulWidget {

  final String url;
  final String sourceType;
  final String link;
  final ImageViewHelper viewImage;
  final bool clickableLink;
  final bool isLoadingStub;
  final Widget child;

  ImageView({Key key, 
            this.url, 
            this.viewImage, 
            this.link, 
            this.clickableLink = false, 
            this.isLoadingStub = false,
            this.child,
            this.sourceType = ViewUtils.sourceAssets}) : super(key: key);

  @override
  _ImageViewState createState() => _ImageViewState();
}


class _ImageViewState extends State<ImageView> {

    Future stackBuilder;
    double height = 224;

    Future<void> _launchUrl(String url) async {
      if (await canLaunch(url)) {
        await launch(
          url,
          forceSafariVC: false,
          forceWebView: false
        );
      } else {
         Scaffold.of(context).showSnackBar(SnackBar(content: Text("Connection error, check your internet connection and try again")));
      }
    }
    
    onTapMultimedia(){

       if(!this.widget.clickableLink)
          return;

       if(!StringUtils.isNullOrEmpty(this.widget.link))
            this._launchUrl(this.widget.link);
    }

    Future<Widget> _buildStack(BuildContext context) async {
      ImageViewHelper viewImage = widget.viewImage != null? widget.viewImage : await ViewUtils.getImageViewHelper(widget.url, sourceType: this.widget.sourceType);

      this.height = viewImage.getViewHeight(context);
      var stack = Stack(fit: StackFit.loose,
                        children: [  Center(child: FadeInImage(placeholder: AssetImage('assets/images/banner_2.png'),
                                                              image: viewImage.imageProvider,
                                                              fit: BoxFit.fitWidth,
                                                              alignment: Alignment.center,
                                                              fadeInDuration:  Duration(milliseconds: 200),
                                                              fadeInCurve: Curves.linear
                                                    )),
                                      SizedBox(height: this.height + 30,
                                               child: this.widget.child != null? this.widget.child : Container(),           
                                )]
      );

      return this.widget.clickableLink && !StringUtils.isNullOrEmpty(this.widget.link)? 
              InkWell(onTap: () => this.onTapMultimedia(),
                     child: stack) 
                     : stack;
  }

  @override
  initState(){
     super.initState();
     this.stackBuilder = _buildStack(context);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.isLoadingStub? CircularProgressIndicator() :
            FutureBuilder<Widget>(future: this.stackBuilder,
                                  builder: (BuildContext buildContext, AsyncSnapshot<Widget> snapshot) {
                                    if (snapshot.hasData) {
                                      return snapshot.data;
                                    } else {
                                      return SizedBox(height: this.height,
                                                      child: Center(child: CircularProgressIndicator()));
                                    }
                                  }));
  }  
}