import 'dart:convert';

import 'package:club_app/constants/navigator.dart';
import 'package:club_app/constants/strings.dart';
import 'package:club_app/logic/models/checkout.dart';
import 'package:club_app/observer/user_profile_observable.dart';
import 'package:club_app/repository/club_app_repository.dart';
import 'package:club_app/ui/screens/checkout.dart';
import 'package:club_app/ui/screens/landing.dart';
import 'package:club_app/ui/screens/table/table_new.dart';
import 'package:club_app/ui/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckOutBloc {
  final ClubAppRepository _repository = ClubAppRepository();
  BehaviorSubject<bool> loaderController = BehaviorSubject<bool>();
  CheckoutModel checkoutModel = CheckoutModel();
  bool statuss;

  void dispose() {
    loaderController.close();
  }

  Future<void> checkout(String userId, String name, String email, String phone,
      String rate, String paymentMethod, BuildContext context) async {
    loaderController.add(true);
    _repository
        .createPayment(userId, name, email, phone, rate, paymentMethod)
        .then((Response response) async {
      debugPrint('create payment api response is ${response.body}');
      checkoutModel = CheckoutModel.fromJson(json.decode(response.body));
      Map map = json.decode(response.body);
      loaderController.add(false);
      if (map['status'] as bool) {
        statuss = map['status'];
        print("----------status-------$statuss");
        // Navigator.of(context).pop();
      } else {
        String error = map['error'];
        ackAlert(context, error);
      }
    }).catchError((Object error) {
      loaderController.add(false);
      debugPrint('create payment response exception is ${error.toString()}');
      ackAlert(context, error.toString());
    });
  }

  Future<void> completePayment(
      String expectedArrival,
      String name,
      String currency,
      String email,
      String amount,
      String balanceTransaction,
      String orderId,
      String guestId,
      String cartGuestId,
      String status,
      BuildContext context) async {
    loaderController.add(true);
    _repository
        .completePayment(
      expectedArrival,
      name,
      currency,
      email,
      amount,
      balanceTransaction,
      orderId,
      guestId,
      cartGuestId,
      status,
    )
        .then((Response response) async {
      debugPrint('complete payment api response is ${response.body}');
      Map map = json.decode(response.body);
      loaderController.add(false);
      if (map['status']) {
        statuss = map['status'];
        print("----------status-------$statuss");
        // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
        //     builder: (BuildContext context) => LandingScreen()));
      } else {
        print("objectcoming");
        String error = map['error'];
      //  ackAlert(context, error);
      }
    }).catchError((Object error) {
      loaderController.add(false);
      debugPrint('complete payment response exception is ${error.toString()}');
      ackAlert(context, error.toString());
    });
  }
}
