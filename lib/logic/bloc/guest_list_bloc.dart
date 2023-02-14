import 'dart:convert';

import 'package:club_app/constants/navigator.dart';
import 'package:club_app/repository/club_app_repository.dart';
import 'package:club_app/ui/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart';

class GuestListBloc {
  final ClubAppRepository _repository = ClubAppRepository();
  BehaviorSubject<bool> loaderController = BehaviorSubject<bool>();

  List<DateTime> dates = [];
  void dispose() {
    loaderController.close();
  }

  Future<void> getDisabledGuestDates() async {
    loaderController.add(true);
    _repository.getDisabledGuestDates().then((Response response) async {
      loaderController.add(false);
      Map map = json.decode(response.body);
      if (map["dates"] != null) {
        for (var stringDate in map["dates"]) {
          final date = DateTime.parse(stringDate.toString());
          dates.add(date);
        }
      }
    });
  }

  Future<void> guestListAdd(
      String name,
      String email,
      String phoneNumber,
      int menCount,
      int womenCount,
      String registerDate,
      String referenceName,
      String notes,
      BuildContext context) async {
    loaderController.add(true);
    _repository
        .updateGuestList(
            name, email, phoneNumber, menCount, womenCount, registerDate, referenceName, notes)
        .then((Response response) async {
      loaderController.add(false);
      debugPrint('Guest list update response is ${response.body}');
      // ackAlert(context, "Guest list added");

      Map map = json.decode(response.body);
      if (map.containsKey('status') && map['status']) {
        asyncConfirmSingleButtonDialog(
                context, "Success", "Guest list submitted", "Ok")
            .then((value) => Navigator.of(context).pop());
      } else {
        String error = map['error'];
        ackAlert(context, error);
      }
    }).catchError((Object error) {
      loaderController.add(false);
      debugPrint('Guest list update response exception is ${error.toString()}');
      ackAlert(context, error.toString());
    });
  }
}
