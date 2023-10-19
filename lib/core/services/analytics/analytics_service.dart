export './_analytics_service_mobile.dart'
    if (dart.library.html) './_analytics_service_web.dart'
    if (dart.library.io) './_analytics_service_mobile.dart';