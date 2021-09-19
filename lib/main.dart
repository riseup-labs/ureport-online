import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:ureport_ecaro/utils/sp_constant.dart';
import 'package:ureport_ecaro/utils/sp_utils.dart';
import 'all-screens/home/chat/chat-controller.dart';
import 'all-screens/home/opinion/opinion_controller.dart';
import 'all-screens/home/stories/story-controller.dart';
import 'all-screens/home/stories/story-details-controller.dart';
import 'all-screens/login/provider_login_controller.dart';
import 'all-screens/splash-screen/splash_screen.dart';
import 'firebase-remote-config/remote-config-controller.dart';
import 'l10n/l10n.dart';
import 'locale/locale_provider.dart';
import 'locator/locator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundhandler(RemoteMessage message) async {
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

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
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
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => LocaleProvider(),
    builder: (context, child) {
      final provider = Provider.of<LocaleProvider>(context);
      setLocal(provider);
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ProviderLoginController()),
          ChangeNotifierProvider(create: (context) => OpinionController()),
          ChangeNotifierProvider(create: (context) => StoryController()),
          ChangeNotifierProvider(create: (context) => StoryDetailsController()),
          ChangeNotifierProvider(create: (context) => ChatController()),
          ChangeNotifierProvider(create: (context) => RemoteConfigController()),
        ],
        child: KeyboardDismissOnTap(
          child: MaterialApp(
            title: "Ureport Ecaro",
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              fontFamily: "Dosis"
            ),
            home: SplashScreen(),
            supportedLocales: L10n.all,
            locale: provider.locale,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
          ),
        ),
      );
    },
  );

  static void setLocal(LocaleProvider provider) {
    var sp = locator<SPUtil>();
    if(sp.getValue(SPConstant.SELECTED_LANGUAGE) == "en"){
      provider.setLocale(new Locale('en'));
    }else if(sp.getValue(SPConstant.SELECTED_LANGUAGE) == "ar"){
      provider.setLocale(new Locale('ar'));
    }else if(sp.getValue(SPConstant.SELECTED_LANGUAGE) == "zh"){
      provider.setLocale(new Locale('zh'));
    }else if(sp.getValue(SPConstant.SELECTED_LANGUAGE) == "fr"){
      provider.setLocale(new Locale('fr'));
    }else if(sp.getValue(SPConstant.SELECTED_LANGUAGE) == "ru"){
      provider.setLocale(new Locale('ru'));
    }else if(sp.getValue(SPConstant.SELECTED_LANGUAGE) == "es"){
      provider.setLocale(new Locale('es'));
    }else{
      provider.setLocale(new Locale('en'));
    }
  }
}

