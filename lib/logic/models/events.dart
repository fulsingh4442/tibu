import 'package:club_app/logic/models/advertise.dart';
import 'package:club_app/logic/models/event_model.dart';

class EventsResponse {
  EventsResponse.fromJson(Map jsonMap) {
    status = jsonMap['status'];
    error = jsonMap['error'];
    count = jsonMap['count'];

    eventList = <EventModel>[];
    if (jsonMap['data'] != null) {
      for (Map<String, dynamic> json in jsonMap['data']) {
        eventList.add(EventModel.fromJson(json));
      }
    }

    advertiseList = <Advertise>[];
    if(jsonMap['advertise'] != null){
      for (Map<String, dynamic> json in jsonMap['advertise']) {
        advertiseList.add(Advertise.fromJson(json));
      }
    }
  }

  bool status;
  String error;
  List<EventModel> eventList;
  List<Advertise> advertiseList;
  int count;
}
