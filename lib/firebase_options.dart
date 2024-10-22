// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD1HxJhqXr8KFS6zKJdzVi9BeK8D247Dac',
    appId: '1:599238386999:web:f833ca079ed9ff663e26b2',
    messagingSenderId: '599238386999',
    projectId: 'mealapp-4d2e8',
    authDomain: 'mealapp-4d2e8.firebaseapp.com',
    storageBucket: 'mealapp-4d2e8.appspot.com',
    measurementId: 'G-3TC0DMPQTH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAULDmh7vjVwhglozR0f71q3e_HX70aYMM',
    appId: '1:599238386999:android:80f528f60c80726e3e26b2',
    messagingSenderId: '599238386999',
    projectId: 'mealapp-4d2e8',
    storageBucket: 'mealapp-4d2e8.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBbcuLcSOWRptVgZpBaxbU22e6GFCJqbxM',
    appId: '1:599238386999:ios:1cc79e9ba75c996b3e26b2',
    messagingSenderId: '599238386999',
    projectId: 'mealapp-4d2e8',
    storageBucket: 'mealapp-4d2e8.appspot.com',
    iosBundleId: 'com.example.mealapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBbcuLcSOWRptVgZpBaxbU22e6GFCJqbxM',
    appId: '1:599238386999:ios:1cc79e9ba75c996b3e26b2',
    messagingSenderId: '599238386999',
    projectId: 'mealapp-4d2e8',
    storageBucket: 'mealapp-4d2e8.appspot.com',
    iosBundleId: 'com.example.mealapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD1HxJhqXr8KFS6zKJdzVi9BeK8D247Dac',
    appId: '1:599238386999:web:fbc1cdb5647aa3c43e26b2',
    messagingSenderId: '599238386999',
    projectId: 'mealapp-4d2e8',
    authDomain: 'mealapp-4d2e8.firebaseapp.com',
    storageBucket: 'mealapp-4d2e8.appspot.com',
    measurementId: 'G-4Y4DBCZLR7',
  );
}
