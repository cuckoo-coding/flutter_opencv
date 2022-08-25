import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_opencv/methods/utils.dart';

class Blur {
  static const platform = const MethodChannel('opencv');

  static Future<Uint8List?> blur({
    required Uint8List image,
    required List<double> kernelSize,
    required List<double> anchorPoint,
    required int borderType,
  }) async {
    int borderTypeTemp = Utils.verifyBorderType(borderType);
    List<double> kernelSizeTemp = Utils.verifyKernelSize(kernelSize);

    Uint8List? result = await platform.invokeMethod(
      'blur',
      {
        "data": image,
        "kernelSize": kernelSizeTemp,
        "anchorPoint": anchorPoint,
        "borderType": borderTypeTemp,
      },
    );

    return result;
  }

  static Future<Uint8List?> medianBlur({
    required Uint8List image,
    required int kernelSize,
  }) async {
    int kernelSizeTemp = (kernelSize <= 0) ? 1 : kernelSize;

    Uint8List? result = await platform.invokeMethod(
      'medianBlur',
      {
        "data": image,
        'kernelSize': kernelSizeTemp,
      },
    );

    return result;
  }
}
