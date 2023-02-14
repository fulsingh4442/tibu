import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:club_app/constants/strings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Class is used for call all api's and return response.
class ApiClient {
  String accessToken;

  Future<Response> loginUser(String username, String password) async {
    var myTOken = "";
    await FirebaseMessaging.instance.getToken().then((value) {
      myTOken = value;
    });
    Map<String, dynamic> body = <String, dynamic>{
      'email': username,
      'password': password,
      'device_id': myTOken
    };
    debugPrint('Calling login user api ${ClubApp().url_login} with body $body');
    final Response response =
        await http.post(Uri.parse(ClubApp().url_login), body: body);
    return response;
  }

  Future<Response> loginGoogleUser(
      String email, String firstName, String lastName) async {
    Map<String, dynamic> body = <String, dynamic>{
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'gkey': ClubApp.GOOGLE_LOGIN_KEY
    };
    debugPrint(
        'Calling Google login user api ${ClubApp().url_login} with body $body');
    final Response response =
        await http.post(Uri.parse(ClubApp().url_login), body: body);
    return response;
  }
/* /// Detail : Api for Upload User Profile.
  Future<UserProfileModel?> uploadUserProfile(XFile file) async {
    try {
      dynamic response;

      String finalUrl = NetworkConstant.baseUrl + NetworkConstant.uploadProfilePicture;
      var postUri = Uri.parse(finalUrl);
      var request = http.MultipartRequest("POST", postUri);
      final fileInt = File(file.path).readAsBytesSync();
      try {
        var multipartFile =
        http.MultipartFile.fromBytes(NetworkParamConstants.image, fileInt, filename: file.name);
        request.files.add(multipartFile);
      } catch (e) {
        print('No Internet connection');
      }
      Map<String, String> headers = getHeader();
      request.headers.addAll(headers);
      response = await request.send();
      response = await http.Response.fromStream(response);
      final d = response as http.Response;
      final userProfileModel = UserProfileModel.fromJson(jsonDecode(d.body));
      return userProfileModel;
    } on SocketException {
       print('No Internet connection');
    } catch (e) {
      print(e);
    }
    return null;
  }*/


  Future<Response> signUpUser(String name, String lastName, String email, String password,
      String confirmPassword, String gender, String phone, String dob, Uint8List data) async {
    String firstName = name;
    // List<String> nameArray = name.split(' ');
    // if (nameArray.length > 1) {
    //   firstName = nameArray[0];
    //   lastName = '';
    //   for (int i = 1; i < nameArray.length; i++) {
    //     lastName = lastName + ' ' + nameArray[i];
    //   }
    // }
    Map<String, dynamic> body = <String, dynamic>{
//      'name': name,
      'first_name': firstName.trim(),
      'last_name': lastName.trim(),
      'email': email,
      'password': password,
      'password-confirm': confirmPassword,
      'gender': gender == 'Male' ? '1' : '2',
      'phone': phone,
      'dob': dob
    };
    debugPrint(
        'Calling sign up user api ${ClubApp().url_sign_up} with body $body');

    var postUri = Uri.parse(ClubApp().url_sign_up);
    var request = http.MultipartRequest("POST", postUri);
    try {
      if (data.isNotEmpty) {
        var multipartFile =
        http.MultipartFile.fromBytes("photo", data, filename: "photo.png");
        request.files.add(multipartFile);
      }
    } catch (e) {
      print('No Internet connection');
    }

    request.fields["first_name"] = firstName.trim();
    request.fields["last_name"] = lastName.trim();
    request.fields["email"] = email;
    request.fields["password"] = password;
    request.fields["password-confirm"] = confirmPassword;
    request.fields["gender"] = gender == 'Male' ? '1' : '2';
    request.fields["phone"] = phone;
    request.fields["dob"] = dob;

    dynamic response =
        await request.send();
    response = await http.Response.fromStream(response);
    final d = response as http.Response;
    print("response is ${d}");
    return d;
  }

  Future<Response> getEvents(
      {String startDate = '',
      String endDate = '',
      int page = 1,
      int volume = 10}) async {
    /*final SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString(ClubApp().access_token);*/

    Map<String, dynamic> body = <String, dynamic>{
      'start_date': startDate,
      'end_date': endDate,
      'page': page,
      'volume': volume
    };

    //final Uri uriGetEvents = Uri.https(ClubApp().url_get_events), body.toString());
    debugPrint(
        'Calling get events api ------------------- ${ClubApp().url_get_events}' +
            '?page=$page&volume=$volume');
    final Response response = await http.get(Uri.parse(
      ClubApp().url_get_events + '?page=$page&volume=$volume',
      /*headers: {
        'Authorization': 'Bearer ' + accessToken,
        'Content-Type': 'application/x-www-form-urlencoded',
      },*/
    ));
    print(response);
    return response;
  }

  Future<Response> getCurrency() async {
    debugPrint(
        'Calling get currency api ------------------- ${ClubApp().url_get_currency}');
    final Response response =
        await http.get(Uri.parse(ClubApp().url_get_currency));
    return response;
  }

  Future<Response> getEventsSeats(int eventId) async {
    /*final Uri uriGetEventSeats =
        Uri.https(ClubApp().url_get_event_seats, eventId.toString());*/
    print("eventId $eventId");
    debugPrint('Calling get event seats api ' +
        ClubApp().url_get_event_seats +
        eventId.toString());
    final Response response = await http.get(Uri.parse(
      ClubApp().url_get_event_seats + eventId.toString(),
    ));
    return response;
  }

  Future<Response> getEventsSeatsAvailability(int eventSeatId) async {
    final Uri uriGetEventSeatAvailability = Uri.https(
        ClubApp().url_get_event_seats_available, eventSeatId.toString());
    debugPrint('Calling get event seats api $uriGetEventSeatAvailability');
    final Response response = await http.get(uriGetEventSeatAvailability);
    return response;
  }

  Future<Response> getVouchers(
      {int page = 1, int volume = 10, String type = ''}) async {
    /*final SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString(ClubApp().access_token);*/

    //final Uri uriGetEvents = Uri.https(ClubApp().url_get_events), body.toString());
    debugPrint('Calling get vouchers api ${ClubApp().url_get_vouchers}' +
        '?page=$page&volume=$volume&type=$type');
    final Response response = await http.get(Uri.parse(
      ClubApp().url_get_vouchers + '?page=$page&volume=$volume',
      /*headers: {
        'Authorization': 'Bearer ' + accessToken,
        'Content-Type': 'application/x-www-form-urlencoded',
      },*/
    ));
    return response;
  }

  Future<Response> getDisabledGuestDates() async {
    final Response response =
    await http.get(Uri.parse(ClubApp().url_disabled_dates));
    return response;
  }

  Future<Response> updateGuestList(
      String name,
      String email,
      String phoneNumber,
      int menCount,
      int womenCount,
      String registerDate,
      String referenceName, String notes) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt(ClubApp.userId);
    Map<String, String> body = <String, String>{
      'name': name,
      'email': email,
      'phone': phoneNumber,
      'guests': menCount.toString(),
      'user_id': userId.toString(),
      'register_date': registerDate,
      // 'women': womenCount.toString(),
      'reference_name': referenceName,
      'notes': notes,
    };
    final Response response =
        await http.post(Uri.parse(ClubApp().url_update_guest_list), body: body);
    return response;
  }

  Future<Response> addToCart(int eventId, int guestId, int quantity) async {
    Map<String, String> body = <String, String>{
      'event_sub_id': eventId.toString(),
      'guest_id': guestId.toString(),
      'quantity': quantity.toString(),
    };
    print(
        " calling add to cart (event) ${ClubApp().add_to_cart} with body $body");
    final Response response =
        await http.post(Uri.parse(ClubApp().add_to_cart), body: body);
    return response;
  }

  Future<Response> addAddonToCart(
      int addonId, String cartIds, int quantity, String addOnFor) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt(ClubApp.userId);
    print("--------data in api-----");
    print("add on id $addonId");
    print("card ids $cartIds");
    print("quantity $quantity");
    Map<String, String> body = <String, String>{
      'addon_id': addonId.toString(),
      'cart_ids': cartIds,
      'quantity': quantity.toString(),
      'addon_for': addOnFor,
      'user_id': userId.toString()
    };
    final Response response =
        await http.post(Uri.parse(ClubApp().add_addon_to_cart), body: body);
    print(
        " calling add aadon api with url ---------  ${ClubApp().add_addon_to_cart} with Body ${body.toString()}");
    return response;
  }
  Future<Response> updateAddonToCart(
      int addonId, int quantity) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt(ClubApp.userId);

    Map<String, String> body = <String, String>{
      'addon_id': addonId.toString(),
      'quantity': quantity.toString(),
      'user_id': userId.toString()
    };
    final Response response =
    await http.post(Uri.parse(ClubApp().update_addon_quatity), body: body);
    print(
        " calling update aadon api with url ---------  ${ClubApp().update_addon_quatity} with Body ${body.toString()}");
    return response;
  }
  Future<Response> deleteCartItem(String type, int guestId) async {
    Map<String, String> body = <String, String>{
      'type': "cart",
      'guest_id': guestId.toString(),
    };
    final Response response =
        await http.post(Uri.parse(ClubApp().remove_from_cart), body: body);
    return response;
  }

  Future<Response> deleteAddonfromCart(int addonCartId) async {
    debugPrint(
        'Calling delete addon from cart api ${ClubApp().remove_addon_from_cart}' +
            addonCartId.toString());
    Map<String, String> body = <String, String>{
      'cart_addon_id': addonCartId.toString(),
    };
    final Response response = await http.post(Uri.parse(
        ClubApp().remove_addon_from_cart), body: body);

    return response;
  }

  Future<Response> deleteAddonfromList(int addonId) async {
    debugPrint(
        'Calling delete addon from cart api ${ClubApp().remove_addon_from_cart}' +
            addonId.toString());
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt(ClubApp.userId);
    Map<String, String> body = <String, String>{
      'addon_id': addonId.toString(),
      'user_id' : userId.toString(),
    };
    final Response response = await http.post(Uri.parse(
        ClubApp().remove_addon_from_cart), body: body);

    return response;
  }

  Future<Response> deleteTablefromCart(int tableId) async {
    debugPrint(
        'Calling delete table from cart api ${ClubApp().remove_table_from_cart}' +
            tableId.toString());
    final Response response = await http.get(Uri.parse(
      ClubApp().remove_table_from_cart + tableId.toString(),
    ));
    return response;
  }

  Future<Response> deleteEventfromCart(int eventId) async {
    debugPrint(
        'Calling delete event from cart api ${ClubApp().remove_event_from_cart}' +
            eventId.toString());
    final Response response = await http.get(Uri.parse(
      ClubApp().remove_event_from_cart + eventId.toString(),
    ));
    return response;
  }

  Future<Response> getTableCartList(String userId) async {
    /*final SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString(ClubApp().access_token);*/

    debugPrint(
        'Calling get table cart api (grt table cart list) ----- ${ClubApp().url_get_table_cart_list}' +
            userId);
    final Response response = await http.get(Uri.parse(
      ClubApp().url_get_table_cart_list + userId,
      /*headers: {
        'Authorization': 'Bearer ' + accessToken,
        'Content-Type': 'application/x-www-form-urlencoded',
      },*/
    ));
    return response;
  }

  Future<Response> getCartList(String userId) async {
    /*final SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString(ClubApp().access_token);*/

    debugPrint(
        'Calling get table cart api (get cart list) ----- ${ClubApp().url_get_table_cart_list}' +
            userId);
    final Response response = await http.get(Uri.parse(
      ClubApp().url_get_table_cart_list + userId,
      /*headers: {
        'Authorization': 'Bearer ' + accessToken,
        'Content-Type': 'application/x-www-form-urlencoded',
      },*/
    ));
    return response;
  }

  Future<Response> getAddOnList() async {
    debugPrint('Calling get add ons api ${ClubApp().url_get_add_ons_list}');
    final Response response = await http.get(Uri.parse(
      ClubApp().url_get_add_ons_list,
      /*headers: {
        'Authorization': 'Bearer ' + accessToken,
        'Content-Type': 'application/x-www-form-urlencoded',
      },*/
    ));
    return response;
  }

  Future<Response> fetchBiddingList() async {
    debugPrint('Calling get bids api ${ClubApp().url_get_bidding_list}');
    final Response response = await http.get(Uri.parse(
      ClubApp().url_get_bidding_list,
      /*headers: {
        'Authorization': 'Bearer ' + accessToken,
        'Content-Type': 'application/x-www-form-urlencoded',
      },*/
    ));
    return response;
  }

  Future<Response> updateBid(List<Map<String, dynamic>> bidList) async {
    final Map<String, String> headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };

    dynamic body = jsonEncode({'bids': bidList});

    debugPrint(
        'Calling update bids api ${ClubApp().url_update_bids} with body $body');

    final Response response = await http.post(
        Uri.parse(ClubApp().url_update_bids),
        body: body,
        headers: headers);
    return response;
  }

  Future<Response> getUserProfile(String userId) async {
    debugPrint(
        'Calling (get user profile) ----- ${ClubApp().url_user_profile}' +
            userId);
    final Response response = await http.get(Uri.parse(
      ClubApp().url_user_profile + userId,
    ));
    return response;
  }

  Future<Response> getStripeKeys() async {
    debugPrint('Calling get stripe keys api ${ClubApp().get_stripe_keys_new}');
    final Response response = await http.get(Uri.parse(
      ClubApp().get_stripe_keys_new,
    ));
    return response;
  }

  Future<Response> updateUserProfile(String userId, String name, String lastName, String gender,
      String nationality, String phone, String email, Uint8List imgData) async {
    String firstName = name;
    // List<String> nameArray = name.split(' ');
    // if (nameArray.length > 1) {
    //   firstName = nameArray[0];
    //   lastName = '';
    //   for (int i = 1; i < nameArray.length; i++) {
    //     lastName = lastName + ' ' + nameArray[i];
    //   }
    // }
    Map<String, dynamic> body = <String, dynamic>{
      'id': userId,
      'first_name': firstName.trim(),
      'last_name': lastName.trim(),
      'email': email,
      'nationality': nationality,
      'gender': gender == 'Male' ? '1' : '2',
      'phone': phone
    };
    debugPrint(
        'Calling update user profile api ${ClubApp().url_update_user_profile} with body $body');
    // final Response response = await http
    //     .post(Uri.parse(ClubApp().url_update_user_profile), body: body);
    // return response;


    var postUri = Uri.parse(ClubApp().url_update_user_profile);
    var request = http.MultipartRequest("POST", postUri);
    try {
      if (imgData.isNotEmpty) {
        var multipartFile =
        http.MultipartFile.fromBytes("photo", imgData, filename: "photo.png");
        request.files.add(multipartFile);
      }
    } catch (e) {
      print('No Internet connection');
    }

    request.fields["id"] = userId;
    request.fields["first_name"] = firstName.trim();
    request.fields["last_name"] = lastName.trim();
    request.fields["email"] = email;
    request.fields["gender"] = gender == 'Male' ? '1' : '2';
    request.fields["phone"] = phone;
    request.fields["nationality"] = nationality;

    dynamic response =
        await request.send();
    response = await http.Response.fromStream(response);
    final d = response as http.Response;
    print("response is ${d}");
    return d;


  }

  Future<Response> createPayment(String userId, String name, String email,
      String phone, String rate, String paymentMethod) async {
    Map<String, dynamic> body = <String, dynamic>{
      'user_id': userId,
      'name': name,
      'email': email,
      'phone': phone,
      'rate': rate,
      'payment_method': paymentMethod
    };
    debugPrint(
        'Calling create payment profile api ---->  ${ClubApp().create_payment} with body $body');
    final Response response =
        await http.post(Uri.parse(ClubApp().create_payment), body: body);
    return response;
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
  ) async {
    Map<String, dynamic> body = <String, dynamic>{
      'expected_arrival': expectedArrival,
      'name': name,
      'currency': currency,
      'email': email,
      'amount': amount,
      'balance_transaction': balanceTransaction,
      'order_id': orderId,
      'guest_id': guestId,
      'cart_guest_id': cartGuestId,
      'status': status,
    };
    debugPrint(
        'Calling Complete payment profile api ---->  ${ClubApp().complete_payment} with body $body');
    final Response response =
        await http.post(Uri.parse(ClubApp().complete_payment), body: body);
    return response;
  }

  Future<Response> registerDeregisterToken(
      String token, int guestId, bool isRegister) async {
    Map<String, dynamic> body = <String, dynamic>{
      'token': token,
      'guest_id': guestId.toString(),
      'register': isRegister.toString(),
    };
    debugPrint(
        'Calling firebase token ${ClubApp().firebase_token} with body $body');
    final Response response =
        await http.post(Uri.parse(ClubApp().firebase_token), body: body);
    return response;
  }

  Future<Response> getUserBookings(String userId) async {
    debugPrint(
        'Calling Get user bookings api ${ClubApp().get_user_bookings}/$userId');
    final Response response = await http.get(Uri.parse(
      '${ClubApp().get_user_bookings}/$userId',
    ));
    return response;
  }

  Future<Response> checkoutEventBookings(String userId, int eventId,
      List<Map<String, dynamic>> eventCategory) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };

    Map<String, dynamic> body = {
      'guest_id': userId,
      'booking_type': 'event',
      'event_id': eventId,
      'event_category': eventCategory
    };

    debugPrint(
        'Calling checkout events ${ClubApp().checkout_user_bookings} with body $body');
    final Response response = await http.post(
        Uri.parse(ClubApp().checkout_user_bookings),
        body: json.encode(body),
        headers: headers);
    return response;
  }

  Future<Response> checkoutTableBookings(
      String userId, List<Map<String, dynamic>> daybed) async {
    Map<String, String> headers = {'Content-Type': 'application/json'};

    Map<String, dynamic> body = {
      'guest_id': userId,
      'booking_type': 'daybed',
      'daybed': daybed,
    };

    debugPrint(
        'Calling checkout table ${ClubApp().checkout_user_bookings} with body $body');
    final Response response = await http.post(
        Uri.parse(ClubApp().checkout_user_bookings),
        body: json.encode(body),
        headers: headers);
    return response;
  }

  Future<Response> checkoutVoucherBookings(
      String userId, List<int> vouchers) async {
    Map<String, String> headers = {'Content-Type': 'application/json'};

    Map<String, dynamic> body = {
      'guest_id': userId,
      'booking_type': 'vouchers',
      'vouchers': vouchers,
    };

    debugPrint(
        'Calling checkout vouchers ${ClubApp().checkout_user_bookings} with body $body');
    final Response response = await http.post(
        Uri.parse(ClubApp().checkout_user_bookings),
        body: json.encode(body),
        headers: headers);
    return response;
  }

  Future<Response> forgetPassword(String email) async {
    Map<String, dynamic> body = <String, dynamic>{
      'email': email,
    };
    debugPrint(
        'Calling forget password API ${ClubApp().api_forget_password} with body $body');
    final Response response =
        await http.post(Uri.parse(ClubApp().api_forget_password), body: body);
    return response;
  }

  Future<Response> verify(String bookingUid) async {
    Map<String, dynamic> body = {
      'booking_uid': bookingUid,
    };

    debugPrint(
        'Calling verify code API ${ClubApp().verify_code} with body $body');
    final Response response =
        await http.post(Uri.parse(ClubApp().verify_code), body: body);
    return response;
  }

  Future<Response> getNotifications(
      {@required String userId, @required int page, int volume = 10}) async {
    String getNotificationsUrl =
        '${ClubApp().get_notifications}/$userId?page=$page&volume=$volume';
    debugPrint('Calling Get notifications api $getNotificationsUrl');
    final Response response = await http.get(Uri.parse(
      getNotificationsUrl,
    ));
    return response;
  }

  Future<Response> fetchBookings(String userId) async {
    debugPrint(
        'Calling get booking  api (grt table cart list) ----- ${ClubApp().url_get_booking_list}' +
            userId);
    final Response response = await http.get(Uri.parse(
      ClubApp().url_get_booking_list + userId,
    ));
    return response;
  }

  //getCategories...
  Future<Response> getCategory() async {
    debugPrint(
        'Calling get category  apiTR ----- ${ClubApp().url_get_categories}');
    final Response response = await http.get(Uri.parse(
      ClubApp().url_get_categories,
    ));
    return response;
  }

  //profile_access...
  Future<Response> getProfileAccess(String email, String access_key) async {
    print("email .... $email");
    print("access_key .... $access_key");

    Map<String, dynamic> body = <String, dynamic>{
      'email': email,
      'access_key': access_key,
    };
    debugPrint(
        'Calling getProfileAccess  apiTR ----- ${ClubApp().url_profile_access}');
    final Response response = await http.post(
        Uri.parse(
          ClubApp().url_profile_access,
        ),
        body: body);
    return response;
  }
}
