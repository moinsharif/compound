import 'package:compound/shared_components/image_source_picker/image_source_picker.dart';
import 'package:compound/shared_components/profile_picture/profile_picture_viewmodel.dart';
import 'package:compound/shared_components/profile_picture/services/profile_picture_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfilePictureWeb extends StatefulWidget {
  final String url;
  final String title;
  final EdgeInsets padding;
  final double width;
  final double height;
  final BoxShape shape;
  final ProfileUpdateMedia profileUpdateMedia;
  final bool editable;
  final ImageSelectedCallback onImageSelected;

  ProfilePictureWeb(
      {this.title = "",
      this.profileUpdateMedia,
      Key key,
      this.url,
      this.padding = const EdgeInsets.only(top: 35.0, bottom: 35),
      this.width,
      this.height,
      this.shape = BoxShape.circle,
      this.editable = true,
      this.onImageSelected})
      : super(key: key);

  @override
  _ProfilePictureWebState createState() => _ProfilePictureWebState();
}

class _ProfilePictureWebState extends State<ProfilePictureWeb> {
  void _onEditImage(ProfilePictureViewModel model) {
    if (!this.widget.editable) {
      return;
    }

    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ImageSourcePicker(
            onImageSelected: (dynamic image) {
              model.selectImage(image);
            },
            croppedImage: true,
            croppedSize: 200,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfilePictureViewModel>.reactive(
        viewModelBuilder: () => ProfilePictureViewModel(
            this.widget.profileUpdateMedia, this.widget.onImageSelected),
        onModelReady: (model) => model.load(this.widget.url),
        builder: (context, model, child) => Container(
              height: 23.w,
              width: 23.w,
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.circular(50),
                        color: Color(0XFFF2F2F2)),
                    child: Container(
                      margin: EdgeInsets.all(7.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadiusDirectional.circular(50),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: model.provider != null
                                  ? model.provider
                                  : AssetImage(
                                      'assets/icons/calvin-icon.png'))),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadiusDirectional.circular(50),
                          color: Colors.blue),
                      child: InkWell(
                        onTap: () {
                          _onEditImage(model);
                        },
                        child: Container(
                          padding: EdgeInsets.all(4.0),
                          child: Image.asset(
                            'assets/icons/camera.png',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ));
  }
}
