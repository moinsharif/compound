import 'package:compound/shared_components/profile_video/profile_video_model.dart';
import 'package:compound/shared_components/safe_color_filter/safe_color_filter.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:compound/utils/string_utils.dart';

class ProfileVideo extends StatefulWidget {

  final String url;
  final String title;
  final String imagePath;
  ProfileVideo({Key key, this.url, this.imagePath, this.title}) : super(key: key);

  @override
  _ProfileVideoState createState() => _ProfileVideoState();
}

class _ProfileVideoState extends State<ProfileVideo> {

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
  
    onTapVideo(ProfileVideoViewModel model){
       if(!StringUtils.isNullOrEmpty(this.widget.url))
            this._launchUrl(this.widget.url);
       else {
          Scaffold.of(context).showSnackBar(SnackBar(content: Text(model.multimediaMissingMessage)));
       }
    }
    
    Widget _buildStack(BuildContext context, ProfileVideoViewModel model) {
      final int headerPictureWidth = 752; //TODO MAVHA dynamic calculation width/height 
      final int headerPictureHeigth = 364;
      
      final double height = MediaQuery.of(context).size.width / headerPictureWidth * headerPictureHeigth;
      return InkWell(onTap: () => this.onTapVideo(model),
                     child: Stack(fit: StackFit.loose,
                            children: [  
                               Center(child:
                                   SafeColorFilter(colorFilter:ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.darken),
                                                child: FadeInImage(placeholder: AssetImage('assets/images/background_shattered.png'),
                                                    image: AssetImage(widget.imagePath),
                                                    fit: BoxFit.fitWidth,
                                                    alignment: Alignment.center,
                                                    fadeInDuration:  Duration(milliseconds: 200),
                                                    fadeInCurve: Curves.linear
                                                    ))),
                                SizedBox(height: height,
                                        child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children : [
                                              Padding(padding: EdgeInsets.only(right:15),
                                                      child:Icon(Icons.play_circle_outline, 
                                                          color: AppTheme.instance.buttonPrimary,
                                                          size: 100)),
                                               Padding(padding: EdgeInsets.only(right:15),
                                                      child:Text(widget.title,
                                                      textAlign: TextAlign.start,
                                                      style:TextStyle(fontWeight: FontWeight.bold,
                                                                      fontFamily: "Proxima Nova",
                                                                      color: Colors.white,                                       
                                                                      fontSize: 18.0,
                                                                      shadows: <Shadow>[Shadow(
                                                                                          offset: Offset(0.0, 0.0),
                                                                                          blurRadius: 15.0,
                                                                                          color: Color.fromARGB(255, 0, 0, 0),
                                                                                        ),
                                                                                      ]))),

                                        ] 
                            )),   
                      ]
        ));
    }

    @override
    Widget build(BuildContext context){
      return ViewModelBuilder<ProfileVideoViewModel>.reactive(
            viewModelBuilder: () => ProfileVideoViewModel(),
            builder: (context, model, child) => _buildStack(context, model));
    }
}
