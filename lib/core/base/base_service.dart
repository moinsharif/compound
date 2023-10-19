import 'package:compound/locator.dart';
import 'package:compound/shared_services/logs_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:logger/logger.dart';

import '../logger.dart';

class BaseService {
  Logger log;
  LogService _logService = locator<LogService>();
  String _title;

  BaseService({String title}) {
    this._title = title ?? this.runtimeType.toString();
    this.log = getLogger(
      title ?? this.runtimeType.toString(),
    );
  }

  void handleException(Object e, String method, stacktrace) {
    try {
      if (stacktrace != null) {
        print("Error " + method);
        print(stacktrace);
      }

      if (e is Exception) {
        this._logService.logException(_title, method, e, stacktrace);
        Crashlytics.instance
            .recordError(e, StackTrace.current, context: method);
      } else if (e is TypeError) {
        print(e);
      }
    } catch (e) {}
  }
}
