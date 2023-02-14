import 'package:club_app/logic/models/event_model.dart';

class EventSeatsResponse {
  EventSeatsResponse.fromJson(Map jsonMap) {
    status = jsonMap['status'];
    error = jsonMap['error'];

    eventSeatsList = <EventSeats>[];
    if (jsonMap['data'] != null) {
      for (Map<String, dynamic> json in jsonMap['data']) {
        eventSeatsList.add(EventSeats.fromJson(json));
      }
    }
  }

  bool status;
  String error;
  List<EventSeats> eventSeatsList;
}
