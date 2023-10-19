export '_environment_mobile.dart'
    if (dart.library.html) './_environment_web.dart'
    if (dart.library.io) './_environment_mobile.dart';