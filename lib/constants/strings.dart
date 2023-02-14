// ignore_for_file: ant_identifier_names
//old var BASE_URL = 'https://sucasa.bookbeach.club/api/';
var BASE_URL = 'https://sucasa.reserveyourvenue.com/api/';
//var BASE_URL = 'https://tibu.teaseme.co.in/api/';
class ClubApp {
  static String app_name = 'Sucasa';
  static String name = 'Kenjin';


  static String access_token = 'access_token';
  static String access_key = 'access_key';

  static String GOOGLE_LOGIN_KEY = 'F3kpPC8khRNy9u20l2nS5K5FflLQVsOT';

  //https://api.thetwelve25.teaseme.co.in/api/
//  static  String BASE_URL = 'https://oxygenadmin.bookbeachclub.com/api/';
  // static  String BASE_URL = 'https://api.thetwelve25.teaseme.co.in/api/';
  // static  String BASE_URL = 'https://faces-demo.booknbite.com/api/';
  // static  String BASE_URL =
  //     'https://electricgardendemo.booknbite.com/api/';

  //static  String BASE_URL = 'https://sucasa.bookbeach.club/api/';

  // 'https://catch.teaseme.co.in/api/';

  //'https://api.thetwelve25.teaseme.co.in/';
  //'https://api.dream.bookbeachclub.com/api/';
  String url_login = '${BASE_URL}guests/login';
  String url_sign_up = BASE_URL + 'guests/register';
  String url_get_events = BASE_URL + 'events';
  String url_get_currency = BASE_URL + 'settings';
  String url_get_event_seats = BASE_URL + 'events/tickets/';
  String url_get_event_seats_available = BASE_URL + 'events/seat_available/';
  String url_get_vouchers = BASE_URL + 'vouchers';
  String url_disabled_dates = BASE_URL + 'guests/disabled_dates';
  String url_update_guest_list = BASE_URL + 'guests/updateguestlist';
  String url_get_table_cart_list = BASE_URL + 'cart/';
  String url_get_booking_list = BASE_URL + 'booking/userbooking/';
  String url_get_add_ons_list = BASE_URL + 'addon';
  String url_get_bidding_list = BASE_URL + 'bids';
  String url_update_bids = BASE_URL + 'bids/update';
  String url_user_profile = BASE_URL + 'guests/get/';
  String get_stripe_keys = BASE_URL + 'payment/stripe';
  String get_stripe_keys_new = BASE_URL + 'settings';
  String url_update_user_profile = BASE_URL + 'guests/update';
  String firebase_token = BASE_URL + 'firebase/token';
  String get_user_bookings = BASE_URL + 'guests/';
  String checkout_user_bookings = BASE_URL + 'checkout/update';
  String api_forget_password = BASE_URL + 'guests/forgetPassword';
  String verify_code = BASE_URL + 'checkout/verify';
  String get_notifications = BASE_URL + 'firebase/notifications/';
  String add_to_cart = BASE_URL + 'events/add_cart';
  String add_addon_to_cart = BASE_URL + 'addon/add_cart';
  String remove_from_cart = BASE_URL + 'cart/remove';
  String remove_addon_from_cart = BASE_URL + 'addon/remove/';
  String update_addon_quatity = BASE_URL + 'addon/update_quantity';
  String remove_table_from_cart = BASE_URL + 'cart/remove/cart/';
  String remove_event_from_cart = BASE_URL + 'cart/remove/event/';
  String create_payment = BASE_URL + 'checkout/create_payment';
  String complete_payment = BASE_URL + 'payment/completepayment';
  String url_get_categories = BASE_URL + 'addon/categories';
  String url_profile_access = BASE_URL + 'guests/profile_access';

  static String heading_login = 'Login';
  static String email_empty_msg = 'Please enter email';
  static String enter_valid_email = 'Please enter valid email address';
  static String login = 'Login';
  static String sign_in = 'Sign in';
  static String btn_submit = 'Submit';
  static String btn_book = 'Book';
  static String btn_checkout = 'Checkout';
  static String btn_go_cart = 'Go To Cart';
  static String btn_proceed = 'Proceed';
  static String hint_user_name = 'Email';
  static String hint_password = 'Password';
  static String hint_confirm_password = 'Confirm password';
  static String hint_gender = 'Gender';
  static String hint_place_of_residence = 'Place of residence';
  static String hint_phone = 'Phone';
  static String remember_me = 'Remember Me';
  static String password_empty_msg = 'Please enter password';
  static String confirm_password_empty_msg = 'Please enter confirm password';
  static String password_un_match_msg =
      'Password and Confirm password should be same';
  static String dob_empty_msg = 'Please select date of birth';
  static String por_empty_msg = 'Please enter place of residency';
  static String phone_empty_msg = 'Please enter phone number';
  static String phone_valid_msg = 'Please enter valid phone number';
  static String register_success_message =
      'Great!!! You\'re signed up. \n\nPlease login and proceed';

  static String reset_password_text = 'Reset Password';
  static String forget_password = 'Forgot Password?';
  static String label_or = 'OR';
  static String label_dont_have_account = 'Don\'t have an account?';
  static String label_sign_up = 'Sign up';
  static String label_update_profile = 'Update Profile';
  static String already_have_account = 'Already have an account?';

  static String hint_event_filter_date = 'Select Date';
  static String hint_name = 'First Name';
  static String hint_guest_name = 'Lead Guest Name';
  static String hint_last_name = 'Last Name';
  static String hint_mobile = 'Mobile number';
  static String hint_email = 'Email';
  static String hint_dob = 'Date of Birth';
  static String hint_vehicle_make = 'Vehicle make';
  static String hint_vehicle_model = 'Vehicle model';
  static String hint_battery_capacity = 'Battery Capacity';
  static String hint_reg_no = 'Vehicle Reg. no.';
  static String hint_address = 'Address';
  static String name_empty_msg = 'Please enter name';
  static String last_name_empty_msg = 'Please enter last name';
  static String mobile_empty_msg = 'Please enter mobile number';
  static String vehicle_make_empty_msg = 'Please enter vehicle make';
  static String vehicle_model_empty_msg = 'Please enter vehicle model';
  static String battery_capacity_empty_msg = 'Please enter battery capacity';
  static String reg_no_empty_msg = 'Please enter vehicle reg. no.';
  static String address_empty_msg = 'Please enter address';
  static String sign_up = 'Sign Up';

  //Shared Preferences
  static String loginSuccess = 'loginSuccess';
  static String userId = 'userId';
  static String firstName = 'firstName';
  static String lastName = 'lastName';
  static String gender = 'gender';
  static String phone = 'phone';
  static String email = 'email';
  static String status = 'status';
  static String username = 'username';
  static String role = 'role';
  static String BASE_URLString = 'BASE_URLString';

  static String no_internet_message =
      'No internet connection. Please reconnect and try again';
  static String somethingWrong = 'Something went wrong.';

  static String no_event_seats_available = 'No Seats available for booking';
  static String empty_table_cart_message =
      'Cart empty. Please book table to checkout';
  static String seats_capacity_reached = 'Seats capacity reached for booking';
  static String notification = "Notification";
  static String selectVenue = "Select Venue";
  static String guest_list = "Submit Guest List";
  static String guest_list_info =
      "Submit your details below and we'll notify once confirmed!";
  static String request = "Request";
  static String men_count = "# of Guests";
  static String women_count = "# of Women";
  static String reference_name = "Reference Name";
  static String enter_guest_count = "Please enter men or women count";
  static String guest_list_request =
      "Your request has been submitted successfully. We will notify you once approved";
  static String enter_correct_count = "Please enter correct men or women count";
  static String enter_valid_mobile_number = "Please enter valid mobile number";
  static String request_bid = "Request to Bid";
  static String bid_request = "Bid submitted. We will notify once approved";
  static String bid_request_warning =
      "Please update bid value before requesting";
  static String event_booking_warning = "Please add event booking first";
  static String voucher_booking_warning = "Please add voucher first";
  static String table_booking_warning = "Please add table first";

  static String btn_remove_table = 'Remove';
  static String tickets = "Tickets";
  static String tables = "Tables";
  static String tablesEvents = "History";
  static String vouchers = "Vouchers";
  static String reference_empty_msg = "Reference is empty";
  // static String token = "token";
  static String currencyLbl = "";
  static String added_to_cart = "successfully added to cart";
}
