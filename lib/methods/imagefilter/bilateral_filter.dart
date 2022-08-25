import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_opencv/methods/utils.dart';

class BilateralFilter {
  static const platform = const MethodChannel('opencv');

  static Future<Uint8List?> bilateralFilter({
    required Uint8List image,
    required int diameter,
    required int sigmaColor,
    required int sigmaSpace,
    required int borderType,
  }) async {
    int diameterTemp = (diameter >= 0)
        ? (diameter == 0)
            ? 1
            : diameter
        : -1 * diameter;
    int borderTypeTemp = Utils.verifyBorderType(borderType);

    Uint8List? result = await platform.invokeMethod('bilateralFilter', {
      "data": image,
      "diameter": diameterTemp,
      "sigmaColor": sigmaColor,
      "sigmaSpace": sigmaSpace,
      "borderType": borderTypeTemp,
    });

    return result;
  }
}
