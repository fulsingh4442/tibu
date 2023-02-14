//import 'dart:html';
import 'dart:io';

import 'package:club_app/ui/screens/landing.dart';
import 'package:club_app/ui/utils/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'package:club_app/ui/screens/select_branch.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:club_app/ui/screens/login.dart';
import 'package:club_app/ui/screens/splash.dart';
import 'package:club_app/constants/constants.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:overlay_support/overlay_support.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Assign publishable key to flutter_stripe
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  print("pub key is: ${prefs.getString('public_key')}");
  Stripe.publishableKey = prefs.getString('public_key');
  await Firebase.initializeApp(
    name: "Luna",
    options: DefaultFirebaseOptions.currentPlatform,
  );

   final _messaging = FirebaseMessaging.instance;
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  // NotificationSettings settings = await _messaging.requestPermission(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  //   provisional: false,
  // );
  //
  // if (settings.authorizationStatus == AuthorizationStatus.authorized){
  //   String token = await _messaging.getToken();
  //   print("TOKEN IS: $token");
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     print("MESSAGE: $message");
  //   });
  // }



  if (Platform.isIOS) {
    _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: false,
      provisional: false,
    );
  }

  String token = await _messaging.getToken();
  print("FirebaseMessaging token: $token");

  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print("Recieved push opende: $event");
  });

  FirebaseMessaging.onMessage.listen((event) {
    print("Recieved push ononly: ${event.data}");
    //ackAlert(context, "RECEIVED");
    showSimpleNotification(Text("${event.notification.title} \n ${event.notification.body}"), background: Colors.blueGrey);
  });


  runApp(MyApp());
}

class MyApp extends StatelessWidget {

 void initState() {

 }

  void _handleMessage(RemoteMessage message) {
    //
    print("Recieved message is $message");
  }

  @override
  Widget build(BuildContext context) {

    return OverlaySupport.global(child:MaterialApp(
      onUnknownRoute: (RouteSettings settings){
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: primarySwatch,
          appBarTheme: const AppBarTheme(
            brightness: Brightness.dark,
            color: colorPrimary,
            iconTheme: IconThemeData(color: Colors.white),

          ),
          /*outlinedButtonTheme: OutlinedButtonThemeData(
            style: ButtonStyle(
              textStyle:MaterialStateProperty.all(const TextStyle(color: buttonTextColor)),
              side: MaterialStateProperty.all(const BorderSide(color: buttonBorderColor)),
              backgroundColor: MaterialStateProperty.all(buttonBackground)
            )
          ),*/
          textTheme: const TextTheme(
            // Text size 20
            headline6:
            TextStyle(fontWeight: FontWeight.w500, color: colorPrimaryDark),
            // Text size 14
            subtitle2: TextStyle(fontWeight: FontWeight.w500),
            // Text size 16
            subtitle1:
            TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
            // Text size 14
            bodyText2:
            TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
            // Text size 14
            bodyText1:
            TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
            // Text size 12
            caption:
            TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
            // Text size 10
            overline:
            TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
            // Text size 13
            headline5:
            TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14.0),
          )),
      home: SplashScreen(),
      navigatorObservers: [routeObserver],
    ));
  }
}
