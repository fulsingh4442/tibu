import 'dart:convert';

import 'package:club_app/repository/club_app_repository.dart';
import 'package:club_app/ui/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart';

class AddAddonToCartBloc {
  final ClubAppRepository _repository = ClubAppRepository();
  BehaviorSubject<bool> loaderController = BehaviorSubject<bool>();

  void dispose() {
    loaderController.close();
  }

  Future<void> addAddon(int addonId, String cartIds, int quantity,
      String addOnFor, BuildContext context) async {
    loaderController.add(true);
    _repository
        .addAddonToCart(addonId, cartIds, quantity, addOnFor)
        .then((Response response) async {
      loaderController.add(false);
      debugPrint('======add addon to cart response======= ${response.body}');

      Map map = json.decode(response.body);
      if (map.containsKey('status') && map['status']) {
        ackAlert(context, "Added To Cart");
      } else {
        String error = map['error'];
        ackAlert(context, error);
      }
    }).catchError((Object error) {
      loaderController.add(false);
      debugPrint('add addon to cart response exception is ${error.toString()}');
      ackAlert(context, error.toString());
    });
  }
}
