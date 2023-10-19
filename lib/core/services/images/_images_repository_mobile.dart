import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class ImagesRepository {

  Future<dynamic> getImageGallery() async {

    var file = await ImagePicker.pickImage(source: ImageSource.gallery, maxWidth: 1024, maxHeight: 1024, imageQuality: 90);
    if(file == null){
       return {"widget": null, "fileName": null, "file" : null};  
    }
    var imageFile = FileImage(file);
    var image = Image(fit: BoxFit.cover,
                      image: imageFile
                );
    var fileName = basename(file.path);

    return {"widget": image, "fileName": fileName, "file" : file};           
  }

}