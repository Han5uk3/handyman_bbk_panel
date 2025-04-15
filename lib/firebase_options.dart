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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD0JDIQrFliwj8tbK6J2HWC4a3aK5ALThA',
    appId: '1:931781606491:android:dc252ef24047b48a47537e',
    messagingSenderId: '931781606491',
    projectId: 'handyman-app-f0b59',
    storageBucket: 'handyman-app-f0b59.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCGNHVqMkT0z8P5n0AWsuyUDit_acGS-Uk',
    appId: '1:931781606491:ios:29b3edf341b73cd447537e',
    messagingSenderId: '931781606491',
    projectId: 'handyman-app-f0b59',
    storageBucket: 'handyman-app-f0b59.firebasestorage.app',
    androidClientId: '931781606491-1443gk6n7pbjmi08ibbnjgjgmnm50buu.apps.googleusercontent.com',
    iosClientId: '931781606491-bl5t9c9j2c1ggbm3ola76es2h123p2ln.apps.googleusercontent.com',
    iosBundleId: 'com.handyman.bbk.panel',
  );
}
