// To parse this JSON data, do
//
//     final checkout = checkoutFromJson(jsonString);

import 'dart:convert';

CheckoutModel checkoutFromJson(String str) =>
    CheckoutModel.fromJson(json.decode(str));

String checkoutToJson(CheckoutModel data) => json.encode(data.toJson());

class CheckoutModel {
  CheckoutModel({
    this.status,
    this.error,
    this.data,
  });

  bool status;
  String error;
  CheckoutData data;

  factory CheckoutModel.fromJson(Map<String, dynamic> json) => CheckoutModel(
        status: json["status"],
        error: json["error"],
        data: CheckoutData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "error": error,
        "data": data.toJson(),
      };
}

class CheckoutData {
  CheckoutData({
    this.orderId,
    this.guestId,
    this.cartGuestId,
  });

  String orderId;
  int guestId;
  String cartGuestId;

  factory CheckoutData.fromJson(Map<String, dynamic> json) => CheckoutData(
        orderId: json["order_id"],
        guestId: json["guest_id"],
        cartGuestId: json["cart_guest_id"],
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "guest_id": guestId,
        "cart_guest_id": cartGuestId,
      };
}
