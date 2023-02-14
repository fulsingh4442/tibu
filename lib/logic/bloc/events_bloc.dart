import 'dart:convert';

import 'package:club_app/constants/strings.dart';
import 'package:club_app/logic/models/advertise.dart';
import 'package:club_app/logic/models/event_model.dart';
import 'package:club_app/logic/models/events.dart';
import 'package:club_app/repository/club_app_repository.dart';
import 'package:club_app/ui/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart';

enum EventsState { Busy, NoData, ListRetrieved, AllEventsFetched }

class EventBloc {
  final ClubAppRepository _repository = ClubAppRepository();
  BehaviorSubject<bool> isLoadingController = BehaviorSubject<bool>();
  BehaviorSubject<EventsState> eventListController =
      BehaviorSubject<EventsState>();
  BehaviorSubject<Advertise> advertiseController = BehaviorSubject<Advertise>();
  List<EventModel> eventList;
  int eventCount = 0;
  Advertise advertise;

  void dispose() {
    isLoadingController.close();
    eventListController.close();
    advertiseController.close();
  }

  // Future<void> fetchLocalEventsList() async {
  //   isLoadingController.add(true);
  //   Future.delayed(Duration(seconds: 3), () {
  //     eventList = <EventModel>[];
  //     EventModel eventModel1 = EventModel(
  //         1,
  //         'Event Title 1',
  //         'Short description of event 1',
  //         'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.',
  //         '2020-May-23',
  //         'assets/images/event4.jpg');
  //     EventModel eventModel2 = EventModel(
  //         2,
  //         'Event Title 2',
  //         'Short description of event 2',
  //         'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.',
  //         '2020-May-23',
  //         'assets/images/event2.jpg');
  //     EventModel eventModel3 = EventModel(
  //         3,
  //         'Event Title 3',
  //         'Short description of event 3',
  //         'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.',
  //         '2020-May-27',
  //         'assets/images/event3.jpg');
  //     EventModel eventModel4 = EventModel(
  //         4,
  //         'Event Title 4',
  //         'Short description of event 4',
  //         'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.',
  //         '2020-May-30',
  //         'assets/images/event1.jpg');
  //     EventModel eventModel5 = EventModel(
  //         5,
  //         'Event Title 5',
  //         'Short description of event 5',
  //         'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.',
  //         '2020-Jun-05',
  //         'assets/images/event5.jpg');
  //     EventModel eventModel6 = EventModel(
  //         6,
  //         'Event Title 6',
  //         'Short description of event 6',
  //         'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.',
  //         '2020-Jul-12',
  //         'assets/images/event7.jpg');

  //     eventList.add(eventModel1);
  //     eventList.add(eventModel2);
  //     eventList.add(eventModel3);
  //     eventList.add(eventModel4);
  //     eventList.add(eventModel5);
  //     //eventList.add(eventModel6);

  //     isLoadingController.add(false);
  //     eventListController.add(EventsState.ListRetrieved);
  //   });
  // }

  void fetchEventsList(BuildContext context, int page, int offset) async {
    debugPrint('In fetch events function');
    isLoadingController.add(true);
    _repository.getEvents(page: page, volume: offset).then((Response response) {
      isLoadingController.add(false);

      EventsResponse eventsResponse =
          EventsResponse.fromJson(json.decode(response.body));
      debugPrint(
          'Event list response is ----------------------- ${response.body}');
      if (eventsResponse.status) {
        eventCount = eventsResponse.count;
        if (eventsResponse.eventList != null &&
            eventsResponse.eventList.isNotEmpty) {
          if (page == 1) {
            eventList = <EventModel>[];
          }
          eventList.addAll(eventsResponse.eventList);
          eventListController.add(EventsState.ListRetrieved);
        } else {
          if (eventList == null || (eventList != null && eventList.isEmpty)) {
            eventListController.add(EventsState.NoData);
          } else {
            eventListController.add(EventsState.AllEventsFetched);
          }
        }
        if (eventsResponse.advertiseList != null &&
            eventsResponse.advertiseList.isNotEmpty) {
          for (Advertise advertise in eventsResponse.advertiseList) {
            int dateDiff = 0;

            if (advertise.advertiseEndDate != null) {
              dateDiff =
                  advertise.advertiseEndDate.difference(DateTime.now()).inDays;
            }
            if (dateDiff >= 0) {
              this.advertise = advertise;
              advertiseController.add(advertise);
              break;
            }
          }
        }
      } else {
        ackAlert(context, eventsResponse.error);
      }
    }).catchError((Object error) {
      isLoadingController.add(false);
    });
  }
}
