// To parse this JSON data, do
//
//     final bookingModel = bookingModelFromJson(jsonString);

import 'dart:convert';

import 'package:club_app/constants/strings.dart';
import 'package:club_app/remote/api_client.dart';

BookingModel bookingModelFromJson(String str) =>
    BookingModel.fromJson(json.decode(str));

class BookingModel {
  BookingModel({
    this.result,
  });

  List<List<Result>> result;

  factory BookingModel.fromJson(Map<String, dynamic> json) => BookingModel(
        result: List<List<Result>>.from(json["result"]
            .map((x) => List<Result>.from(x.map((x) => Result.fromJson(x))))),
      );
}

class Result {
  Result({
    this.event,
    this.total,
    this.table,
  });

  Event event;
  int total;
  Table table;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        event: json["event"] == null ? null : Event.fromJson(json["event"]),
        total: json["total"],
        table: json["table"] == null ? null : Table.fromJson(json["table"]),
      );
}

class Event {
  Event(
      {this.id,
      this.eventId,
      this.eventSubId,
      this.guestId,
      this.date,
      this.rate,
      this.quantity,
      this.total,
      this.transactionId,
      this.createdAt,
      this.uid,
      this.bookingUid,
      this.updatedAt,
      this.isPaid,
      this.firstName,
      this.lastName,
      this.status,
      this.email,
      this.addon,
        this.total_amount,
        this.paid_amount,
      this.qrcode,
        this.name,
        this.sub_name,

      });

  String id;
  String eventId;
  String eventSubId;
  String guestId;
  DateTime date;
  String rate;
  String quantity;
  String total;
  String transactionId;
  DateTime createdAt;
  String uid;
  String bookingUid;
  DateTime updatedAt;
  String isPaid;
  String firstName;
  String lastName;
  String status;
  String email;

  double total_amount;
  double paid_amount;

  List<Addon> addon;
  String qrcode;
  String name;
  String sub_name;

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json["id"],
      eventId: json["event_id"],
      eventSubId: json["event_sub_id"],
      guestId: json["guest_id"],
      date: DateTime.parse(json["date"]),
      rate: json["rate"],
      quantity: json["quantity"],
      total: json["total"],
      transactionId: json["transaction_id"],
      createdAt: DateTime.parse(json["created_at"]),
      uid: json["uid"],
      bookingUid: json["booking_uid"],
      updatedAt: DateTime.parse(json["updated_at"]),
      isPaid: json["is_paid"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      status: json["status"],
      email: json["email"],
      addon: List<Addon>.from(
        json["addon"].map((x) => Addon.fromJson(x)),
      ),
      qrcode: json["qrcode"],
      total_amount: json.keys.contains("total_amount") ? json["total_amount"] == null ? 0 : double.parse(json["total_amount"] as String) : 0,
      paid_amount: json.keys.contains("paid_amount") ? json["paid_amount"] == null ? 0 : double.parse(json["paid_amount"] as String) : 0,
      name: json.keys.contains("name") ? json["name"] == null ? "" : json["name"] : "",
      sub_name: json.keys.contains("sub_name") ? json["sub_name"] == null ? "" : json["sub_name"] : "",
    );
  }
}

class Addon {
  Addon({
    this.total,
    this.rate,
    this.quantity,
    this.name,
    this.id,
    this.baseRate,
    this.description,
    this.thumbnail,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.currency,
    this.priority,
    this.type,
  });

  String total;
  String rate;
  String quantity;
  String name;
  String id;
  String baseRate;
  String description;
  String thumbnail;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  String currency;
  String priority;
  String type;

  factory Addon.fromJson(Map<String, dynamic> json) => Addon(
        total: json["total"],
        rate: json["rate"],
        quantity: json["quantity"],
        name: json["name"],
        id: json["id"],
        baseRate: json["base_rate"],
        description: json["description"],
        thumbnail: json["thumbnail"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        currency: ClubApp.currencyLbl,
        priority: json["priority"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "rate": rate,
        "quantity": quantity,
        "name": name,
        "id": id,
        "base_rate": baseRate,
        "description": description,
        "thumbnail": thumbnail,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "currency": currency,
        "priority": priority,
        "type": type,
      };
}

class Table {
  Table({
    this.id,
    this.bookingUid,
    this.guestId,
    this.date,
    this.finalRate,
    this.paymentId,
    this.category,
    this.unit,
    this.firstName,
    this.lastName,
    this.status,
    this.email,
    this.noOfGuest,
    this.addon,
    this.qrcode,
    this.total_amount,
    this.paid_amount,
  });

  String id;
  String bookingUid;
  String guestId;
  DateTime date;
  String finalRate;
  String paymentId;
  String category;
  String unit;
  String firstName;
  String lastName;
  String status;
  String email;
  String noOfGuest;
  double total_amount;
  double paid_amount;

  List<dynamic> addon;
  String qrcode;

  factory Table.fromJson(Map<String, dynamic> json) => Table(
        id: json["id"],
        bookingUid: json["booking_uid"],
        guestId: json["guest_id"],
        date: DateTime.parse(json["date"]),
        finalRate: json["final_rate"],
        paymentId: json["payment_id"],
        category: json["category"],
        unit: json["unit"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        status: json["status"],
        email: json["email"],
        noOfGuest: json["no_of_guest"],
        addon: List<dynamic>.from(json["addon"].map((x) => x)),
        qrcode: json["qrcode"],
        total_amount: json.keys.contains("total_amount") ? json["total_amount"] == null ? 0 : double.parse(json["total_amount"] as String) : 0,
        paid_amount: json.keys.contains("paid_amount") ? json["paid_amount"] == null ? 0 : double.parse(json["paid_amount"] as String) : 0,

  );
}
