import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'all-screens/home/chat/chat-controller.dart';
import 'all-screens/home/navigation-screen.dart';
import 'all-screens/home/opinions/opiion-controller.dart';
import 'all-screens/home/stories/story-controller.dart';
import 'all-screens/login/login.dart';
import 'all-screens/login/provider_login_controller.dart';
import 'all-screens/splash-screen/splash_screen.dart';
import 'firebase-remote-config/remote-config-controller.dart';
import 'locator/locator.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}
AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
Future <void> _firebaseMessagingBackgroundhandler(RemoteMessage message)async{
  await Firebase.initializeApp();
  print("a background messaged just swafed up ${message.messageId}");
}

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

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

  await GetStorage.init();
  await setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

/*  void getToken() async {
    String token ;
    token = (await FirebaseMessaging.instance.getToken())!;
    print("this is firebase fcm token ==  ${token}");
  }*/

  @override
  Widget build(BuildContext context) {
    //getToken();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProviderLoginController()),
        ChangeNotifierProvider(create: (context) => OpinionController()),
        ChangeNotifierProvider(create: (context) => StoryController()),
        ChangeNotifierProvider(create: (context) => ChatController()),
        ChangeNotifierProvider(create: (context) => RemoteConfigController()),
      ],
      child: KeyboardDismissOnTap(
        child: MaterialApp(
          title: "Ureport Ecaro",
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: NavigationScreen(),
        ),

      ),
    );
  }
}


