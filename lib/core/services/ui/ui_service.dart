import 'package:compound/core/base/base_service.dart';
import 'package:rxdart/subjects.dart';

class IconAppBarModel {
  bool showIcon;
  Function function;

  IconAppBarModel(this.showIcon, this.function);
}

class UIService extends BaseService {
  BehaviorSubject<IconAppBarModel> emailHeaderStream =
      BehaviorSubject<IconAppBarModel>();
  BehaviorSubject<IconAppBarModel> filterViolationsHeaderStream =
      BehaviorSubject<IconAppBarModel>();
  BehaviorSubject<Map<String, dynamic>> uploadFilesStream =
      BehaviorSubject<Map<String, dynamic>>();
  void dispose() {
    if (emailHeaderStream != null && !emailHeaderStream.isClosed)
      emailHeaderStream.close();
    if (filterViolationsHeaderStream != null &&
        !filterViolationsHeaderStream.isClosed)
      filterViolationsHeaderStream.close();
    if (uploadFilesStream != null && !uploadFilesStream.isClosed)
      uploadFilesStream.close();
  }

  void show({Function function, BehaviorSubject<IconAppBarModel> stream}) {
    stream.add(new IconAppBarModel(true, function));
  }

  void hidden({BehaviorSubject<IconAppBarModel> stream}) {
    stream.add(new IconAppBarModel(false, null));
  }

  void emitUploadFileEvent(Map<String, dynamic> event) {
    this.uploadFilesStream.add(event);
  }
}
