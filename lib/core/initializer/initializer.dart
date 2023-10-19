export './_initializer_mobile.dart'
    if (dart.library.html) './_initializer_web.dart'
    if (dart.library.io) './_initializer_mobile.dart';