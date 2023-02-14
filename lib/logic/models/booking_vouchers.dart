class BookingVouchers {

  BookingVouchers.fromJson(Map<String, dynamic> map){
    id = map['id'];
    currency = map['currency'];
    startDate = map['start_date'];
    endDate = map['end_date'];
    vouchersId = map['vouchers_id'];
    quantity = map['quantity'];
    price = map['price'];
    total = map['total'];
    transactionId = map['transaction_id'];
    name = map['name'];
    bookingUid = map['booking_uid'];
    updatedAt = map['updated_at'];
  }

  int id;
  String currency;
  String startDate;
  String endDate;
  String vouchersId;
  int quantity;
  int price;
  int total;
  String transactionId;
  String name;
  String bookingUid;
  String updatedAt;
}
