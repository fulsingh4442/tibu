import 'dart:convert';

import 'package:club_app/constants/strings.dart';
import 'package:club_app/repository/club_app_repository.dart';
import 'package:club_app/ui/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart';

class CurrencyBloc {
  final ClubAppRepository _repository = ClubAppRepository();
  BehaviorSubject<bool> loadingController = BehaviorSubject<bool>();

  void dispose() {
    loadingController.close();
  }

  void currency(BuildContext context) async {
    loadingController.add(true);
    _repository.getCurrency().then((Response response) async {
      loadingController.add(false);
      debugPrint(
          'get currency api response is ------------------ ${response.body}');
      Map map = json.decode(response.body);
      if (map['status']) {
        print("success");
        ClubApp.currencyLbl = map['data']['currency'];
        print("currency -------------- ${ClubApp.currencyLbl}");
      } else {
        String error = map['error'];
        ackAlert(context, error);
      }
    }).catchError((Object error) {
      loadingController.add(false);
    });
  }
}
