// To parse this JSON data, do
//
//     final cartResponseModel = cartResponseModelFromJson(jsonString);

import 'dart:convert';

CartResponseModel cartResponseModelFromJson(String str) => CartResponseModel.fromJson(json.decode(str));

String cartResponseModelToJson(CartResponseModel data) => json.encode(data.toJson());

class CartResponseModel {
    CartResponseModel({
        this.status,
        this.error,
        this.data,
    });

    bool status;
    dynamic error;
    Data data;

    factory CartResponseModel.fromJson(Map<String, dynamic> json) => CartResponseModel(
        status: json["status"],
        error: json["error"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "error": error,
        "data": data.toJson(),
    };
}

class Data {
    Data({
        this.cart,
        this.events,
    });

    dynamic cart;
    List<Event> events;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        cart: json["cart"],
        events: List<Event>.from(json["events"].map((x) => Event.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "cart": cart,
        "events": List<dynamic>.from(events.map((x) => x.toJson())),
    };
}

class Event {
    Event({
        this.id,
        this.date,
        this.eventId,
        this.holdTime,
        this.guestId,
        this.quantity,
        this.isMobile,
        this.subName,
        this.subRate,
    });

    String id;
    DateTime date;
    String eventId;
    String holdTime;
    String guestId;
    String quantity;
    String isMobile;
    String subName;
    String subRate;

    factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json["id"],
        date: DateTime.parse(json["date"]),
        eventId: json["event_id"],
        holdTime: json["hold_time"],
        guestId: json["guest_id"],
        quantity: json["quantity"],
        isMobile: json["is_mobile"],
        subName: json["sub_name"],
        subRate: json["sub_rate"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "event_id": eventId,
        "hold_time": holdTime,
        "guest_id": guestId,
        "quantity": quantity,
        "is_mobile": isMobile,
        "sub_name": subName,
        "sub_rate": subRate,
    };
}
