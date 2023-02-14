import 'dart:convert';

import 'package:club_app/repository/club_app_repository.dart';
import 'package:club_app/ui/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:club_app/constants/strings.dart';
import 'package:rxdart/rxdart.dart';

class LandingBloc {
  final ClubAppRepository _repository = ClubAppRepository();
  BehaviorSubject<int> loyaltyPointsController = BehaviorSubject<int>();
  BehaviorSubject<String> memberShipTypeController = BehaviorSubject<String>();
  BehaviorSubject<String> QRCodeController = BehaviorSubject<String>();
  BehaviorSubject<String> loyaltyNameController = BehaviorSubject<String>();
  BehaviorSubject<String> userNameController = BehaviorSubject<String>();
  BehaviorSubject<bool> loaderController = BehaviorSubject<bool>();

  void dispose() {
    loyaltyPointsController.close();
    loyaltyNameController.close();
    userNameController.close();
    loaderController.close();
  }

  Future<bool> getUserDetails(String userId, BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int guestId = prefs.getInt(ClubApp.userId);
    bool isStaff = false;
    int loyaltyPoints;
    String loyaltyName;
    String memberShipType;
    String qrCode;
    try {
      isStaff = await _repository
          .getUserProfile(guestId.toString())
          .then((Response response) {
        debugPrint(
            'Get user profile API response is ${json.decode(response.body)}');
        Map map = json.decode(response.body);
        if (map['status'] as bool) {
          print("comin");
          loyaltyPoints = map['data']['loyalty_point'] as int;
          loyaltyName = map['data']['loyalty_name'] as String;
          memberShipType = map['data']['membership_type'] as String;
          qrCode = map['data']['qrcode'] as String;
          QRCodeController.add(qrCode);
          memberShipTypeController.add(memberShipType);
          loyaltyPointsController.add(loyaltyPoints);
          loyaltyNameController.add(loyaltyName);
          userNameController.add(map['data']['first_name'] + " " + map['data']['last_name']);
          return map['data']['staff'] == 1;
        }
        return false;
      }).catchError((Object error) {
        debugPrint('User Profile response exception is ${error.toString()}');
        return isStaff;
      });
    } catch (error) {
      return isStaff;
    }

    return isStaff;
  }

  Future<bool> registerDeregisterToken(bool isRegister) async {
    print("Maya registerDeregisterToken");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int guestId = prefs.getInt(ClubApp.userId);
    // String token = prefs.getString(ClubApp.token);
    bool isResponse = false;
    try {
      isResponse = await _repository
          .registerDeregisterToken("token", guestId, isRegister)
          .then((Response response) {
        debugPrint(
            'Register/De-Register token API response is ${json.decode(response.body)}');
        Map map = json.decode(response.body);
        if (map['status'] as bool) {
          return true;
        }
        return false;
      }).catchError((Object error) {
        debugPrint('Firebase token response exception is ${error.toString()}');
        return isResponse;
      });
      return isResponse;
    } catch (error) {
      debugPrint('Firebase token response exception is ${error.toString()}');
      return isResponse;
    }
  }

  Future<void> getUserProfile() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      String firstName = prefs.getString(ClubApp.firstName);
      String lastName = prefs.getString(ClubApp.lastName);
      userNameController.add(firstName + ' ' + lastName);
    } catch (e) {
      print(e);
    }
  }

  Future<void> verify(String bookingUid, BuildContext context) async {
    try {
      loaderController.add(true);
      _repository.verify(bookingUid).then((Response response) {
        loaderController.add(false);
        debugPrint('Verift API response is ${response.body}');
        Map<String, dynamic> map = json.decode(response.body);
        if (map['status']) {
          ackAlert(context, 'Booking id verified successfully');
        } else {
          ackAlert(context, map['error']);
        }
      });
    } catch (e) {
      loaderController.add(false);
    }
  }
}
