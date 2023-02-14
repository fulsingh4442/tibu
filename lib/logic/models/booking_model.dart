enum BookingType { Voucher, GuestList, Table, Ticket }

class Booking {
  String title;
  String description;
  DateTime date;
  DateTime bookedDate;
  int bookingAmount;
  BookingType type;

  Booking({
    this.title,
    this.description,
    this.date,
    this.bookedDate,
    this.bookingAmount,
    this.type,
  });
}
