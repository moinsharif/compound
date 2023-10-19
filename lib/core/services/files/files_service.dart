import 'package:compound/core/base/base_service.dart';
import 'package:compound/core/services/files/files_repository.dart';


class FileWrapper{
 
   dynamic file;
   String fileName;
   dynamic bytes;
  
   FileWrapper({this.fileName, this.file, this.bytes});
}

class FilesService extends BaseService {
  
  FilesRepository _repository;

  FilesService(){
     _repository = FilesRepository();
  }

  Future<FileWrapper> getFile({readBytes : false, List<String> allowedExtensions}) async{
     var fileData = await _repository.getFile(readBytes : readBytes, allowedExtensions : allowedExtensions);
     if(fileData == null){
       return null;
     }

     return FileWrapper(fileName: fileData["fileName"] as String, 
                        file: fileData["file"],
                        bytes : fileData["bytes"]);
  }
}
