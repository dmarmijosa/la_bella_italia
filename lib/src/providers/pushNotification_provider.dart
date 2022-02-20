import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:la_bella_italia/src/models/user.dart';
import 'package:la_bella_italia/src/providers/user_provider.dart';
import 'package:http/http.dart' as http;

class PushNotificationProvider {
  AndroidNotificationChannel channel;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  void initNotification() async {
    try {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        'This channel is used for important notifications.', // description
        importance: Importance.high,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    } catch (e) {
      print(e);
    }
  }

  void onMessageListener() async {
    try {
      FirebaseMessaging.instance
          .getInitialMessage()
          .then((RemoteMessage message) {
        if (message != null) {}
      });

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('NUEVA NOTIFICACION EN PRIMER PLANO');

        RemoteNotification notification = message.notification;
        AndroidNotification android = message.notification?.android;
        print(notification.body);
        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channel.description,
                  icon: 'launch_background',
                ),
              ));
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('A new onMessageOpenedApp event was published!');
      });
    } catch (e) {
      print(e);
    }
  }

  void saveToken(User user, BuildContext context) async {
    String token = await FirebaseMessaging.instance.getToken();
    UserProvider usersProvider = new UserProvider();
    usersProvider.init(context, sessionUser: user);
    await usersProvider.updateNotificationToken(user.id, token);
  }

  Future<void> sendMessage(
      String to, Map<String, dynamic> data, String title, String body) async {
    Uri url = Uri.https('fcm.googleapis.com', '/fcm/send');

    await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAoL2-81g:APA91bF45Ssuvn4q40mn88YyTrQotcPpHP7Buele59fiDyveq0zlePI0iz-1abcJdtYyRaVJ3jMswEbiTgxU0MaLpT75vljCejhlviH5VU28--PlcpKPhaSk5eEqoXqJbHvJ1M183b2K'
        },
        body: jsonEncode(<String, dynamic>{
          'notification': <String, dynamic>{
            'body': body,
            'title': title,
          },
          'priority': 'high',
          'ttl': '4500s',
          'data': data,
          'to': to
        }));
  }

  Future<void> sendMessageMultiple(List<String> toList,
      Map<String, dynamic> data, String title, String body) async {
    Uri url = Uri.https('fcm.googleapis.com', '/fcm/send');

    await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAoL2-81g:APA91bF45Ssuvn4q40mn88YyTrQotcPpHP7Buele59fiDyveq0zlePI0iz-1abcJdtYyRaVJ3jMswEbiTgxU0MaLpT75vljCejhlviH5VU28--PlcpKPhaSk5eEqoXqJbHvJ1M183b2K'
        },
        body: jsonEncode(<String, dynamic>{
          'notification': <String, dynamic>{
            'body': body,
            'title': title,
          },
          'priority': 'high',
          'ttl': '4500s',
          'data': data,
          'registration_ids': toList
        }));
  }
}
