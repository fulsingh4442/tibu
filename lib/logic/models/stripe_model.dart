// To parse this JSON data, do
//
//     final stripeResponseModel = stripeResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:club_app/constants/strings.dart';

StripeResponseModel stripeResponseModelFromJson(String str) =>
    StripeResponseModel.fromJson(json.decode(str));

String stripeResponseModelToJson(StripeResponseModel data) =>
    json.encode(data.toJson());

class StripeResponseModel {
  StripeResponseModel({
    this.status,
    this.error,
    this.data,
  });

  bool status;
  String error;
  StripeModel data;

  factory StripeResponseModel.fromJson(Map<String, dynamic> json) =>
      StripeResponseModel(
        status: json["status"],
        error: json["error"],
        data: StripeModel.fromJson(json["data"]),
        // data: List<StripeModel>.from(
        //     json["data"].map((x) => StripeModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "error": error,
        "data": data,
      };
}

class StripeModel {
  StripeModel({
    this.apiKey,
    this.publishableKey,
    this.currency,
    this.status,
  });

  String apiKey;
  String publishableKey;
  String currency;
  String status;

  factory StripeModel.fromJson(Map<String, dynamic> json) => StripeModel(
        apiKey: json["payment"]["api_key"],
        publishableKey: json["payment"]["publishable_key"],
        currency: ClubApp.currencyLbl,
        status: json["currency_code"],
      );

  Map<String, dynamic> toJson() => {
        "api_key": apiKey,
        "publishable_key": publishableKey,
        "currency": currency,
        "currency_code": status,
      };
}
