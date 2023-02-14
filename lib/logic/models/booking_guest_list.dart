class BookingGuestList {
  BookingGuestList.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    email = map['email'];
    phone = map['phone'];
    men = map['men'];
    women = map['women'];
    referenceName = map['reference_name'];
    notes = map['notes'];
  }

  int id;
  String name;
  String email;
  String phone;
  int men;
  int women;
  String referenceName;
  String notes;
}
