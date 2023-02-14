import 'dart:convert';

import 'package:club_app/repository/club_app_repository.dart';
import 'package:club_app/ui/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart';

class AddToCartBloc {
  final ClubAppRepository _repository = ClubAppRepository();
  BehaviorSubject<bool> loaderController = BehaviorSubject<bool>();

  void dispose() {
    loaderController.close();
  }

  Future<void> cart(
      int eventId, int guestId, int quantity, BuildContext context) async {
    loaderController.add(true);
    _repository
        .addToCart(eventId, guestId, quantity)
        .then((Response response) async {
      loaderController.add(false);
      debugPrint('======add to cart event response======= ${response.body}');

      Map map = json.decode(response.body);
      if (map.containsKey('status') && map['status']) {
        print("success");
        // Navigator.of(context).pop();
      } else {
        String error = map['error'];
        ackAlert(context, error);
      }
    }).catchError((Object error) {
      loaderController.add(false);
      debugPrint('add to cart response exception is ${error.toString()}');
      ackAlert(context, error.toString());
    });
  }
}
