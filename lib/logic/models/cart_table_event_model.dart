// To parse this JSON data, do
//
//     final cartTableEventResponse = cartTableEventResponseFromJson(jsonString);

import 'dart:convert';

import 'package:club_app/constants/strings.dart';
import 'package:flutter/cupertino.dart';

CartTableEventResponse cartTableEventResponseFromJson(String str) =>
    CartTableEventResponse.fromJson(json.decode(str));

String cartTableEventResponseToJson(CartTableEventResponse data) =>
    json.encode(data.toJson());

class CartTableEventResponse {
  CartTableEventResponse({
    this.status,
    this.error,
    this.data,
    this.pay_amount,
    this.total_amount,
  });

  bool status;
  dynamic error;
  Data data;
  double total_amount;
  double pay_amount;


  factory CartTableEventResponse.fromJson(Map<String, dynamic> json) =>
      CartTableEventResponse(
        status: json["status"] == null ? null : json["status"],
        error: json["error"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        total_amount: json.keys.contains("total_amount") ? json["total_amount"] == null ? 0 : double.parse(json["total_amount"] as String) : 0,
        pay_amount: json.keys.contains("pay_amount") ? json["pay_amount"] == null ? 0 : double.parse(json["pay_amount"] as String) : 0,
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "error": error,
        "data": data == null ? null : data.toJson(),
        "pay_amount" : pay_amount == null ? 0 : pay_amount,
        "total_amount" : total_amount == null ? 0 : total_amount,
      };
}

class Data {
  Data({
    this.tables,
    this.events,
  });

  List<TableCartModel> tables;
  List<EventCartModel> events;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        tables: json["tables"] == null
            ? []
            : List<TableCartModel>.from(
                json["tables"].map((x) => TableCartModel.fromJson(x))),
        events: json["events"] == null
            ? []
            : List<EventCartModel>.from(
                json["events"].map((x) => EventCartModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "tables": tables == null
            ? null
            : List<dynamic>.from(tables.map((x) => x.toJson())),
        "events": events == null
            ? null
            : List<dynamic>.from(events.map((x) => x.toJson())),
      };
}

class EventCartModel {
  EventCartModel({
    this.id,
    this.eventId,
    this.name,
    this.eventName,
    this.rate,
    this.date,
    this.holdTime,
    this.thumbnail,
    this.addons,
    this.quantity,
  });

  int id;
  int eventId;
  String name;
  String eventName;
  int rate;
  String date;
  String holdTime;
  String thumbnail;
  List<Addon> addons;
  int quantity;

  factory EventCartModel.fromJson(Map<String, dynamic> json) => EventCartModel(
        id: json["id"] == null ? null : json["id"],
        eventId: json["event_id"] == null ? null : json["event_id"],
        name: json["name"] == null ? null : json["name"],
        eventName: json["event_name"] == null ? null : json["event_name"],
        rate: json["rate"] == null ? null : json["rate"],
        date: json["date"] == null ? null : json["date"],
        holdTime: json["hold_time"] == null ? null : json["hold_time"],
        thumbnail: json["thumbnail"] == null ? null : json["thumbnail"],
        quantity: json["quantity"] == null ? null : json["quantity"],
        addons: json["addons"] == null
            ? []
            : List<Addon>.from(json["addons"].map((x) => Addon.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "event_id": eventId == null ? null : eventId,
        "name": name == null ? null : name,
        "event_name": eventName == null ? null : eventName,
        "rate": rate == null ? null : rate,
        "date": date == null
            ? null
            : date, //"${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "hold_time": holdTime == null ? null : holdTime,
        "thumbnail": thumbnail == null ? null : thumbnail,
        "quantity": quantity == null ? null : quantity,
      };
}

class TableCartModel {
  TableCartModel({
    this.thumbnail,
    this.capacity,
    this.unitId,
    this.categoryId,
    this.id,
    this.date,
    this.tableName,
    this.categoryName,
    this.rate,
    this.currency,
    this.addons,
  });

  String thumbnail;
  int capacity;
  int unitId;
  int categoryId;
  int id;
  String date;
  String tableName;
  String categoryName;
  int rate;
  String currency;
  List<Addon> addons;

  factory TableCartModel.fromJson(Map<String, dynamic> json) => TableCartModel(
        thumbnail: json["thumbnail"] == null ? null : json["thumbnail"],
        capacity: json["capacity"] == null ? null : json["capacity"],
        unitId: json["unit_id"] == null ? null : json["unit_id"],
        categoryId: json["category_id"] == null ? null : json["category_id"],
        id: json["id"] == null ? null : json["id"],
        date: json["date"] == null ? null : json["date"],
        tableName: json["table_name"] == null ? "" : json["table_name"],
        categoryName:
            json["category_name"] == null ? null : json["category_name"],
        rate: json["rate"] == null ? null : json["rate"],
        currency: ClubApp.currencyLbl,
        addons: json["addons"] == null
            ? []
            : List<Addon>.from(json["addons"].map((x) => Addon.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "thumbnail": thumbnail == null ? null : thumbnail,
        "capacity": capacity == null ? null : capacity,
        "unit_id": unitId == null ? null : unitId,
        "category_id": categoryId == null ? null : categoryId,
        "id": id == null ? null : id,
        "date": date == null
            ? null
            : date, //"${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "table_name": tableName == null ? null : tableName,
        "category_name": categoryName == null ? null : categoryName,
        "rate": rate == null ? null : rate,
        "currency": ClubApp.currencyLbl,
        "addons": addons == null
            ? null
            : List<dynamic>.from(addons.map((x) => x.toJson())),
      };
}

class Addon {
  Addon({
    this.id,
    this.addonCartId,
    this.rate,
    this.quantity,
    this.createdAt,
    this.thumbnail,
    this.addonPaymentSkip,
    this.name,
  });

  int id;
  int addonCartId;
  int rate;
  int quantity;
  String createdAt;
  String thumbnail;
  int addonPaymentSkip;
  String name;

  factory Addon.fromJson(Map<String, dynamic> json) =>
      Addon(
        id: json["id"] == null ? null : json["id"],
        addonCartId:
            json["addon_cart_id"] == null ? null : json["addon_cart_id"],
        rate: json["rate"] == null ? null : json["rate"],
        quantity: json["quantity"] == null ? null : json["quantity"],
        createdAt: json["created_at"] == null ? null : json["created_at"],
        thumbnail: json["thumbnail"] == null ? null : json["thumbnail"],
        addonPaymentSkip: json["addon_payment_skip"] == null  ? 0 : json["addon_payment_skip"],
        name: json["name"] == null  ? "" : json["name"]
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "addon_cart_id": addonCartId == null ? null : addonCartId,
        "rate": rate == null ? null : rate,
        "quantity": quantity == null ? null : quantity,
        "created_at": createdAt == null
            ? null
            : createdAt, //"${createdAt.year.toString().padLeft(4, '0')}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}",
        "thumbnail": thumbnail == null ? null : thumbnail,
        "addon_payment_skip": addonPaymentSkip == null ? 0 : addonPaymentSkip,
        "name": name == null ? "" : name
      };
}

enum Currency { USD }

final currencyValues = EnumValues({"USD": Currency.USD});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
