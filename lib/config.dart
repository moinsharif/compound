import 'package:compound/core/environment/environment.dart';

class Config {
  static bool debugMode = false;

  static final List<dynamic> brands = [
    {
      "name": "HelloDoorstep",
      "brand": "doorstep",
      "Violations": "Observations",
      "oneViolation": "Observation"
    },
  ];
  static final String logoUrl =
      "https://firebasestorage.googleapis.com/v0/b/trash-app-hd.appspot.com/o/violations_resources%2Flogohd.png?alt=media&token=6a47caca-15b5-4d2b-9e05-f1b9be06e7e8";
  static final int activeBrand = 0;
  static final String versionApp = 'v2.0.3';
  static final String terms = 'Terms & Conditions';
  static final String urlTerms =
      'https://docs.google.com/document/d/1aIF9NLeKCseFUV5Qkafrx23ANJNK6Hno/';
  static final String brandName = brands[activeBrand]["name"];
  static final String brand = brands[activeBrand]["brand"];
  static final String violations = brands[activeBrand]["Violations"];
  static final String oneViolation = brands[activeBrand]["oneViolation"];
  static final String firestoreUrl = "gs://rv-parks-dev.appspot.com/";
  static final int requestTimeout = 5;
  static bool get isAdminSite => !Environment.isNativeRuntime;
  static String get googlePlacesKey => Environment.googlePlacesKey;

  static String subscriptionDisclaimer =
      "Subscriptions will be charged to your credit card through your store account. Your subscription will automatically renew unless canceled at least 24 hours before the end of the current period.";
}
