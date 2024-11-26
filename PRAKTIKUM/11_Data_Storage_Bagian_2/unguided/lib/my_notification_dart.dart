import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MyNotificationScreen extends StatefulWidget {
  const MyNotificationScreen({super.key});

  @override
  State<MyNotificationScreen> createState() => _MyNotificationScreenState();
}

class _MyNotificationScreenState extends State<MyNotificationScreen> {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    // Initialize notification settings for Android
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Listen for messages when the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      // If notification is available, show it using local notifications
      if (notification != null && android != null) {
        _flutterLocalNotificationsPlugin.show(
          notification.hashCode, // Notification ID (hashCode for uniqueness)
          notification.title, // Notification title
          notification.body, // Notification body
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel', // Channel ID
              'High Importance Notifications', // Channel name
              channelDescription:
                  'This channel is used for important notifications.', // Channel description
              color: Colors.blue,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    });

    // Handle actions when the notification is opened
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      // If notification is available, show a dialog
      if (notification != null && android != null) {
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text(notification.title ?? ""), // Dialog title
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(notification.body ?? "")], // Dialog content
                ),
              ),
            );
          },
        );
      }
    });

    // Call method to get the device's FCM token
    getToken();
  }

  // Method to get the FCM token
  void getToken() async {
    String? token = await FirebaseMessaging.instance
        .getToken(); // Get the device's FCM token
    // ignore: avoid_print
    print('FCM Token: $token'); // Print the token to the log
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Notification'),
      ),
    );
  }
}
