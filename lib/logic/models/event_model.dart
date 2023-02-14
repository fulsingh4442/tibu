import 'package:club_app/constants/strings.dart';
import 'package:flutter/material.dart';

class EventModel {
  EventModel.fromJson(Map<String, dynamic> json) {
    eventId = json['id'];
    eventTitle = json['name'];
    eventShortDescription = json['description'];
    eventLongDescription = json['description'];
    eventDate = json['start_date'];
    eventDeadline = json['deadline'];
    eventImage = json['thumbnail'];
    print(json['thumbnail']);
    if (eventDate != null && eventDate.isNotEmpty) {
      try {
        eventStartDate = DateTime.parse(eventDate);
      } catch (e) {
        debugPrint('Event Start Date format exception $e');
      }
    }

    if (eventDeadline != null && eventDeadline.isNotEmpty) {
      try {
        eventEndDate = DateTime.parse(eventDeadline);
      } catch (e) {
        debugPrint('Event End Date format exception $e');
      }
    }

    seatList = <EventSeats>[];
    if (json['seats'] != null) {
      for (Map<String, dynamic> jsonSeats in json['seats']) {
        seatList.add(EventSeats.fromJson(jsonSeats));
      }
    }

    if (json.containsKey('artist')) {
      eventArtist = EventArtist.fromJson(json['artist']);
    }

    if (json.containsKey('contact')) {
      eventContact = EventContact.fromJson(json['contact']);
    }
  }

  EventModel(
      this.eventId,
      this.eventTitle,
      this.eventShortDescription,
      this.eventLongDescription,
      this.eventDate,
      this.eventImage,
      this.seatList);

  int eventId;
  String eventTitle;
  String eventShortDescription;
  String eventLongDescription;
  String eventDate;
  String eventDeadline;
  String eventImage;
  DateTime eventStartDate;
  DateTime eventEndDate;
  List<EventSeats> seatList;
  EventArtist eventArtist;
  EventContact eventContact;
}

class EventSeats {
  EventSeats.fromJson(Map<String, dynamic> json) {
    seatId = json['id'];
    seatLabel = json['name'];
    rate = json['rate'];
    currency = ClubApp.currencyLbl;
    seatDescription = json['description'];
    capacity = json['capacity'];
    remaining = json['remaining'];
  }

  int seatId;
  String seatLabel;
  int rate;
  String currency;
  String seatDescription;
  int capacity;
  int remaining;
  int quantity = 0;
}

class EventArtist {
  EventArtist.fromJson(Map<String, dynamic> json) {
    artistId = json['id'];
    artistName = json['name'];
    artistDescription = json['description'];
    artistImage = json['thumbnail'];
  }

  int artistId;
  String artistName;
  String artistDescription;
  String artistImage;
}

class EventContact {
  EventContact.fromJson(Map<String, dynamic> json) {
    contactEmail = json['email'];
    contactPhone = json['phone'];
  }

  String contactEmail;
  String contactPhone;
}
