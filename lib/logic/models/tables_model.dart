import 'package:club_app/constants/strings.dart';
import 'package:club_app/logic/models/add_on_model.dart';

class TableCartResponse {
  TableCartResponse.fromJson(Map<String, dynamic> jsonMap) {
    status = jsonMap['status'];
    error = jsonMap['error'];
    tableCartList = <TableModel>[];
    if (jsonMap['data'] != null) {
      for (Map<String, dynamic> json in jsonMap['data']) {
        tableCartList.add(TableModel.fromJson(json) );
      }
    }
  }

  bool status;
  String error;
  List<TableModel> tableCartList = [];
}

class TableModel {
  TableModel(this.tableId, this.tableTitle, this.tableImage,
      this.additionalItems, this.guestCapacity, this.price, this.currency,
      {this.addOns, this.unitId});

  TableModel.fromJson(Map<String, dynamic> json) {
    tableId = json['id'];
    unitId = json['unit_id'];
    tableTitle = json['table_name'];
    categoryName = json['category_name'];
    tableImage = json['thumbnail'];
    guestCapacity = json['capacity'] as int;
    price = json['rate'];
    currency = ClubApp.currencyLbl as String;
    bookingDate = json['date'] as String;

    addOns = <AddOnModel>[];
    if (json.containsKey('addon')) {}
  }

  int tableId;
  String tableTitle;
  String categoryName;
  String tableImage;
  String additionalItems;
  int guestCapacity;
  int price;
  String currency;
  String bookingDate;
  int unitId;

  List<AddOnModel> addOns = <AddOnModel>[];
}
