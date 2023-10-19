import 'package:firebase/firebase.dart' as firebase;

class AppInitializer {
  static void initialize() {
    if (firebase.apps.isEmpty) {
      firebase.initializeApp(
          apiKey: "AIzaSyA8PHbAViPrnCJvDJNPUzJsFKft8HFMX6E",
          authDomain: "trash-app-a3696.firebaseapp.com",
          projectId: "trash-app-a3696",
          storageBucket: "trash-app-a3696.appspot.com",
          messagingSenderId: "176307159135",
          appId: "1:176307159135:web:6749fc14231e01835c9bea",
          measurementId: "G-T25TFT33GN");
    }
  }
}
