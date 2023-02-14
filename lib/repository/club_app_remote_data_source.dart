import 'dart:io';
import 'dart:typed_data';

import 'package:club_app/remote/api_client.dart';
import 'package:club_app/repository/club_app_data_source.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ClubAppRemoteDataSource extends ClubAppDataSource {
  ApiClient apiClient = ApiClient();

  @override
  Future<Response> loginUser(String username, String password) async {
    return apiClient.loginUser(username, password);
  }

  Future<Response> loginGoogleUser(
      String email, String firstName, String lastName) {
    return apiClient.loginGoogleUser(email, firstName, lastName);
  }

  @override
  Future<Response> signUpUser(String name, String lastName, String email, String password,
      String confirmPassword, String gender, String phone, String dob, Uint8List data) async {
    return apiClient.signUpUser(
        name, lastName, email, password, confirmPassword, gender, phone, dob, data);
  }

  @override
  Future<Response> getEvents(
      {String startDate = '',
      String endDate = '',
      int page = -1,
      int volume = 10}) async {
    return apiClient.getEvents(
        startDate: startDate, endDate: endDate, page: page, volume: volume);
  }

  @override
  Future<Response> getCurrency() async {
    return apiClient.getCurrency();
  }

  @override
  Future<Response> getEventsSeats(int eventId) async {
    return apiClient.getEventsSeats(eventId);
  }

  @override
  Future<Response> getEventsSeatsAvailability(int eventSeatId) async {
    return apiClient.getEventsSeatsAvailability(eventSeatId);
  }

  Future<Response> getVouchers(
      {int page = 1, int volume = 10, String type = ''}) {
    return apiClient.getVouchers(page: page, volume: volume, type: type);
  }

  @override
  Future<Response> updateGuestList(String name, String email,
      String phoneNumber, int menCount, int womenCount, String registerDate, String referenceName, String notes) {
    return apiClient.updateGuestList(
        name, email, phoneNumber, menCount, womenCount, registerDate, referenceName, notes);
  }

  Future<Response> getDisabledGuestDates() {
    return apiClient.getDisabledGuestDates();
  }

  Future<Response> addToCart(int eventId, int guestId, int quantity) {
    return apiClient.addToCart(eventId, guestId, quantity);
  }

  Future<Response> addAddonToCart(
      int addonId, String cartIds, int quantity, String addOnFor) {
    return apiClient.addAddonToCart(addonId, cartIds, quantity, addOnFor);
  }
  Future<Response> updateAddonToCart(
      int addonId, int quantity) {
    return apiClient.updateAddonToCart(addonId, quantity);
  }

  Future<Response> deleteCartItem(String type, int guestId) {
    return apiClient.deleteCartItem(type, guestId);
  }

  Future<Response> deleteAddonfromCart(int addonCartId) {
    return apiClient.deleteAddonfromCart(addonCartId);
  }

  Future<Response> deleteAddonfromList(int addonId) {
    return apiClient.deleteAddonfromList(addonId);
  }

  Future<Response> deleteTablefromCart(int tableId) {
    return apiClient.deleteTablefromCart(tableId);
  }

  Future<Response> deleteEventfromCart(int eventId) {
    return apiClient.deleteEventfromCart(eventId);
  }

  @override
  Future<Response> fetchTableCartList(String userId) {
    return apiClient.getTableCartList(userId);
  }

  @override
  Future<Response> fetchCartList(String userId) {
    return apiClient.getCartList(userId);
  }

  @override
  Future<Response> fetchAddOnList() {
    return apiClient.getAddOnList();
  }

  @override
  Future<Response> fetchBiddingList() {
    return apiClient.fetchBiddingList();
  }

  @override
  Future<Response> updateBid(List<Map<String, dynamic>> bidList) {
    return apiClient.updateBid(bidList);
  }

  Future<Response> getUserProfile(String userId) {
    return apiClient.getUserProfile(userId);
  }

  Future<Response> getStripeKeys() {
    return apiClient.getStripeKeys();
  }

  Future<Response> updateUserProfile(String userId, String name, String lastName, String gender,
      String nationality, String phone, String email, Uint8List imgData) {
    return apiClient.updateUserProfile(
        userId, name, lastName, gender, nationality, phone, email, imgData);
  }

  Future<Response> createPayment(String userId, String name, String email,
      String phone, String rate, String paymentMethod) {
    return apiClient.createPayment(
        userId, name, email, phone, rate, paymentMethod);
  }

  Future<Response> completePayment(
    String expectedArrival,
    String name,
    String currency,
    String email,
    String amount,
    String balanceTransaction,
    String orderId,
    String guestId,
    String cartGuestId,
    String status,
  ) {
    return apiClient.completePayment(
      expectedArrival,
      name,
      currency,
      email,
      amount,
      balanceTransaction,
      orderId,
      guestId,
      cartGuestId,
      status,
    );
  }

  Future<Response> registerDeregisterToken(
      String token, int guestId, bool isRegister) {
    return apiClient.registerDeregisterToken(token, guestId, isRegister);
  }

  Future<Response> getUserBookings(String userId) {
    return apiClient.getUserBookings(userId);
  }

  @override
  Future<Response> checkoutEventBookings(String userId, int eventId,
      List<Map<String, dynamic>> eventCategory) async {
    return apiClient.checkoutEventBookings(userId, eventId, eventCategory);
  }

  @override
  Future<Response> checkoutTableBookings(
      String userId, List<Map<String, dynamic>> daybed) async {
    return apiClient.checkoutTableBookings(userId, daybed);
  }

  @override
  Future<Response> checkoutVoucherBookings(
      String userId, List<int> vouchers) async {
    return apiClient.checkoutVoucherBookings(userId, vouchers);
  }

  @override
  Future<Response> forgetPassword(String email) async {
    return apiClient.forgetPassword(email);
  }

  @override
  Future<Response> verify(String bookingUid) async {
    return apiClient.verify(bookingUid);
  }

  Future<Response> getNotifications(
      {@required String userId, @required int page, int volume = 10}) {
    return apiClient.getNotifications(
        userId: userId, page: page, volume: volume);
  }

  @override
  Future<Response> fetchBookings(String userId) {
    return apiClient.fetchBookings(userId);
  }

  @override
  Future<Response> getCategory() {
    return apiClient.getCategory();
  }
  
  @override
   Future<Response> getProfileAccess(String email, String accessKey) {
    return apiClient.getProfileAccess(email, accessKey);
  }
}
