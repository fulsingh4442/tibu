import 'package:flutter/material.dart';

class Advertise {
  Advertise.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    link = json['link'];
    companyName = json['company_name'];
    companyEmail = json['company_email'];
    companyPhone = json['company_phone'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    status = json['status'];
    priority = json['priority'];

    if (startDate != null && startDate.isNotEmpty) {
      try {
        advertiseStartDate = DateTime.parse(startDate);
      } catch (e) {
        debugPrint('Advertise Start Date format exception $e');
      }
    }

    if (endDate != null && endDate.isNotEmpty) {
      try {
        advertiseEndDate = DateTime.parse(endDate);
      } catch (e) {
        debugPrint('Advertise End Date format exception $e');
      }
    }
  }

  int id;
  String name;
  String image;
  String link;
  String companyName;
  String companyEmail;
  String companyPhone;
  String startDate;
  DateTime advertiseStartDate;
  String endDate;
  DateTime advertiseEndDate;
  int status;
  int priority;
}
