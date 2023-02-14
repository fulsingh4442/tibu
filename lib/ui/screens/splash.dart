import 'dart:async';
import 'package:club_app/constants/navigator.dart';
import 'package:club_app/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Class is used for handle changes in state of widgets by extending State<''> class and return state of widget class.
class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  bool passwordRememberFlag = false;

  // Execute timer asynchronously
  Future<void> startTime() async {
    final Duration _duration = Duration(seconds: 2);
    return Timer(_duration, selectNavigation);
  }

//select navigation basis on user logged in previously or login first time.
  dynamic selectNavigation() async {
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // final bool loginSuccess = prefs.get(ClubApp.loginSuccess);
    // if (loginSuccess != null && loginSuccess) {
    AppNavigator.gotoLanding(context);
    // } else {
    // AppNavigator.gotoLogin(context);
    // }
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    // shows full screen by hiding status bar
    //SystemChrome.setEnabledSystemUIOverlays(<SystemUiOverlay>[]);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/login.jpg'),


                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Image.asset('assets/images/tibus.png',
              // sucasaSelected
              //     ? 'assets/images/sucasa.jpg'
              //     : 'assets/images/Kenjin_logo.jpeg',
              //  color: Colors.white,
              fit: BoxFit.fill,
              alignment: Alignment.bottomCenter,
              width: 100,
              // height: 60,
            ),
          ),
        ],
      ),
    );
  }
}
