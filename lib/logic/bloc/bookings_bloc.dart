import 'dart:convert';

import 'package:club_app/constants/strings.dart';
import 'package:club_app/logic/models/booking_event.dart';
import 'package:club_app/logic/models/booking_guest_list.dart';
import 'package:club_app/logic/models/booking_model.dart';
import 'package:club_app/logic/models/booking_model_new.dart';
import 'package:club_app/logic/models/booking_table.dart';
import 'package:club_app/logic/models/booking_vouchers.dart';
import 'package:club_app/repository/club_app_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';

enum BookingState { Busy, NoData, ListRetrieved, AllEventsFetched }
enum TableBookingState { Busy, NoData, ListRetrieved, AllEventsFetched }
enum EventBookingState { Busy, NoData, ListRetrieved, AllEventsFetched }
enum VoucherBookingState { Busy, NoData, ListRetrieved, AllEventsFetched }
enum GuestListBookingState { Busy, NoData, ListRetrieved, AllEventsFetched }

class BookingBloc {
  final ClubAppRepository _repository = ClubAppRepository();
  BehaviorSubject<bool> loaderController = BehaviorSubject<bool>();
  BehaviorSubject<BookingState> bookingsListController =
      BehaviorSubject<BookingState>();
  BehaviorSubject<TableBookingState> tableBookingController =
      BehaviorSubject<TableBookingState>();
  BehaviorSubject<EventBookingState> eventBookingController =
      BehaviorSubject<EventBookingState>();
  BehaviorSubject<VoucherBookingState> vouchersBookingController =
      BehaviorSubject<VoucherBookingState>();
  BehaviorSubject<GuestListBookingState> guestListBookingController =
      BehaviorSubject<GuestListBookingState>();
  List<Booking> bookingList;
  List<BookingTable> tableBookingList;
  List<BookingGuestList> guestBookingList;
  List<BookingVouchers> voucherBookingList;
  List<BookingEvent> eventBookingList;
  BookingModel bookingModel;

  void dispose() {
    loaderController.close();
    bookingsListController.close();
    tableBookingController.close();
    eventBookingController.close();
    vouchersBookingController.close();
    guestListBookingController.close();
  }

  Future<void> fetchDummyBookingList() async {
    debugPrint('In fetchDummyVoucherList');
    Booking booking1 = Booking(
        title: "VIP Table",
        description: 'Includes a bottle of champagne',
        date: DateTime(2020, 7, 30),
        bookedDate: DateTime(2020, 6, 10),
        bookingAmount: 1000,
        type: BookingType.Table);
    Booking booking2 = Booking(
        title: "VIP Table",
        description: 'Includes a bottle of champagne',
        date: DateTime(2020, 7, 10),
        bookedDate: DateTime(2020, 6, 12),
        bookingAmount: 100,
        type: BookingType.Table);

    Booking booking3 = Booking(
        title: "Voucher 1",
        description: 'This is first voucher booking description',
        date: DateTime(2020, 7, 30),
        bookedDate: DateTime(2020, 6, 10),
        bookingAmount: 1000,
        type: BookingType.Voucher);
    Booking booking4 = Booking(
        title: "Voucher 2",
        description: 'This is first voucher booking description',
        date: DateTime(2020, 7, 10),
        bookedDate: DateTime(2020, 6, 12),
        bookingAmount: 100,
        type: BookingType.Voucher);

    Booking booking5 = Booking(
        title: "DJ Tiesto",
        description: 'VIP Entry  ',
        date: DateTime(2020, 7, 30),
        bookedDate: DateTime(2020, 6, 10),
        bookingAmount: 1000,
        type: BookingType.Ticket);
    Booking booking6 = Booking(
        title: "DJ Tiesto",
        description: 'VIP Entry  ',
        date: DateTime(2020, 7, 10),
        bookedDate: DateTime(2020, 6, 12),
        bookingAmount: 100,
        type: BookingType.Ticket);

    Booking booking7 = Booking(
        title: "Guestlist 1",
        description: 'This is first guest booking description',
        date: DateTime(2020, 7, 30),
        bookedDate: DateTime(2020, 6, 10),
        bookingAmount: 1000,
        type: BookingType.GuestList);
    Booking booking8 = Booking(
        title: "Guestlist 2",
        description: 'This is first guest booking description',
        date: DateTime(2020, 7, 10),
        bookedDate: DateTime(2020, 6, 12),
        bookingAmount: 100,
        type: BookingType.GuestList);

    bookingList = <Booking>[];
    bookingList.add(booking1);
    bookingList.add(booking2);
    bookingList.add(booking3);
    bookingList.add(booking4);
    bookingList.add(booking5);
    bookingList.add(booking6);
    bookingList.add(booking7);
    bookingList.add(booking8);

    loaderController.add(true);
    Future.delayed(const Duration(seconds: 3), () {
      debugPrint('In bookings Future delayed');
      loaderController.add(false);
      bookingsListController.add(BookingState.ListRetrieved);
    });
  }

  Future<void> fetchUserBookings() async {
    loaderController.add(true);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int userId = prefs.getInt(ClubApp.userId);

    try {
      _repository.getUserBookings(userId.toString()).then((Response response) {
        debugPrint(
            'User bookings api response is ${json.decode(response.body)}');
        Map<String, dynamic> map = json.decode(response.body);
        if (map['status'] as bool) {
          tableBookingList = <BookingTable>[];
          eventBookingList = <BookingEvent>[];
          voucherBookingList = <BookingVouchers>[];
          guestBookingList = <BookingGuestList>[];

          if (map['data'].containsKey('daybed') &&
              map['data']['daybed'] != null) {
            for (Map<String, dynamic> mapTableBooking in map['data']
                ['daybed']) {
              tableBookingList.add(BookingTable.fromJson(mapTableBooking));
            }
            tableBookingController.add(TableBookingState.ListRetrieved);
          } else {
            tableBookingController.add(TableBookingState.NoData);
          }
          debugPrint('table booking count is ${tableBookingList.length}');

          if (map['data'].containsKey('event') &&
              map['data']['event'] != null) {
            for (Map<String, dynamic> mapEventBooking in map['data']['event']) {
              eventBookingList.add(BookingEvent.fromJson(mapEventBooking));
            }
            eventBookingController.add(EventBookingState.ListRetrieved);
          } else {
            eventBookingController.add(EventBookingState.NoData);
          }
          debugPrint('Event booking count is ${eventBookingList.length}');

          if (map['data'].containsKey('voucher') &&
              map['data']['voucher'] != null) {
            for (Map<String, dynamic> mapVoucherBooking in map['data']
                ['voucher']) {
              voucherBookingList
                  .add(BookingVouchers.fromJson(mapVoucherBooking));
            }
            vouchersBookingController.add(VoucherBookingState.ListRetrieved);
          } else {
            vouchersBookingController.add(VoucherBookingState.NoData);
          }
          debugPrint('Voucher booking count is ${voucherBookingList.length}');

          if (map['data'].containsKey('guestlist') &&
              map['data']['guestlist'] != null) {
            for (Map<String, dynamic> mapGuestListBooking in map['data']
                ['guestlist']) {
              guestBookingList
                  .add(BookingGuestList.fromJson(mapGuestListBooking));
            }
            guestListBookingController.add(GuestListBookingState.ListRetrieved);
          } else {
            guestListBookingController.add(GuestListBookingState.NoData);
          }
          debugPrint('Guest booking count is ${guestBookingList.length}');

          loaderController.add(false);
        }
        loaderController.add(false);
      });
    } catch (error) {
      debugPrint('Fetch user bookings API exception is ${error.toString()}');
      loaderController.add(true);
    }
  }

  Future<void> fetchBookings() async {
    print("inside fetch bookings");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt(ClubApp.userId);
    loaderController.add(true);
    _repository.fetchBookings(userId.toString()).then((Response response) {
      loaderController.add(false);
      // print("fetchtable cart response --------- ${response.body}");
      BookingModel bookingModelResponse =
          BookingModel.fromJson(json.decode(response.body));
      print(' Tablecart api response issss ==> ' + response.body);
      bookingModel = bookingModelResponse;
      print("booking model length ${bookingModel.result.length}");

      

    }).catchError((Object error) {
      loaderController.add(false);
    });
  }
}
