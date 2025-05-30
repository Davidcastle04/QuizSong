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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBzkAYKItY64JtQt0Khq0yz2puYHNp4m5Q',
    appId: '1:681603376101:android:ce57d0c31a5cae497b850c',
    messagingSenderId: '681603376101',
    projectId: 'quizsong-99c56',
    storageBucket: 'quizsong-99c56.firebasestorage.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAsLhE1fe3Pzg8RAo11tW2GMqYJVOtbKoE',
    appId: '1:681603376101:web:74dbd3a68258b1aa7b850c',
    messagingSenderId: '681603376101',
    projectId: 'quizsong-99c56',
    authDomain: 'quizsong-99c56.firebaseapp.com',
    storageBucket: 'quizsong-99c56.firebasestorage.app',
    measurementId: 'G-Y7L64W5Q0B',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBQr9I5_eo3fXubf9nfW1BlP04cAsa73cE',
    appId: '1:681603376101:ios:a4c41c2a939d243e7b850c',
    messagingSenderId: '681603376101',
    projectId: 'quizsong-99c56',
    storageBucket: 'quizsong-99c56.firebasestorage.app',
    iosBundleId: 'ujaen.ssmultimedia.songquiz',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBQr9I5_eo3fXubf9nfW1BlP04cAsa73cE',
    appId: '1:681603376101:ios:a4c41c2a939d243e7b850c',
    messagingSenderId: '681603376101',
    projectId: 'quizsong-99c56',
    storageBucket: 'quizsong-99c56.firebasestorage.app',
    iosBundleId: 'ujaen.ssmultimedia.songquiz',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAsLhE1fe3Pzg8RAo11tW2GMqYJVOtbKoE',
    appId: '1:681603376101:web:4c5a6de81784fbdd7b850c',
    messagingSenderId: '681603376101',
    projectId: 'quizsong-99c56',
    authDomain: 'quizsong-99c56.firebaseapp.com',
    storageBucket: 'quizsong-99c56.firebasestorage.app',
    measurementId: 'G-CB6247BBEH',
  );

}