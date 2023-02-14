// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:club_app/constants/strings.dart';

// class PushNotificationsManager {
//   PushNotificationsManager._();

//   factory PushNotificationsManager() => _instance;

//   static final PushNotificationsManager _instance =
//       PushNotificationsManager._();

//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
//   bool _initialized = false;

//   Future<String> init() async {
//     if (!_initialized) {
//       // For iOS request permission first.
//       _firebaseMessaging.requestNotificationPermissions(
//           const IosNotificationSettings(
//               sound: true, badge: true, alert: true, provisional: true));
//       _firebaseMessaging.onIosSettingsRegistered
//           .listen((IosNotificationSettings settings) {
//         print("Firebase Settings registered: $settings");
//       });
//       _firebaseMessaging.getToken().then((String token) {
//         assert(token != null);
//         print("Firebase token : ${token}");
//       });

//       _firebaseMessaging.configure(
//         onMessage: (Map<String, dynamic> message) async {
//           print("Firebase onMessage: $message");
//         },
//         onLaunch: (Map<String, dynamic> message) async {
//           print("Firebase onLaunch: $message");
//         },
//         onResume: (Map<String, dynamic> message) async {
//           print("Firebase onResume: $message");
//         },
//       );

//       // For testing purposes print the Firebase Messaging token
//       final SharedPreferences prefs = await SharedPreferences.getInstance();
//       String token = await _firebaseMessaging.getToken();
//       String savedToken = prefs.getString(ClubApp.token);
//       if (savedToken != null || savedToken == token) {
//         return null;
//       }
//       print("FirebaseMessaging token: $token");
//       prefs.setString(ClubApp.token, token);
//       _initialized = true;
//       return token;
//     }
//     return null;
//   }
// }
