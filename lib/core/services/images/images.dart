import 'package:compound/core/base/base_service.dart';
import 'package:flutter/material.dart';

import 'images_repository.dart';

class ImageData{
   Widget imageWidget;
   dynamic file;
   String fileName;
  
   ImageData({this.fileName, this.imageWidget, this.file});
}

class ImagesService extends BaseService {
  
  ImagesRepository _repository;

  ImagesService(){
     _repository = ImagesRepository();
  }

  Future<ImageData> getImageGallery() async{
     var imageData = await _repository.getImageGallery();
     return ImageData(fileName: imageData["fileName"] as String, 
                      imageWidget: imageData["widget"] as Widget, 
                      file: imageData["file"]);
  }
}
