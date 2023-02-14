class NotificationsResponse{
  NotificationsResponse.fromJson(Map jsonMap) {
    status = jsonMap['status'];
    error = jsonMap['error'];

    notifications = <Notifications>[];
    if (jsonMap['data'] != null) {
      for (Map<String, dynamic> json in jsonMap['data']) {
        notifications.add(Notifications.fromJson(json));
      }
    }

  }
  bool status;
  String error;
  List<Notifications> notifications;
}

class Notifications{
  Notifications.fromJson(Map jsonMap){
    content = jsonMap['content'];
    date = jsonMap['date'];
  }

  String content;
  String date;
}