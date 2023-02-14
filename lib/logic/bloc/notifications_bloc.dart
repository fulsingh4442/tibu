import 'dart:convert';

import 'package:club_app/constants/strings.dart';
import 'package:club_app/logic/models/notifications.dart';
import 'package:club_app/repository/club_app_repository.dart';
import 'package:club_app/ui/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum NotificationsState { Busy, NoData, ListRetrieved, AllEventsFetched }
class NotificationsBloc{
  final ClubAppRepository _repository = ClubAppRepository();
  BehaviorSubject<bool> isLoadingController = BehaviorSubject<bool>();
  BehaviorSubject<NotificationsState> eventListController =
  BehaviorSubject<NotificationsState>();
  List<Notifications> notificationsList;
  int notificationCount = 0;

  void dispose() {
    isLoadingController.close();
    eventListController.close();
  }

  void fetchNotificationsList(BuildContext context, int page, int offset) async {
    debugPrint('In fetch notifications function');
    isLoadingController.add(true);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt(ClubApp.userId);

    _repository.getNotifications(userId: userId.toString(), page: page, volume: offset).then((Response response) {
      isLoadingController.add(false);

      NotificationsResponse notificationResponse =
      NotificationsResponse.fromJson(json.decode(response.body));
      debugPrint('Notifications list response is ${response.body}');
      if (notificationResponse.status) {
        if (notificationResponse.notifications != null &&
            notificationResponse.notifications.isNotEmpty) {
          if (page == 1) {
            notificationsList = <Notifications>[];
          }
          notificationsList.addAll(notificationResponse.notifications);
          eventListController.add(NotificationsState.ListRetrieved);
        } else {
          if (notificationsList == null || (notificationsList != null && notificationsList.isEmpty)) {
            eventListController.add(NotificationsState.NoData);
          } else {
            eventListController.add(NotificationsState.AllEventsFetched);
          }
        }

      } else {
        ackAlert(context, notificationResponse.error);
        if (notificationsList == null || (notificationsList != null && notificationsList.isEmpty)) {
          eventListController.add(NotificationsState.NoData);
        }else {
          eventListController.add(NotificationsState.AllEventsFetched);
        }
      }
    }).catchError((Object error) {
      isLoadingController.add(false);
    });
  }
}