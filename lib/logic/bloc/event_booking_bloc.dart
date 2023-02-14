import 'dart:convert';

import 'package:club_app/constants/navigator.dart';
import 'package:club_app/constants/strings.dart';
import 'package:club_app/logic/models/category.dart';
import 'package:club_app/logic/models/event_model.dart';
import 'package:club_app/logic/models/event_seats.dart';
import 'package:club_app/repository/club_app_repository.dart';
import 'package:club_app/ui/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum EventsBookingState { Busy, NoData, ListRetrieved }

class EventBookingBloc {
  final ClubAppRepository _repository = ClubAppRepository();
  BehaviorSubject<bool> isLoadingController = BehaviorSubject<bool>();
  BehaviorSubject<EventsBookingState> eventListController =
      BehaviorSubject<EventsBookingState>();
  List<EventSeats> eventSeatsList = <EventSeats>[];
  List<CategoryList> categoryList = <CategoryList>[];

  void dispose() {
    isLoadingController.close();
    eventListController.close();
  }

  Future<void> fetchLocalEventsTicketsList() async {
    isLoadingController.add(true);
    Future.delayed(Duration(seconds: 3), () {
      eventSeatsList = <EventSeats>[];
    });
  }

  Future<void> fetchEventSeats(int eventId, BuildContext context) async {
    debugPrint('in fetchEventSeats');
    isLoadingController.add(true);
    _repository.getEventsSeats(eventId).then((Response response) {
      isLoadingController.add(false);
      debugPrint('Fetch event seats response is ${json.decode(response.body)}');
      EventSeatsResponse eventSeatsResponse =
          EventSeatsResponse.fromJson(json.decode(response.body));
      if (eventSeatsResponse.status) {
        if (eventSeatsResponse.eventSeatsList != null &&
            eventSeatsResponse.eventSeatsList.isNotEmpty) {
          eventSeatsList.clear();
          eventSeatsList.addAll(eventSeatsResponse.eventSeatsList);
          eventListController.add(EventsBookingState.ListRetrieved);
        } else {
          eventListController.add(EventsBookingState.NoData);
        }
      } else {
        ackAlert(context, eventSeatsResponse.error);
      }
    }).catchError((Object error) {
      print(error.toString());
      isLoadingController.add(false);
    });
  }

  Future<void> checkoutEvents(int eventId, List<EventSeats> eventSeatsList,
      BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt(ClubApp.userId);
    List<Map<String, dynamic>> eventCategory = <Map<String, dynamic>>[];
    for (EventSeats seats in eventSeatsList) {
      if (seats.quantity > 0) {
        eventCategory
            .add({'event_sub_id': seats.seatId, 'quantity': seats.quantity});
      }
    }

    isLoadingController.add(true);
    _repository
        .checkoutEventBookings(userId.toString(), eventId, eventCategory)
        .then((Response response) {
      isLoadingController.add(false);
      debugPrint('Checkout event seats response is ${response.body}');
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody['status']) {
        asyncConfirmDialog(context, ClubApp.app_name,
                'Event booked successfully', 'Ok', 'Go To Bookings')
            .then((ConfirmAction action) {
          if (action == ConfirmAction.ACCEPT) {
            Navigator.of(context).popUntil(ModalRoute.withName('/landing'));
            AppNavigator.gotoBookings(context);
          } else {
            Navigator.of(context).pop();
          }
        });
      } else {
        ackAlert(context, responseBody['error']);
      }
    });
  }

  
}
