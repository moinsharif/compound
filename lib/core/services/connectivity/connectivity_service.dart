export '_connectivity_service_mobile.dart'
    if (dart.library.html) './_connectivity_service_web.dart'
    if (dart.library.io) './_connectivity_service_mobile.dart';