import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vendor_app/res/getx_localization/languages.dart';
import 'package:vendor_app/res/routes/routes.dart';
import 'package:vendor_app/res/routes/routes_name.dart';
import 'package:vendor_app/view_models/controller/create_new_drop_off/create_newdropoff_order_view_model.dart';
import 'package:vendor_app/view_models/controller/create_new_drop_off/search_user_by_phone_view_model.dart';
import 'package:vendor_app/view_models/controller/drop_off/drop_off_view_model.dart';
import 'package:vendor_app/view_models/controller/home/Tabs/notification_controller.dart';
import 'firebase_options.dart';
import 'notificaition_service.dart';

/// ------------------------------------------------------------
/// BACKGROUND FIREBASE MESSAGE HANDLER
/// ------------------------------------------------------------
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationsRepo().initLocalNotifications();

  print('📩 Background message received: ${message.data}');

  if (message.data['body']?.toString().toLowerCase().contains('calling') ??
      false) {
  } else {
    await NotificationsRepo().showNotifications(message);
  }
}

/// ------------------------------------------------------------
/// MAIN APP INITIALIZATION
/// ------------------------------------------------------------
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await NotificationsRepo().initLocalNotifications();
  await NotificationsRepo().initNotifications();
  NotificationsRepo().firebaseInit();

  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    FirebaseMessaging.instance.subscribeToTopic("all");
  }

  await GetStorage.init();

  Get.lazyPut(() => SearchUserByPhoneController(), fenix: true);
  Get.lazyPut(() => ListDropoffController(), fenix: true);
  Get.lazyPut(() => CreateDropOffOrderViewModel(), fenix: true);
  Get.lazyPut(() => NotificationController(), fenix: true);

  if (kIsWeb) {
    setUrlStrategy(const PathUrlStrategy());
  }

  runApp(const VendorApp());
}

/// ------------------------------------------------------------
/// APP WIDGET
/// ------------------------------------------------------------
class VendorApp extends StatefulWidget {
  const VendorApp({super.key});
  @override
  State<VendorApp> createState() => _VendorAppState();
}

class _VendorAppState extends State<VendorApp> {
  List<dynamic> events = [];

  @override
  void initState() {
    super.initState();
    // callback();
  }

  // Future<void> callback() async {
  //   events = await callKeep.activeCalls();
  //   print(events);

  //   await callKeep.endAllCalls();
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        translations: Languages(),
        locale: const Locale('en', 'US'),
        fallbackLocale: const Locale('en', 'US'),
        initialRoute: RouteName.splashScreen,
        getPages: AppRoutes.appRoutes(),
      ),
    );
  }
}
