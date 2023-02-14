import 'dart:convert';

import 'package:club_app/repository/club_app_repository.dart';
import 'package:club_app/ui/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart';

class DeleteBloc {
  final ClubAppRepository _repository = ClubAppRepository();
  BehaviorSubject<bool> loaderController = BehaviorSubject<bool>();

  void dispose() {
    loaderController.close();
  }

  Future<void> delete(
      String type, int guestId, BuildContext context) async {
    loaderController.add(true);
    _repository
        .deleteCartItem(type, guestId)
        .then((Response response) async {
      loaderController.add(false);
      debugPrint('======calling delete from cart======= ${response.body}');

      Map map = json.decode(response.body);
      if (map.containsKey('status') && map['status']) {
        Navigator.of(context).pop();
      } else {
        String error = map['error'];
        ackAlert(context, error);
      }
    }).catchError((Object error) {
      loaderController.add(false);
      debugPrint('delete from cart response exception is ${error.toString()}');
      ackAlert(context, error.toString());
    });
  }
}
