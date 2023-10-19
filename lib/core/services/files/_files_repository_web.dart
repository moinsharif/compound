
import 'package:path/path.dart';
import 'dart:html' as html;
import 'package:file_picker/file_picker.dart';
import 'package:file_picker_web/file_picker_web.dart' as filePickerWeb;

class FilesRepository {

  Future<dynamic> getFile({bool readBytes = false, List<String> allowedExtensions}) async {
    html.File file = await filePickerWeb.FilePicker.getFile(type: FileType.any, allowedExtensions: allowedExtensions);
    if(file == null)
      return null;

    var fileData = {"fileName": file.name, "file" : file};
    if(readBytes){
      final reader = html.FileReader();
      reader.readAsArrayBuffer(file);
      await reader.onLoad.first;
      fileData["bytes"] = reader.result;
    }
    
    return fileData;           
  }

}