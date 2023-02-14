import 'package:club_app/constants/strings.dart';

class Validator {
  static const Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  static String validateEmail(String email) {
    final RegExp regex = RegExp(pattern);

    if (email.isEmpty) {
      return ClubApp.email_empty_msg;
    }
    if (!regex.hasMatch(email)) {
      return ClubApp.enter_valid_email;
    }
    return null;
  }

  static String validateMobile(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return ClubApp.mobile_empty_msg;
    }
    else if (!regExp.hasMatch(value)) {
      return ClubApp.enter_valid_mobile_number;
    }
    return null;
  }

  static String validateCount(String count) {
    if (count.isEmpty) {
      return ClubApp.enter_guest_count;
    }
    try {
      int.parse(count);
      return null;
    } on FormatException {
      return ClubApp.enter_correct_count;
    }
  }
}
