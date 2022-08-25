import 'dart:typed_data';
import 'package:flutter/services.dart';

class ConnectedComponent {
  static const platform = const MethodChannel('opencv');

  static Future<List<Uint8List?>> connectedComponentsWithStats({
    required Uint8List image,
    required int connectivity,
    required int ltype,
  }) async {
    List<Object?> result = await platform.invokeMethod(
        'connectedComponentsWithStats',
        {"data": image, 'connectivity': connectivity, 'ltype': ltype});

    return result.map((obj) => obj as Uint8List?).toList();
  }
}
