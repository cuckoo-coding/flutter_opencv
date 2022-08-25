import 'dart:typed_data';
import 'package:flutter/services.dart';

class Threshold {
  static const platform = const MethodChannel('opencv');

  static Future<Uint8List?> threshold({
    required Uint8List image,
    required double thresholdValue,
    required double maxThresholdValue,
    required int thresholdType,
  }) async {
    Uint8List? result = await platform.invokeMethod('threshold', {
      'data': image,
      'thresholdValue': thresholdValue,
      'maxThresholdValue': maxThresholdValue,
      'thresholdType': thresholdType
    });

    return result;
  }

  static Future<Uint8List?> adaptiveThreshold({
    required Uint8List image,
    required double maxValue,
    required int adaptiveMethod,
    required int thresholdType,
    required int blockSize,
    required double constantValue,
  }) async {
    int adaptiveMethodTemp = (adaptiveMethod > 1)
        ? 1
        : (adaptiveMethod < 0)
            ? 0
            : adaptiveMethod;

    int thresholdTypeTemp = (thresholdType > 1)
        ? 1
        : (thresholdType < 0)
            ? 0
            : thresholdType;

    Uint8List? result = await platform.invokeMethod('adaptiveThreshold', {
      "data": image,
      'maxValue': maxValue,
      'adaptiveMethod': adaptiveMethodTemp,
      'thresholdType': thresholdTypeTemp,
      'blockSize': blockSize,
      'constantValue': constantValue
    });

    return result;
  }
}
