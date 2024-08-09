import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


Future<void> bookSlot(DateTime parkingTime) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    print("No user logged in");
    return;
  }

  String? fcmToken = await FirebaseMessaging.instance.getToken();
  if (fcmToken == null) {
    print("Failed to get FCM token");
    return;
  }

  // Ensure parkingTime is in UTC
  final parkingTimeUtc = parkingTime.toUtc();
  final notificationTimeUtc = parkingTimeUtc.subtract(const Duration(hours: 2));

  try {
    await FirebaseFirestore.instance.collection('notifications').add({
      'userId': user.uid,
      'fcmToken': fcmToken,
      'parkingTime': Timestamp.fromDate(parkingTimeUtc),
      'notificationTime': Timestamp.fromDate(notificationTimeUtc),
      'sent': false,
    });
    print("Slot booked successfully for ${parkingTimeUtc.toString()}");
  } catch (e) {
    print("Error booking slot: $e");
  }
}

class FCMService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = 
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    await _firebaseMessaging.requestPermission();

    // Initialize local notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    String? token = await _firebaseMessaging.getToken();

    if (token != null) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'fcmToken': token
        }, SetOptions(merge: true));
      }
    }

    // Handle token refresh
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      // Save the new token to Firestore
    });


    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        _flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'parking_channel',
              'Parking Notifications',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
        );
      }
    });

    // Handle notification clicks when app is in background or terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      // Navigate to relevant screen based on the notification
    });

    // Subscribe to the parking_reminders topic
    await _firebaseMessaging.subscribeToTopic('check_and_send_notifications');
  }
}