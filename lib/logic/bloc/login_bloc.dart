import 'dart:async';
import 'dart:convert';

import 'package:club_app/constants/navigator.dart';
import 'package:club_app/constants/strings.dart';
import 'package:club_app/logic/models/event_model.dart';
import 'package:club_app/logic/models/login.dart';
import 'package:club_app/logic/models/profileaccess.dart';
import 'package:club_app/repository/club_app_repository.dart';
import 'package:club_app/ui/screens/login.dart';
import 'package:club_app/ui/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginBloc {
  final ClubAppRepository _repository = ClubAppRepository();
  BehaviorSubject<bool> rememberMeController = BehaviorSubject<bool>();
  BehaviorSubject<bool> visibleController = BehaviorSubject<bool>();
  BehaviorSubject<bool> autoValidateController = BehaviorSubject<bool>();

  Stream<bool> get rememberMeStream => rememberMeController.stream;

  Stream<bool> get visibleStream => visibleController.stream;
  BehaviorSubject<bool> loaderController = BehaviorSubject<bool>();
  ProfileAccessModel _profileAccessModel = new ProfileAccessModel();

  void dispose() {
    rememberMeController.close();
    visibleController.close();
    autoValidateController.close();
    loaderController.close();
  }

  Future<void> loginUser(String username, String password, String type,
      EventModel eventModel, BuildContext context) async {
    print(type);
    loaderController.add(true);
    _repository.loginUser(username, password).then((Response response) async {
      loaderController.add(false);
      debugPrint('Login response is ${response.body}');
      LoginResponse loginResponse =
          LoginResponse.fromJson(json.decode(response.body));
      if (loginResponse.status) {
        await _saveUserDetailsToSharedPref(loginResponse.userDetails);

        final SharedPreferences prefs =
        await SharedPreferences.getInstance();
        if (loginResponse.userDetails.photo != null) {
          prefs.setString("photo", loginResponse.userDetails.photo);
        }

        if (type == "event") {
          AppNavigator.gotoBookEvent(context, eventModel);
        } else if (type == "table" ||
            type == "sidemenu" ||
            type == "cart" ||
            type == "bidding") {
          AppNavigator.gotoLanding(context);
        } else if (type == "enddrawer") {
          AppNavigator.gotoBookings(context);
        }
      } else {
        ackAlert(context, loginResponse.error);
      }
    }).catchError((Object error) {
      loaderController.add(false);
      debugPrint('Login response exception is ${error.toString()}');
      ackAlert(context, error.toString());
    });
  }

  Future<void> forgetPassword(String email, BuildContext context) async {
    loaderController.add(true);
    _repository.forgetPassword(email).then((Response response) async {
      loaderController.add(false);
      debugPrint('Forget password response is ${response.body}');
      Map<String, dynamic> map = json.decode(response.body);
      if (map['status']) {
        ackAlert(context,
            'A mail has been sent successfully to registered email address to Reset Password.');
      } else {
        debugPrint('Forget password failed with message ${map['error']}');
        ackAlert(context, map['error']);
      }
    }).catchError((Object error) {
      loaderController.add(false);
      debugPrint('Forget pasword response exception is ${error.toString()}');
      ackAlert(context, error.toString());
    });
  }

  Future<void> loginGoogleUser(String email, String firstName, String lastName,
      BuildContext context) async {
    loaderController.add(true);
    _repository
        .loginGoogleUser(email, firstName, lastName)
        .then((Response response) async {
      loaderController.add(false);
      debugPrint('Google Login response is ${response.body}');
      LoginResponse loginResponse =
          LoginResponse.fromJson(json.decode(response.body));
      if (loginResponse.status) {
        await _saveUserDetailsToSharedPref(loginResponse.userDetails);
        AppNavigator.gotoLanding(context);
      } else {
        ackAlert(context, loginResponse.error);
      }
    }).catchError((Object error) {
      loaderController.add(false);
      debugPrint('Login response exception is ${error.toString()}');
      ackAlert(context, error.toString());
    });
  }

  int userId;
  String username;
  String email;
  int role;
  String status;
  String gender;
  String staff;
  String token;
  Future<void> _saveUserDetailsToSharedPref(UserDetails userDetails) async {
    print(userDetails);
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(ClubApp.loginSuccess, true);
      prefs.setInt(ClubApp.userId, userDetails.userId);
      prefs.setString(ClubApp.username, userDetails.username);
      prefs.setString(ClubApp.lastName, userDetails.lastName);
    //  prefs.setInt(ClubApp.role, userDetails.role);
      prefs.setString(ClubApp.gender, userDetails.gender);
      // prefs.setString(ClubApp.phone, userDetails.phone);
      prefs.setString(ClubApp.email, userDetails.email);
      prefs.setString(ClubApp.status, userDetails.status);
      prefs.setString(ClubApp.access_key, userDetails.accessKey);
      prefs.setString("photo", userDetails.photo);
    } catch (e) {
      print(e);
    }
  }

  Future<void> profileAccess(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessKey = prefs.getString(ClubApp.access_key);
    String email = prefs.getString(ClubApp.email);
    loaderController.add(true);
    _repository
        .getProfileAccess(email, accessKey)
        .then((Response response) async {
      debugPrint('create payment api response is ${response.body}');
      LoginResponse loginResponse =
          LoginResponse.fromJson(json.decode(response.body));
      if (loginResponse.status) {
        prefs.setBool(ClubApp.loginSuccess, false);
        //await _landingBloc.registerDeregisterToken(false);
        //prefs.setString(ClubApp.token, null);
        await _saveUserDetailsToSharedPref(loginResponse.userDetails);
        AppNavigator.gotoLanding(context);
      } else {
        print("login response is ${response.body}");
        if (loginResponse.error.contains("Invalid Access Token")) {
          final SharedPreferences prefs =
          await SharedPreferences.getInstance();
          prefs.setBool(ClubApp.loginSuccess, false);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen("cart")),
          );
        }
        else {
          ackAlert(context, loginResponse.error);
        }
      }
    }).catchError((Object error) {
      loaderController.add(false);
      debugPrint('create payment response exception is ${error.toString()}');
      ackAlert(context, error.toString());
    });
  }
}
