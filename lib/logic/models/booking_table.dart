class BookingTable {
  BookingTable.fromJson(Map<String, dynamic> map) {
    id = map['id'] as int;
    currency = map['currency'] as String;
    category = map['category'] as String;
    unit = map['unit'] as String;
    date = map['date'] as String;
    rate = map['rate'] as int;
    finalRate = map['final_rate'] as int;
    paymentId = map['payment_id'] as String;
    expectedArrival = map['expected_arrival'] as String;
    createdAt = map['created_at'] as String;
    bookingUid = map['booking_uid'] as String;

    tableAddOnList = <TableAddOn>[];
    if (map.containsKey('addon') && map['addon'] != null) {
      for (Map<String, dynamic> addOnMap in map['addon']) {
        tableAddOnList.add(TableAddOn.fromJson(addOnMap));
      }
    }
  }

  int id;
  String currency;
  String category;
  String unit;
  String date;
  int rate;
  int finalRate;
  String paymentId;
  String expectedArrival;
  String createdAt;
  String bookingUid;
  List<TableAddOn> tableAddOnList;
}

class TableAddOn {
  TableAddOn.fromJson(Map<String, dynamic> map) {
    id = map['id'] as int;
    currency = map['currency'] as String;
    quantity = map['quantity'] as int;
    rate = map['rate'] as int;
    date = map['date'] as String;
    transactionId = map['transaction_id'] as String;
    createdAt = map['created_at'] as String;
    bookingUid = map['booking_uid'] as String;
    name = map['name'] as String;
    addOnId = map['addon_id'] as int;
  }

  int id;
  String currency;
  int quantity;
  int rate;
  String date;
  String transactionId;
  String createdAt;
  String bookingUid;
  String name;
  int addOnId;
}
