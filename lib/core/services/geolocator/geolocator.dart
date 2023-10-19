import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:compound/config.dart';
import 'package:compound/core/base/base_service.dart';
import 'package:compound/shared_models/response_google_places.dart';
import 'package:flutter/foundation.dart';
import 'package:gallery_saver/files.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/subjects.dart';
import 'package:http/http.dart' as http;

class GeolocatorService extends BaseService {
  BehaviorSubject<String> errorLocationStream = BehaviorSubject<String>();
  BehaviorSubject<List<Placemark>> locationStream =
      BehaviorSubject<List<Placemark>>();
  final String baseUrlGooglePlaces =
      'https://maps.googleapis.com/maps/api/place/findplacefromtext/json';
  final String type = 'textquery';
  final String fields = 'formatted_address,name,geometry';

  void dispose() {
    if (errorLocationStream != null && !errorLocationStream.isClosed)
      errorLocationStream.close();
    if (locationStream != null && !locationStream.isClosed)
      locationStream.close();
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      errorLocationStream.add('Location disabled');
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        errorLocationStream.add('Location denied');
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      errorLocationStream.add('Location permanently denied');
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<List<Placemark>> getLocation(double latitude, double longitude) async {
    return await placemarkFromCoordinates(latitude, longitude);
  }

  Future<List<Results>> getPlacesWithDirecction(String text) async {
    try {
      String request =
          '$baseUrlGooglePlaces?input=${Uri.encodeComponent(text)}&inputtype=$type&fields=$fields&key=${Config.googlePlacesKey}';
      if (kIsWeb) {
        HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
          functionName: 'getDataFromUrl',
        );
        try {
          final HttpsCallableResult result = await callable.call(
            <String, dynamic>{
              'url': request,
            },
          );
          var res = ResultModel.fromJson(result.data);
          return res.results;
        } on CloudFunctionsException catch (e) {
          print('caught firebase functions exception');
          print(e.code);
          print(e.message);
          print(e.details);
          return null;
        } catch (e) {
          print('caught generic exception');
          print(e);
          return null;
        }
      }
      var response = await http.get(Uri.parse(request), headers: {
        'Accept': 'application/json',
        'Access-Control-Allow-Origin': '*',
      });
      var res = ResultModel.fromJson(json.decode(response.body));
      return res.results;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
