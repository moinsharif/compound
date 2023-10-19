import 'package:compound/shared_components/evidence_picture/evidence_picture_viewmodel.dart';
import 'package:compound/shared_components/evidence_picture/services/evidence_picture_service.dart';
import 'package:compound/shared_components/image_source_picker/image_source_picker.dart';
import 'package:compound/shared_components/profile_picture/services/profile_picture_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EvidencePicture extends StatefulWidget {
  final String url;
  final String iconUrl;
  final Widget icon;
  final EvidenceUpdateMedia evidenceUpdateMedia;
  final bool editable;
  final bool changeIcon;
  final ImageSelectedCallback onImageSelected;

  EvidencePicture(
      {this.evidenceUpdateMedia,
      Key key,
      this.url,
      this.icon,
      this.editable = true,
      this.changeIcon = false,
      this.iconUrl,
      this.onImageSelected})
      : super(key: key);

  @override
  _EvidencePictureState createState() => _EvidencePictureState();
}

class _EvidencePictureState extends State<EvidencePicture> {
  void _onEditImage(EvidencePictureViewModel model) {
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
    return ViewModelBuilder<EvidencePictureViewModel>.reactive(
        viewModelBuilder: () => EvidencePictureViewModel(
            this.widget.evidenceUpdateMedia, this.widget.onImageSelected),
        onModelReady: (model) => model.load(this.widget.url),
        builder: (context, model, child) => Row(
              children: [
                Stack(
                  children: [
                    InkWell(
                      onTap: () {
                        if (model.provider == null) {
                          _onEditImage(model);
                        }
                      },
                      child: this.widget.changeIcon
                          ? this.widget.icon
                          : Container(
                              width: 45.w,
                              height: 45.w,
                              margin: EdgeInsets.only(right: 10.0),
                              padding: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                  color: Color(0xffeeefee),
                                  image: model.provider != null
                                      ? DecorationImage(
                                          fit: BoxFit.cover,
                                          image: model.provider)
                                      : null,
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: model.provider == null
                                  ? Image.asset(
                                      widget.iconUrl,
                                      color: Colors.black,
                                    )
                                  : null,
                            ),
                    ),
                    if (model.provider != null && !this.widget.changeIcon)
                      Positioned(
                        top: 0,
                        child: InkWell(
                          child: Icon(
                            Icons.highlight_remove,
                            size: 20.sp,
                          ),
                          onTap: () {
                            model.removeImage();
                          },
                        ),
                      ),
                  ],
                ),
                if (model.provider == null && !this.widget.changeIcon)
                  InkWell(
                    onTap: () {
                      if (model.provider == null) {
                        _onEditImage(model);
                      }
                    },
                    child: Container(
                      width: 45.w,
                      height: 45.w,
                      margin: EdgeInsets.only(right: 10.0),
                      decoration: BoxDecoration(
                          color: Color(0xffeeefee),
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Icon(
                        FontAwesomeIcons.plus,
                        size: 13.0,
                      ),
                    ),
                  ),
              ],
            ));
  }
}
