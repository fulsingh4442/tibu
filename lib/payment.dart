import 'dart:convert';

import 'package:club_app/ui/screens/landing.dart';
import 'package:club_app/ui/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:stripe_payment/stripe_payment.dart';?
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_stripe/flutter_stripe.dart';


String publickey;
String secretkey;

class StripeTransactionResponse {
  String message;
  bool success;
  String pid;
  StripeTransactionResponse({this.message, this.success, this.pid});
}

class StripeService {
  static String apiBase = "https://api.stripe.com/v1";
  static String paymentApiUrl = '${StripeService.apiBase}/payment_intents';
  static Uri paymentApiUri = Uri.parse(paymentApiUrl);
  static String secret = secretkey; //"sk_test_zFsjGhXTwCe7DTsoNRkllzjQ";
  static String publishable_key =
      publickey; //"pk_test_AtszjddNytDn1mmlT4ZjgXFy";

  static init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    secretkey = prefs.getString('secret_key');
    publickey = prefs.getString('public_key');
    print("keys------- ${publickey} ${secretkey}");

    /*StripePayment.setOptions(StripeOptions(
        publishableKey: '${StripeService.publishable_key}',
        androidPayMode: 'test',
        merchantId: 'test'));*/
  }

  static Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      secretkey = prefs.getString('secret_key');
      Map<String, String>  headers = {
        'Authorization': 'Bearer ${secretkey}',
        'content-type': 'application/x-www-form-urlencoded'
      };
      print("payment Header: ${headers}");
      var response =
          await http.post(paymentApiUri, headers: headers, body: body);
      print("response");
      print(jsonDecode(response.body));
      return jsonDecode(response.body);
    } catch (error) {
      print('error Happened');
      throw error;
    }
  }

  static Future<StripeTransactionResponse> payNowHandler(
      {String amount, String currency}) async {

    var paymentIntent =
    await StripeService.createPaymentIntent(amount, currency);
    print("payment: ${paymentIntent}");


    try {

      await Stripe.instance
          .initPaymentSheet(

          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent[
              'client_secret'], //Gotten from payment intent
              style: ThemeMode.light,
              merchantDisplayName: 'App'))
          .then((value) {});

      await Stripe.instance.presentPaymentSheet().onError((error, stackTrace){
        return StripeService.getErrorAndAnalyze(error);
      });
      print("payment:success ${paymentIntent}");
      return StripeTransactionResponse(
          message: 'Transaction successfull',
          success: true,
          pid: paymentIntent["id"]);
      /*await Stripe.instance.presentPaymentSheet().then((value) {

        //Clear paymentIntent variable after successful payment
        print("payment:success ${paymentIntent}");
        return StripeTransactionResponse(
            message: 'Transaction successfull',
            success: true,
            pid: paymentIntent["id"]);

      }).onError((error, stackTrace) {
        throw Exception(error);
      });*/
    }
    on StripeException catch (e) {
      print('Error is:---> $e');
    }
    catch (e) {
      print("payment:error ${e}");
      return StripeTransactionResponse(message: "Transcation Failed.", success: false);
    }



      /*try {
      var paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest());
      var p =
      var paymentIntent =
          await StripeService.createPaymentIntent(amount, currency);
      var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
          clientSecret: paymentIntent['client_secret'],
          paymentMethodId: paymentMethod.id));
      print(response.paymentIntentId);
      print(response.toJson());
      if (response.status == 'succeeded') {
        // Navigator.pushNamed(context, '/landing');
        return StripeTransactionResponse(
            message: 'Transaction successfull',
            success: true,
            pid: response.paymentIntentId);
      } else {
        return StripeTransactionResponse(
            message: 'Transaction failed', success: false);
      }
    } catch (error) {
      return StripeTransactionResponse(
          message: 'Transaction failed in the catch block', success: false);
    } on PlatformException catch (error) {
      return StripeService.getErrorAndAnalyze(error);
    }*/
    // return StripeTransactionResponse(
    //     message: 'Transaction failed', success: false);
  }

  static getErrorAndAnalyze(err) {
    String message = 'Something went wrong';
    if (err.code == 'cancelled') {
      message = 'Transaction canceled';
    }
    return StripeTransactionResponse(message: message, success: false);
  }
}
