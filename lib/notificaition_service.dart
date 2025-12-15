import 'dart:convert';
import 'dart:developer';
import 'dart:math' as dm;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor_app/models/login/user_model.dart';
import 'package:vendor_app/repository/notification_repo/notification_repo.dart';
import 'package:vendor_app/view/chat/call_screen/ringing_screen.dart';

import 'view/chat/call_screen/call_screen.dart';
import 'view_models/controller/user_preference/user_preference_view_model.dart';

class NotificationsRepo {
  final _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    try {
      await _fcm.requestPermission().then((onValue) async {
        await _fcm.getToken().then((value) async {
          log('saved token is $value');
          print('saved token is $value');
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("token", value ?? '');
        });
      });
    } catch (c) {
      print(c);
    }
  }

  Future<void> showNotifications(RemoteMessage message,
      {bool isShow = false}) async {
    if (message.data['click_action'] != null && !isShow) {
      print("Notification clicked action: ${message.data['click_action']}");
      return;
    }

    AndroidNotificationChannel channel = AndroidNotificationChannel(
      dm.Random.secure().nextInt(100000).toString(),
      'High Importance Notification',
      importance: Importance.max,
    );
    AndroidNotificationDetails details = AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: 'Channel Description',
      importance: Importance.max,
      priority: Priority.max,
      ticker: 'Ticker',
    );

    DarwinNotificationDetails darwin = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.timeSensitive,
      presentBanner: true,
    );

    NotificationDetails notifs =
        NotificationDetails(android: details, iOS: darwin);

    String? msg = message.notification?.title ?? message.data['title'];
    String? body = message.notification?.body ?? message.data['body'];

    if (msg != null && body != null && msg.isNotEmpty && body.isNotEmpty) {
      print("Notification message: ${message.toString()}");
      print("Notification message: $msg");
      print("Notification message: $body");
      print("Notification message: ${message.data}");
      if (message.data['body']?.toString().toLowerCase().contains('calling') ??
          false) {
        final callerName =
            message.data['body'].toString().split('is').first.trim();
        if (message.data['title']
                ?.toString()
                .toLowerCase()
                .contains('decline') ??
            false) {
          if (isOnCallScreen = true) {
            Get.back();
          }
          _plugin.show(0, msg, body, payload: jsonEncode(message.data), notifs);
        } else {
          Get.to(() => CallerScreen(
                appId: message.data['appID'],
                token: message.data['rtcToken'],
                channel: message.data['channelName'],
                callerName: callerName,
                onAccept: () async {
                  UserModel? user = await UserPreference().getUser();

                  Get.to(() => CallScreen(
                        uid: user?.userLogin?.id.toString() ?? "",
                        isFromNotification: true,
                        appId: message.data['appID']?.toString() ?? '',
                        channelName: message.data['channelName'],
                        token: message.data['rtcToken'],
                      ));
                },
                onReject: () async {
                  UserModel? user = await UserPreference().getUser();
                  NotificationRepo.sendNotification(
                      channelName: message.data['channelName'],
                      targetid: message.data['uid'],
                      role: "vendor",
                      uid: user?.userLogin?.id.toString() ?? "",
                      body: "Declined",
                      touserType: "customer");
                  Get.back();
                },
              ));
        }
      } else {
        _plugin.show(0, msg, body, payload: jsonEncode(message.data), notifs);
      }
    }
  }

  Future<void> showBackgroundNotifications(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        dm.Random.secure().nextInt(100000).toString(),
        'High Importance Notification');
    AndroidNotificationDetails details = AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: 'Channel Description',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'Ticker',
      // ignore: prefer_const_constructors
    );

    DarwinNotificationDetails darwin = const DarwinNotificationDetails(
        presentAlert: true, presentBadge: true, presentSound: true);

    NotificationDetails notifs =
        NotificationDetails(android: details, iOS: darwin);

    String title = message.notification?.title.toString() ?? "No title";
    String body = message.notification?.body.toString() ?? "No body";

    print("Notification message 1: ${message.toString()}");
    Future.delayed(Duration.zero, () {
      _plugin.show(0, title, body, notifs);
      // log(message.data.toString());
    });
  }

  void firebaseInit() {
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked!');
    });
    FirebaseMessaging.onMessage.listen((message) async {
      await showNotifications(message, isShow: true);
    });
  }

  Future<void> initLocalNotifications() async {
    var androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var init = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);
    await _plugin.initialize(init);
  }
}
