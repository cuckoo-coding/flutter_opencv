import 'dart:typed_data';
import 'package:flutter/services.dart';

class DistanceTransform {
  static const platform = const MethodChannel('opencv');

  static Future<Uint8List?> distanceTransform({
    required Uint8List image,
    required int distanceType,
    required int maskSize,
  }) async {
    Uint8List? result = await platform.invokeMethod('distanceTransform',
        {"data": image, 'distanceType': distanceType, 'maskSize': maskSize});

    return result;
  }
}
