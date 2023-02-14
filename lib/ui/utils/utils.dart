import 'dart:io';
import 'dart:math';

import 'package:club_app/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../screens/select_branch.dart';

enum ConfirmAction { CANCEL, ACCEPT }

Future<ConfirmAction> asyncConfirmDialog(BuildContext context, String title,
    String msg, String negativeButton, String positiveButton) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: true, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: <Widget>[
          TextButton(
            child: Text(negativeButton),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.CANCEL);
            },
          ),
          TextButton(
            child: Text(positiveButton),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.ACCEPT);
            },
          )
        ],
      );
    },
  );
}

Future<ConfirmAction> asyncConfirmSingleButtonDialog(BuildContext context,
    String title, String msg, String positiveButton) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: true, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: <Widget>[
          TextButton(
            child: Text(positiveButton),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.ACCEPT);
            },
          )
        ],
      );
    },
  );
}

String getInitials(String value) {
  final List<String> words = value.split(' ');
  int count = 0;
  String initials = '';
  for (String word in words) {
    if (count == 2) {
      //Only take first 2 words
      break;
    }
    count++;
    initials = initials + word.substring(0, 1);
  }
  return initials.toUpperCase();
}

int getDifferenceInMinutes(String firstTime, String secondTime) {
  final DateTime timeOne = DateTime.parse(firstTime);
  final DateTime timeTwo = DateTime.parse(secondTime);
  return timeOne.difference(timeTwo).inMinutes;
}

String get currentDateTime {
  return DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
}

String currentEventFilterDisplayDate(DateTime eventFilterDate) {
  return DateFormat('yyyy-MM-dd').format(eventFilterDate);
}

String getEventDisplayDate(DateTime eventDate) {
  return DateFormat('E dd MMM').format(eventDate);
}

String getBookingDate(DateTime date) {
  return DateFormat('MMM dd yyyy').format(date);
}

Future<bool> isNetworkAvailable() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connected');
      return true;
    } else {
      return false;
    }
  } on SocketException catch (e) {
    print('not connected: $e');
    return false;
  }
}

Future<void> ackAlert(BuildContext context, String message) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(

        title:
        Text('TIBU'
           // sucasaSelected ? 'Sucasa' : 'Kenjin',
            ),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> ackAlertWithBackScreen(BuildContext context1, String message) {
  return showDialog<void>(
    context: context1,
    builder: (BuildContext context) {

      return AlertDialog(
        title: Container(
          alignment: Alignment.center,
            child: Text('TIBU'
              //sucasaSelected ? 'TIBU' : 'TIBU',
          )),

        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context1).pop();
            },
          ),
        ],
      );
    },
  );
}
