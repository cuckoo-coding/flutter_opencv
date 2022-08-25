import 'dart:typed_data';
import 'package:flutter/services.dart';

class ApplyColorMap {
  static const platform = const MethodChannel('opencv');

  static Future<Uint8List?> applyColorMap({
    required Uint8List image,
    required int colorMap,
  }) async {
    int colorMapTemp = (colorMap <= 0)
        ? 0
        : (colorMap > 12)
            ? 12
            : colorMap;

    Uint8List? result = await platform.invokeMethod('applyColorMap', {
      "data": image,
      'colorMap': colorMapTemp,
    });

    return result;
  }
}
