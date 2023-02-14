class BookingEvent {
  BookingEvent.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    startDate = map['start_date'];
    rate = map['rate'];
    quantity = map['quantity'];
    total = map['total'];
    bookingUid = map['booking_uid'];
    eventName = map['event_name'];
    subName = map['sub_name'];
    subCurrency = map['sub_currency'];
    qrcode = map['qrcode'];
  }

  int id;
  String startDate;
  int rate;
  int quantity;
  int total;
  String bookingUid;
  String eventName;
  String subName;
  String subCurrency;
  String qrcode;
}
