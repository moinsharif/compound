export './_firestore_service_mobile.dart'
    if (dart.library.html) './_firestore_service_web.dart'
    if (dart.library.io) './_firestore_service_mobile.dart';