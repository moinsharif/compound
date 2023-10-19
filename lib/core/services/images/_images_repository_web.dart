import 'dart:convert';
import 'dart:html' as html;
 
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart' as Path;
import 'package:image_picker_web/image_picker_web.dart';
import 'package:flutter/material.dart';

class ImagesRepository {

  Future<dynamic> getImageGallery() async {
    
      html.File imageFile =
        await ImagePickerWeb.getImage(outputType: ImageType.file);
    
    return {"widget": await this.convertFileToImage(file: imageFile), "fileName": Path.basename(imageFile.name), "file": imageFile};
  }

  Future<Image> convertFileToImage({@required html.File file}) async {
    final Map<String, dynamic> data = {};
    final reader = html.FileReader();
    reader.readAsDataUrl(file);
    await reader.onLoad.first;
    final encoded = reader.result as String;
    final stripped = encoded.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');
    final fileName = file.name;
    final filePath = file.relativePath;
    data.addAll({
      'name': fileName,
      'data': stripped,
      'data_scheme': encoded,
      'path': filePath
    });

    final imageName = data['name'];
    final imageData = base64.decode(data['data']);
    return Image.memory(imageData, semanticLabel: imageName,);
  }
}