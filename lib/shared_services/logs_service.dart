import 'dart:io';
import 'package:compound/core/services/generic_firestore/generic_firestore.dart';
import 'package:device_info/device_info.dart';

class LogService {
  static const String DatabaseRef = "logs";

  String userName = "";
  String id = "";

  setCurrentUser(String userName, String id){
    
  }

  Future<void> logException(
      String module, String source, Exception e, stacktrace) async {
    try {
      var deviceInfo = "";
      if (Platform.isAndroid) {
        var androidInfo = await DeviceInfoPlugin().androidInfo;
        var release = androidInfo.version.release;
        var sdkInt = androidInfo.version.sdkInt;
        var manufacturer = androidInfo.manufacturer;
        var model = androidInfo.model;
        deviceInfo = 'Android $release (SDK $sdkInt), $manufacturer $model';
      } else if (Platform.isIOS) {
        var iosInfo = await DeviceInfoPlugin().iosInfo;
        var systemName = iosInfo.systemName;
        var version = iosInfo.systemVersion;
        var name = iosInfo.name;
        var model = iosInfo.model;
        deviceInfo = '$systemName $version, $name $model';
      }

      await GenericFirestoreService.db
          .collection(DatabaseRef)
          .document(DateTime.now().toUtc().millisecondsSinceEpoch.toString())
          .setData({
        "module": module,
        "type": "exception",
        "device": deviceInfo,
        "date": DateTime.now(),
        "source": source,
        "username": userName,
        "user_id": id,
        "exception": e.toString(),
        "stack": stacktrace.toString()
      }, merge: true);
    } catch (e) {}
  }
}
