import 'dart:async';
import 'dart:convert';

import 'package:club_app/constants/constants.dart';
import 'package:club_app/constants/navigator.dart';
import 'package:club_app/constants/strings.dart';
import 'package:club_app/ui/widgets/outline_border_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TableScreen extends StatefulWidget {
  TableScreen(this.flutterWebViewPlugin);

  final flutterWebViewPlugin;

  @override
  _TableScreenState createState() => _TableScreenState(flutterWebViewPlugin);
}

class _TableScreenState extends State<TableScreen> {
  _TableScreenState(this.flutterWebViewPlugin);

  String bookTableURL;
  bool isLoading = true;
  final flutterWebViewPlugin;
  bool isHidden = false;

  Future<String> _getUrl() async {
//    bookTableURL = 'http://nightclub.bookbeach.club/';
    bookTableURL = 'https://catch.teaseme.co.in/app/app-test';

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt(ClubApp.userId);
    bookTableURL += '?userID=$userId';
    debugPrint('Table seats url is $bookTableURL');
    return bookTableURL;
  }

  @override
  void initState() {
    super.initState();
    flutterWebViewPlugin.hide();
    handleWebViewPluginListeners();
  }

  void handleWebViewPluginListeners() async {
    flutterWebViewPlugin.onStateChanged.listen((viewState) async {
      debugPrint('On state changed ${viewState.type} and hidden is $isHidden');
      if (isHidden) {
        flutterWebViewPlugin.hide();
      } else {
        flutterWebViewPlugin.show();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    /*return Container(
      child: Center(
        child: Text('Bidding'),
      ),
    );*/
    return SafeArea(
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
            return SizedBox();
            // return WebviewScaffold(
            //   url: bookTableURL,
            //   javascriptChannels: <JavascriptChannel>{
            //     _toasterJavascriptChannel(context),
            //   },
            //   mediaPlaybackRequiresUserGesture: false,
            //   withZoom: true,
            //   appCacheEnabled: false,
            //   clearCookies: true,
            //   withLocalStorage: true,
            //   clearCache: true,
            //   hidden: true,
            //   initialChild: Container(
            //     color: appBackgroundColor,
            //     child: Center(
            //       child: Text(
            //         'Fetching tables...',
            //         style: Theme.of(context)
            //             .textTheme
            //             .subtitle1
            //             .apply(color: textColorDarkPrimary),
            //         textAlign: TextAlign.center,
            //       ),
            //     ),
            //   ),
            //   bottomNavigationBar: BottomAppBar(
            //     color: appBackgroundColor,
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.end,
            //       children: [
            //         Padding(
            //           padding: const EdgeInsets.all(12),
            //           child: OutlineBorderButton(
            //               buttonBackground,
            //               12.0,
            //               32.0,
            //               ClubApp.btn_proceed,
            //               Theme.of(context)
            //                   .textTheme
            //                   .subtitle1
            //                   .apply(color: Colors.white), onPressed: () {
            //             isHidden = true;
            //             flutterWebViewPlugin.hide();
            //             AppNavigator.gotoAddOns(context);
            //           }),
            //         ),
            //         /*const SizedBox(
            //           width: 8,
            //         ),*/
            //       ],
            //     ),
            //   ),
            // );
          }
        },
        future: _getUrl(),
      ),
    );
  }

  // JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
  //   return JavascriptChannel(
  //       name: 'SSOTokenAuth',
  //       onMessageReceived: (JavascriptMessage message) {
  //         print('message.message: ${message.message}');
  //         bool success = false;
  //         try {
  //           Map userMap = jsonDecode(message.message);
  //           //var response = LoginResponseData.fromJson(userMap);
  //           success = true;
  //           /*FlushbarHelper.createSuccess(
  //               message: "Login Successful!",
  //               position: FlushbarPosition.TOP,
  //               duration: Duration(milliseconds: 500))
  //               .show(context);*/
  //         } catch (ex) {
  //           success = false;
  //           /*FlushbarHelper.createError(
  //               message: "Error while authenticating user.",
  //               position: FlushbarPosition.TOP,
  //               duration: Duration(milliseconds: 500))
  //               .show(context);*/
  //         }
  //         startTime(WebAuthArguments(success, message.message));
  //       });
  // }

  startTime(WebAuthArguments args) async {
    var _duration = new Duration(milliseconds: 500);
    Timer(_duration, () {
      setState(() {
        flutterWebViewPlugin.clearCache();
        flutterWebViewPlugin.cleanCookies();
        //_webViewController.clearCache();
        Navigator.of(context).pop(args);
//        Navigator.of(context)
//            .pushNamedAndRemoveUntil(LoginScreen.routeName, (r) => false);
      });
    });
  }
}

class WebAuthArguments {
  final bool status;
  final String message;
  WebAuthArguments(this.status, this.message);
}
