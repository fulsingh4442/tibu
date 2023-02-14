import 'package:club_app/constants/strings.dart';
import 'package:flutter/material.dart';

class VoucherResponse {
  VoucherResponse.fromJson(Map jsonMap) {
    status = jsonMap['status'];
    error = jsonMap['error'];
    total = jsonMap['total'];
    voucherList = <Vouchers>[];

    if (jsonMap['data'] != null) {
      for (Map<String, dynamic> json in jsonMap['data']) {
        voucherList.add(Vouchers.fromJson(json));
      }
    }
  }

  bool status;
  String error;
  List<Vouchers> voucherList;
  int total;
}

class Vouchers {
  Vouchers(
      this.voucherId,
      this.voucherTitle,
      this.voucherDescription,
      this.category,
      this.claimedFor,
      this.valuedUpTo,
      this.voucherClaimStartDate);

  Vouchers.fromJson(Map<String, dynamic> json) {
    voucherId = json['id'];
    voucherTitle = json['name'];
    voucherDescription = json['description'];
    category = json['type'];
    claimedFor = json['normal_price'];
    valuedUpTo = json['price'];
    currency = ClubApp.currencyLbl;
    strVoucherClaimStartDate = json['start_date'];
    strVoucherClaimEndDate = json['end_date'];

    if (strVoucherClaimStartDate != null &&
        strVoucherClaimStartDate.isNotEmpty) {
      try {
        voucherClaimStartDate = DateTime.parse(strVoucherClaimStartDate);
      } catch (e) {
        debugPrint('Vouchers Start Date format exception $e');
      }
    }

    if (strVoucherClaimEndDate != null && strVoucherClaimEndDate.isNotEmpty) {
      try {
        voucherClaimEndDate = DateTime.parse(strVoucherClaimEndDate);
      } catch (e) {
        debugPrint('Vouchers End Date format exception $e');
      }
    }

    quantity = json['quantity'];
    remaining = json['remaining'];
    image = json['image'];
  }

  int voucherId;
  String voucherTitle;
  String voucherDescription;
  String category;
  int claimedFor;
  int valuedUpTo;
  String currency;
  String strVoucherClaimStartDate;
  DateTime voucherClaimStartDate;
  String strVoucherClaimEndDate;
  DateTime voucherClaimEndDate;
  int quantity;
  int remaining;
  String image;
  bool isClaimed = false;
}
