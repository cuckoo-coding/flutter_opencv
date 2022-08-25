import 'dart:typed_data';
import 'package:flutter/services.dart';

class Bitwise {
  static const platform = const MethodChannel('opencv');

  static Future<Uint8List?> bitwiseOr(
      {required Uint8List image1, required Uint8List image2}) async {
    Uint8List? result = await platform
        .invokeMethod('bitwiseOr', {'image1': image1, 'image2': image2});

    return result;
  }
}
