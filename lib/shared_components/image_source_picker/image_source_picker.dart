
import 'package:compound/shared_components/image_source_picker/image_source_picker_view_model.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

typedef ImageSelectedCallback = void Function(dynamic);

class ImageSourcePicker extends StatefulWidget {

   final ImageSelectedCallback onImageSelected;
   final bool croppedImage;
   final int croppedSize;

   ImageSourcePicker({this.onImageSelected, this.croppedImage, this.croppedSize = 200});

  _ImageSourcePickerState createState() => _ImageSourcePickerState();
}

class _ImageSourcePickerState extends State<ImageSourcePicker> {
  
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ImageSourcePickerViewModel>.reactive(
        viewModelBuilder: () => ImageSourcePickerViewModel(onImageSelected: widget.onImageSelected, 
                                                           croppedSize : widget.croppedSize, 
                                                           croppedImage: widget.croppedImage),
        builder: (context, model, child) => Container(
            height: 120,
            child: Container(
              child: _buildBottomNavigationMenu(model),
              decoration: BoxDecoration(
                color: AppTheme.instance.primaryLightest,
              ),
            ),
    ));
  }

  Column _buildBottomNavigationMenu(ImageSourcePickerViewModel model) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.camera),
          title: Text('Camera'),
          onTap: (){  
              Navigator.pop(context);
              model.selectImageCamera();     
          },
        ),
        ListTile(
          leading: Icon(Icons.picture_in_picture),
          title: Text('Gallery'),
          onTap: () {  
              Navigator.pop(context);
              model.selectImageGallery();     
          },
        ),
      ],
    );
  }

}