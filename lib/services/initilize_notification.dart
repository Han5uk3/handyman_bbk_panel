import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:handyman_bbk_panel/services/app_services.dart';

class InitilizeNotification {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static Future<void> initializeFCM() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await _firebaseMessaging.getToken();

      if (token != null && token.isNotEmpty) {
        await AppServices.updateFCMToken(token);
      } else {
        if (kDebugMode) {
          print('⚠️ FCM token is null or empty');
        }
      }
    } else {
      if (kDebugMode) {
        print('❌ User declined or has not accepted permission');
      }
    }
  }
}
