import 'dart:typed_data';
import 'package:flutter/services.dart';

class CvtColor {
  static const platform = const MethodChannel('opencv');

  static Future<Uint8List?> cvtColor({
    required Uint8List image,
    required int outputType,
  }) async {
    Uint8List? result = await platform.invokeMethod('cvtColor', {
      "data": image,
      'outputType': outputType,
    });

    return result;
  }
}
