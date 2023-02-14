import 'package:club_app/ui/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:async';
// import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

class QRCodeScreen extends StatelessWidget {
  QRCodeScreen(this.bookingUid, this.appBarTitle, this.bookingTitle);

  final String bookingUid;
  final String appBarTitle;
  final String bookingTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Text(
              bookingTitle,
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  .apply(color: Colors.black),
            ),
            SizedBox(height: 20),
            Expanded(
              flex: 6,
              child: QrImage(
                data: bookingUid,
//              size: SizeConfig.screenHeight / 2.25,
                errorStateBuilder: (BuildContext context, Object error) {
                  print('QR code error : ${error.toString()}');
                  return Text('Unable to show QR Code');
                },
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: <Widget>[
                Expanded(
                  child: new Container(
                      margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                      child: Divider(
                        color: Colors.black,
                        height: 36,
                      )),
                ),
                Text('OR', style: Theme.of(context).textTheme.subtitle1.apply(color: Colors.black),),
                Expanded(
                  child: new Container(
                      margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                      child: Divider(
                        color: Colors.black,
                        height: 36,
                      )),
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              flex: 4,
              child: Center(
                child: Text(
                  bookingUid,
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .apply(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///QR code scanning code
  // var _aspectTolerance = 0.00;
  // var _selectedCamera = -1;
  // var _useAutoFocus = true;
  // var _autoEnableFlash = false;

  // static final _possibleFormats = BarcodeFormat.values.toList()
  //   ..removeWhere((e) => e == BarcodeFormat.unknown);

  // List<BarcodeFormat> selectedFormats = _possibleFormats;

  // Future scan() async {
  //   try {
  //     var options = ScanOptions(
  //       restrictFormat: selectedFormats,
  //       useCamera: _selectedCamera,
  //       autoEnableFlash: _autoEnableFlash,
  //       android: AndroidOptions(
  //         aspectTolerance: _aspectTolerance,
  //         useAutoFocus: _useAutoFocus,
  //       ),
  //     );

  //     var result = await BarcodeScanner.scan(options: options);
  //     print("Scan result : ${result.rawContent}");
  //   } on PlatformException catch (e) {
  //     var result = ScanResult(
  //       type: ResultType.Error,
  //       format: BarcodeFormat.unknown,
  //     );

  //     if (e.code == BarcodeScanner.cameraAccessDenied) {
  //       print('The user did not grant the camera permission!');
  //     } else {
  //       print('Unknown error: $e');
  //     }
  //   }
  // }
}
