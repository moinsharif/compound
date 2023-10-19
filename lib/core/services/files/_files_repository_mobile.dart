
import 'dart:io';

import 'package:path/path.dart';

import 'package:file_picker/file_picker.dart';


class FilesRepository {

  Future<dynamic> getFile({bool readBytes = false, List<String> allowedExtensions}) async {
    
    File file = await FilePicker.getFile(type: FileType.any, allowedExtensions: allowedExtensions);
    if(file == null)
      return null;

    var fileName = basename(file.path);
    var fileData = {"fileName": fileName, "file" : file};
    if(readBytes){
        fileData["bytes"] = await file.readAsBytes();
    }

    return fileData;           
  }

}