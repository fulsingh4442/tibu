import 'dart:convert';
import 'dart:typed_data';

import 'package:club_app/constants/navigator.dart';
import 'package:club_app/constants/strings.dart';
import 'package:club_app/observer/user_profile_observable.dart';
import 'package:club_app/repository/club_app_repository.dart';
import 'package:club_app/ui/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpBloc {
  final ClubAppRepository _repository = ClubAppRepository();
  BehaviorSubject<bool> loaderController = BehaviorSubject<bool>();

  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController residenceController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  int _genderValue = -1;
  bool isEnabled = true;

  String photoURL = null;

  int get genderValue => _genderValue;
  void set genderValue(int value) => _genderValue = value;

  void dispose() {
    loaderController.close();

    nameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    dobController.dispose();
    addressController.dispose();
    mobileController.dispose();
    residenceController.dispose();
  }

  Future<void> registerUser(
      String name,
      String lastName,
      String email,
      String password,
      String confirmPassword,
      String phone,
      String gender,
      String dob,
      Uint8List data,
      BuildContext context) async {
    loaderController.add(true);
    _repository
        .signUpUser(name, lastName, email, password, confirmPassword, gender, phone, dob, data)
        .then((Response response) async {
      loaderController.add(false);
      debugPrint('Sign Up response is ${response.body}');

      /// Yet to parse sign up api as response format is not fixed
      Map map = json.decode(response.body);
      if (map.containsKey('status') && map['status']) {
        //AppNavigator.gotoLogin(context);
        ackAlertWithBackScreen(context, ClubApp.register_success_message);
      } else {
        String error = map['error'];
        ackAlert(context, error);
      }
    }).catchError((Object error) {
      loaderController.add(false);
      debugPrint('Sign up response exception is ${error.toString()}');
      ackAlert(context, error.toString());
    });
    ;
  }

  Future<void> getUserDetails(String userId, BuildContext context) async {
    loaderController.add(true);
    _repository.getUserProfile(userId).then((Response response) async {
      debugPrint('User rofile api response is ${response.body}');
      Map map = json.decode(response.body);
      if (map['status'] as bool) {
        nameController.text = map['data']['first_name'];
        lastNameController.text = map['data']['last_name'];
        emailController.text = map['data']['email'];
        mobileController.text = map['data']['phone'];
        residenceController.text = map['data']['nationality'];
        genderValue = map['data']['gender'];
        print("-----name----- ${nameController.text}");
        final SharedPreferences prefs =
            await SharedPreferences.getInstance();
        if (map['data']['photo'] != null) {
          prefs.setString("photo", map['data']['photo']);
          photoURL = map['data']['photo'];
        }
        else {
          photoURL= prefs.getString('photo');
        }

        if (mobileController.text.isEmpty) {
          isEnabled = true;
        } else {
          isEnabled = false;
        }
      }

      loaderController.add(false);
    }).catchError((Object error) {
      loaderController.add(false);
      debugPrint('User Profile response exception is ${error.toString()}');
      ackAlert(context, error.toString());
    });
  }

  Future<void> updateUserDetails(
      String userId,
      String name,
      String lastName,
      String gender,
      String nationality,
      String phone,
      String email,
      Uint8List imgData,
      BuildContext context) async {
    loaderController.add(true);
    _repository
        .updateUserProfile(userId, name, lastName, gender, nationality, phone, email, imgData)
        .then((Response response) async {
      debugPrint('Update User rofile api response is ${response.body}');
      Map map = json.decode(response.body);
      loaderController.add(false);
      if (map['status'] as bool) {
        String firstName = name;
        // String lastName = name;
        // List<String> nameArray = name.split(' ');
        // if (nameArray.length > 1) {
        //   firstName = nameArray[0];
        //   lastName = '';
        //   for (int i = 1; i < nameArray.length; i++) {
        //     lastName = lastName + ' ' + nameArray[i];
        //   }
        // }

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(ClubApp.firstName, firstName);
        prefs.setString(ClubApp.lastName, lastName);
        prefs.setInt(ClubApp.gender, gender == 'Male' ? 1 : 2);
        prefs.setString(ClubApp.phone, phone);
        print("MMMMMMMMMM: $map");
        if (map['data']['photo'] != null) {
          prefs.setString("photo", map['data']['photo']);
          photoURL = map['data']['photo'];
          print("MMMMMMMMMM: $photoURL");
        }
      else {
          print("HHHHHHHHH: $map");
        photoURL= prefs.getString('photo');
      }
        UserProfileObservable userProfileObservable = UserProfileObservable();
        userProfileObservable.notifyUpdateUserName(name + ' ' + lastName);
        ackAlertWithBackScreen(context, map['error']);
      }
    }).catchError((Object error) {
      loaderController.add(false);
      debugPrint('User Profile response exception is ${error.toString()}');
      ackAlert(context, error.toString());
    });
  }
}
