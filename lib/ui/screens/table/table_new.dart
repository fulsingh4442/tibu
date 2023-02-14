import 'dart:async';
import 'dart:convert';

import 'package:club_app/constants/constants.dart';
import 'package:club_app/constants/navigator.dart';
import 'package:club_app/constants/strings.dart';
import 'package:club_app/ui/screens/select_branch.dart';
import 'package:club_app/ui/widgets/outline_border_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TableNewScreen extends StatefulWidget {
  @override
  _TableNewScreenState createState() => _TableNewScreenState();
}

class _TableNewScreenState extends State<TableNewScreen> {
  String bookTableURL;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
//https://twelve25.teaseme.co.in
  Future<String> _getUrl() async {
    // bookTableURL = "https://faces-demo.booknbite.com/app/app-test";
    //Old bookTableURL = sucasaSelected
    //     ? "https://sucasa.bookbeach.club/app/app-test"
    //     : "https://kenjin.bookbeach.club/app/app-test";
    bookTableURL = "https://tibu.teaseme.co.in/app/app-test";
    // bookTableURL = sucasaSelected
    //     ? "https://sucasa.reserveyourvenue.com/app/app-test"
    //     : "https://kenjin.reserveyourvenue.com/app/app-test";

    // 'https://twelve25.teaseme.co.in/app/app-test';
//https://api.dream.map.bookbeachclub.com/app/app-test
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt(ClubApp.userId);
    bookTableURL += '?userID=$userId';
    debugPrint('Table seats url is $bookTableURL');
    return bookTableURL;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          color: appBackgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: OutlineBorderButton(
                    buttonBackground,
                    8.0,
                    32.0,
                    ClubApp.btn_proceed,
                    Theme.of(context)
                        .textTheme
                        .subtitle1
                        .apply(color: Colors.white), onPressed: () {
                  AppNavigator.gotoAddOns(context);
                }),
              ),
              /*const SizedBox(
                      width: 8,
                    ),*/
            ],
          ),
        ),
        body: SafeArea(
          child: FutureBuilder<String>(
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  color: appBackgroundColor,
                  child: Center(
                    child: Text(
                      'Fetching tables...',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .apply(color: textColorDarkPrimary),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              } else {
                bookTableURL = snapshot.data;
                return WebView(
                  initialUrl: bookTableURL,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                  },
                  // ignore: prefer_collection_literals
                  javascriptChannels: <JavascriptChannel>[
                    _toasterJavascriptChannel(context),
                  ].toSet(),
                  navigationDelegate: (NavigationRequest request) {
                    if (request.url.startsWith('https://www.youtube.com/')) {
                      print('blocking navigation to $request}');
                      return NavigationDecision.prevent;
                    }
                    print('allowing navigation to $request');
                    return NavigationDecision.navigate;
                  },
                  onPageStarted: (String url) {
                    print('Page started loading: $url');
                  },
                  // onPageFinished: (String url) {
                  //   print('Page finished loading: $url');
                  // },
                  gestureNavigationEnabled: true,
                  gestureRecognizers: Set()
                    ..add(Factory<VerticalDragGestureRecognizer>(
                        () => VerticalDragGestureRecognizer())),
                );
              }
            },
            future: _getUrl(),
          ),
        ),
      ),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
}
