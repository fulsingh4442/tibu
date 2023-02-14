import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Utility {
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    final ByteData data = await rootBundle.load(path);
    final ui.Codec codec = await ui
        .instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    final ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  static void showSnackBarMessage(
      GlobalKey<ScaffoldState> scaffoldKey, String message) {
    final SnackBar snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(milliseconds: 1500),
    );
    // if (message != null && message.isNotEmpty) {
    //   scaffoldKey.currentState.showSnackBar(snackBar);
    // }
  }
}
