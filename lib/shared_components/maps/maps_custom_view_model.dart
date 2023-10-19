import 'dart:async';
import 'dart:collection';

import 'package:compound/core/base/base_view_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapCustomViewModel extends BaseViewModel {
  Completer<GoogleMapController> controller = new Completer();
  Set<Marker> markers = HashSet<Marker>();

  Future<void> load(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) async {
    print('latitude $startLatitude');
    print('longitude $startLongitude');
    if (endLongitude != null)
      markers.add(Marker(
          markerId:
              MarkerId('${endLatitude.toString()}${endLongitude.toString()}'),
          position: LatLng(endLatitude, endLongitude)));
  }
}
