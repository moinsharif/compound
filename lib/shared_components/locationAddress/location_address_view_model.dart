import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/geolocator/geolocator.dart';
import 'package:compound/locator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationAddressViewModel extends BaseViewModel {
  final GeolocatorService _geolocatorService = locator<GeolocatorService>();
  String data = '...';
  Position position;
  List<Placemark> placemarks;
  Future<void> load() async {
    position = await _geolocatorService.determinePosition();
    placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    data = data != '...'
        ? data
        : '${placemarks[0].street ?? ''}, ${placemarks[0].subAdministrativeArea ?? ''}';
    this.notifyListeners();
  }
}
