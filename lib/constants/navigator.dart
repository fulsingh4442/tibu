import 'package:club_app/logic/models/add_on_model.dart';
import 'package:club_app/logic/models/cart_table_event_model.dart';
import 'package:club_app/logic/models/event_model.dart';
import 'package:club_app/logic/models/notification_model.dart';
import 'package:club_app/logic/models/tables_model.dart';
import 'package:club_app/ui/screens/bookings/bookings.dart';
import 'package:club_app/ui/screens/event_booking.dart';
import 'package:club_app/ui/screens/event_details.dart';
import 'package:club_app/ui/screens/guest_list.dart';
import 'package:club_app/ui/screens/landing.dart';
import 'package:club_app/ui/screens/login.dart';
import 'package:club_app/ui/screens/notification.dart';
import 'package:club_app/ui/screens/profile/profile_screen.dart';
import 'package:club_app/ui/screens/qrcode/qr_code_screen.dart';
import 'package:club_app/ui/screens/select_branch.dart';
import 'package:club_app/ui/screens/table/add_on.dart';
import 'package:club_app/ui/screens/table/table_cart.dart';
import 'package:club_app/ui/screens/table/table_new.dart';
import 'package:flutter/material.dart';

class AppNavigator {
  static void gotoLanding(BuildContext context) {
    final Route<LandingScreen> route = MaterialPageRoute<LandingScreen>(
        settings: RouteSettings(name: '/landing'),
        builder: (BuildContext context) => LandingScreen());
    Navigator.pushReplacement(context, route);
  }

  static void gotoLogin(
      BuildContext context, String type, EventModel eventModel) {
    final Route<LoginScreen> route = MaterialPageRoute<LoginScreen>(
        settings: RouteSettings(name: '/login'),
        builder: (BuildContext context) =>
            LoginScreen(type, eventModel: eventModel));
    Navigator.pushReplacement(context, route);
  }

  static void gotoEventDetails(BuildContext context, EventModel eventModel) {
    final Route<EventDetailsScreen> route =
        MaterialPageRoute<EventDetailsScreen>(
            settings: RouteSettings(name: '/event_details'),
            builder: (BuildContext context) => EventDetailsScreen(eventModel));
    Navigator.push(context, route);
  }

  static void gotoTableNewScreen(BuildContext context) {
    final Route<TableNewScreen> route = MaterialPageRoute<TableNewScreen>(
        settings: RouteSettings(name: '/tableNewScreen'),
        builder: (BuildContext context) => TableNewScreen());
    Navigator.push(context, route);
  }

  static void gotoBookEvent(BuildContext context, EventModel eventModel) {
    final Route<EventBookingScreen> route =
        MaterialPageRoute<EventBookingScreen>(
            settings: RouteSettings(name: '/event_booking'),
            builder: (BuildContext context) => EventBookingScreen(eventModel));
    Navigator.pushReplacement(context, route);
  }

  static void gotoNotification(BuildContext context) {
    final Route<NotificationScreen> route =
        MaterialPageRoute<NotificationScreen>(
            settings: RouteSettings(name: '/notifications'),
            builder: (BuildContext context) => NotificationScreen());
    Navigator.push(context, route);
  }

  static void gotoGuestList(BuildContext context) {
    final Route<GuestList> route = MaterialPageRoute<GuestList>(
        settings: RouteSettings(name: '/guest_list'),
        builder: (BuildContext context) => GuestList());
    Navigator.push(context, route);
  }

  static void gotoSelectVenue(BuildContext context) {
    final Route<GuestList> route = MaterialPageRoute<GuestList>(
        settings: RouteSettings(name: '/select_venue'),
        builder: (BuildContext context) => SelectBranchScreen());
    Navigator.push(context, route);
  }

  static void gotoTableCart(BuildContext context,
      List<TableCartModel> cartTable, List<EventCartModel> eventTable) {
    final Route<TableCart> route = MaterialPageRoute<TableCart>(
        settings: RouteSettings(name: '/table_cart'),
        builder: (BuildContext context) => TableCart(false));
    Navigator.push(context, route);
  }

  static void gotoAddOns(BuildContext context) {
    final Route<AddOns> route = MaterialPageRoute<AddOns>(
        settings: RouteSettings(name: '/add_ons'),
        builder: (BuildContext context) => AddOns());
    Navigator.push(context, route);
  }

  static void gotoBookings(BuildContext context) {
    final Route<BookingScreen> route = MaterialPageRoute<BookingScreen>(
        settings: RouteSettings(name: '/bookings'),
        builder: (BuildContext context) => BookingScreen());
    Navigator.push(context, route);
  }

  static void gotoAddGuestList(BuildContext context) {
    final Route<BookingScreen> route = MaterialPageRoute<BookingScreen>(
        settings: RouteSettings(name: '/bookings'),
        builder: (BuildContext context) => BookingScreen());
    Navigator.push(context, route);
  }

  static void gotoQrCodeScreen(BuildContext context,
      {String bookingUid, String appBarTitle, String bookingTitle}) {
    final Route<QRCodeScreen> route = MaterialPageRoute<QRCodeScreen>(
        settings: RouteSettings(name: '/qr_code'),
        builder: (BuildContext context) =>
            QRCodeScreen(bookingUid, appBarTitle, bookingTitle));
    Navigator.push(context, route);
  }

  static void gotoProfileScreen(BuildContext context) {
    final Route<ProfileScreen> route = MaterialPageRoute<ProfileScreen>(
        settings: RouteSettings(name: '/profile'),
        builder: (BuildContext context) => ProfileScreen());
    Navigator.push(context, route);
  }
}
