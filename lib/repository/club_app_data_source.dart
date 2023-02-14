import 'dart:typed_data';

import 'package:flutter/material.dart';

abstract class ClubAppDataSource {
  void loginUser(String username, String password);

  void signUpUser(String name, String lastName, String email, String password,
      String confirmPassword, String gender, String phone, String dob, Uint8List data);

  void getEvents(
      {String startDate = '',
      String endDate = '',
      int page = -1,
      int volume = 10});

  void getEventsSeats(int eventId);

  void getEventsSeatsAvailability(int eventSeatId);

  void getVouchers({int page = 1, int volume = 10, String type = ''});

  void loginGoogleUser(String email, String firstName, String lastName);

  void updateGuestList(String name, String email, String phoneNumber,
      int menCount, int womenCount, String registerDate, String referenceName, String notes);

  void fetchTableCartList(String userId);

  void fetchBookings(String userId);

  void fetchAddOnList();

  void fetchBiddingList();

  void updateBid(List<Map<String, dynamic>> bidList);

  void getUserProfile(String userId);

  void updateUserProfile(String userId, String name, String lastName, String gender,
      String nationality, String phone, String email, Uint8List imgData);

  void registerDeregisterToken(String token, int guestId, bool isRegister);

  void getUserBookings(String userId);

  void checkoutEventBookings(
      String userId, int eventId, List<Map<String, dynamic>> eventCategory);

  void checkoutVoucherBookings(String userId, List<int> vouchers);

  void checkoutTableBookings(String userId, List<Map<String, dynamic>> daybed);

  void forgetPassword(String email);

  void verify(String bookingUid);

  void getNotifications(
      {@required String userId, @required int page, int volume = 10});

  void getCategory();
  
  void getProfileAccess(String email,String access_key);

}
