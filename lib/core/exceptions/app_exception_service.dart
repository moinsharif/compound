import 'dart:async';
import 'package:compound/core/exceptions/app_exception.dart';

class AppExceptionService {

  final StreamController<AppException> errorStream = StreamController<AppException>.broadcast();

  dispose(){
     if(!this.errorStream.isClosed)
        this.errorStream.close();
  }

  emit(AppException appException){
    if(!this.errorStream.isClosed)
      errorStream.sink.add(appException);
  }
}