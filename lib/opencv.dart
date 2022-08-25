import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_opencv/methods/colormaps/applycolormap.dart';
import 'package:flutter_opencv/methods/colorspace/cvt_color.dart';
import 'package:flutter_opencv/methods/imagefilter/bilateral_filter.dart';
import 'package:flutter_opencv/methods/imagefilter/blur.dart';
import 'package:flutter_opencv/methods/miscellaneous/absolute_difference.dart';
import 'package:flutter_opencv/methods/miscellaneous/bitwise.dart';
import 'package:flutter_opencv/methods/miscellaneous/connected_component.dart';
import 'package:flutter_opencv/methods/miscellaneous/distancetransform.dart';
import 'package:flutter_opencv/methods/miscellaneous/threshold.dart';

class CV {
  static const int BORDER_CONSTANT = 0,
      BORDER_REPLICATE = 1,
      BORDER_REFLECT = 2,
      BORDER_WRAP = 3,
      BORDER_REFLECT_101 = 4,
      BORDER_TRANSPARENT = 5,
      BORDER_REFLECT101 = BORDER_REFLECT_101,
      BORDER_DEFAULT = BORDER_REFLECT_101,
      BORDER_ISOLATED = 16;

  static const int MORPH_ERODE = 0,
      MORPH_DILATE = 1,
      MORPH_OPEN = 2,
      MORPH_CLOSE = 3,
      MORPH_GRADIENT = 4,
      MORPH_TOPHAT = 5,
      MORPH_BLACKHAT = 6,
      MORPH_HITMISS = 7;

  static const int CV_GAUSSIAN_5x5 = 7, CV_SCHARR = -1, CV_MAX_SOBEL_KSIZE = 7;

  static const int COLOR_BGR2BGRA = 0,
      COLOR_RGB2RGBA = COLOR_BGR2BGRA,
      COLOR_BGRA2BGR = 1,
      COLOR_RGBA2RGB = COLOR_BGRA2BGR,
      COLOR_BGR2RGBA = 2,
      COLOR_RGB2BGRA = COLOR_BGR2RGBA,
      COLOR_RGBA2BGR = 3,
      COLOR_BGRA2RGB = COLOR_RGBA2BGR,
      COLOR_BGR2RGB = 4,
      COLOR_RGB2BGR = COLOR_BGR2RGB,
      COLOR_BGRA2RGBA = 5,
      COLOR_RGBA2BGRA = COLOR_BGRA2RGBA,
      COLOR_BGR2GRAY = 6,
      COLOR_RGB2GRAY = 7,
      COLOR_GRAY2BGR = 8,
      COLOR_GRAY2RGB = COLOR_GRAY2BGR,
      COLOR_GRAY2BGRA = 9,
      COLOR_GRAY2RGBA = COLOR_GRAY2BGRA,
      COLOR_BGRA2GRAY = 10,
      COLOR_RGBA2GRAY = 11,
      COLOR_BGR2BGR565 = 12,
      COLOR_RGB2BGR565 = 13,
      COLOR_BGR5652BGR = 14,
      COLOR_BGR5652RGB = 15,
      COLOR_BGRA2BGR565 = 16,
      COLOR_RGBA2BGR565 = 17,
      COLOR_BGR5652BGRA = 18,
      COLOR_BGR5652RGBA = 19,
      COLOR_GRAY2BGR565 = 20,
      COLOR_BGR5652GRAY = 21,
      COLOR_BGR2BGR555 = 22,
      COLOR_RGB2BGR555 = 23,
      COLOR_BGR5552BGR = 24,
      COLOR_BGR5552RGB = 25,
      COLOR_BGRA2BGR555 = 26,
      COLOR_RGBA2BGR555 = 27,
      COLOR_BGR5552BGRA = 28,
      COLOR_BGR5552RGBA = 29,
      COLOR_GRAY2BGR555 = 30,
      COLOR_BGR5552GRAY = 31,
      COLOR_BGR2XYZ = 32,
      COLOR_RGB2XYZ = 33,
      COLOR_XYZ2BGR = 34,
      COLOR_XYZ2RGB = 35,
      COLOR_BGR2YCrCb = 36,
      COLOR_RGB2YCrCb = 37,
      COLOR_YCrCb2BGR = 38,
      COLOR_YCrCb2RGB = 39,
      COLOR_BGR2HSV = 40,
      COLOR_RGB2HSV = 41,
      COLOR_BGR2Lab = 44,
      COLOR_RGB2Lab = 45,
      COLOR_BGR2Luv = 50,
      COLOR_RGB2Luv = 51,
      COLOR_BGR2HLS = 52,
      COLOR_RGB2HLS = 53,
      COLOR_HSV2BGR = 54,
      COLOR_HSV2RGB = 55,
      COLOR_Lab2BGR = 56,
      COLOR_Lab2RGB = 57,
      COLOR_Luv2BGR = 58,
      COLOR_Luv2RGB = 59,
      COLOR_HLS2BGR = 60,
      COLOR_HLS2RGB = 61,
      COLOR_BGR2HSV_FULL = 66,
      COLOR_RGB2HSV_FULL = 67,
      COLOR_BGR2HLS_FULL = 68,
      COLOR_RGB2HLS_FULL = 69,
      COLOR_HSV2BGR_FULL = 70,
      COLOR_HSV2RGB_FULL = 71,
      COLOR_HLS2BGR_FULL = 72,
      COLOR_HLS2RGB_FULL = 73,
      COLOR_LBGR2Lab = 74,
      COLOR_LRGB2Lab = 75,
      COLOR_LBGR2Luv = 76,
      COLOR_LRGB2Luv = 77,
      COLOR_Lab2LBGR = 78,
      COLOR_Lab2LRGB = 79,
      COLOR_Luv2LBGR = 80,
      COLOR_Luv2LRGB = 81,
      COLOR_BGR2YUV = 82,
      COLOR_RGB2YUV = 83,
      COLOR_YUV2BGR = 84,
      COLOR_YUV2RGB = 85,
      COLOR_YUV2RGB_NV12 = 90,
      COLOR_YUV2BGR_NV12 = 91,
      COLOR_YUV2RGB_NV21 = 92,
      COLOR_YUV2BGR_NV21 = 93,
      COLOR_YUV420sp2RGB = COLOR_YUV2RGB_NV21,
      COLOR_YUV420sp2BGR = COLOR_YUV2BGR_NV21,
      COLOR_YUV2RGBA_NV12 = 94,
      COLOR_YUV2BGRA_NV12 = 95,
      COLOR_YUV2RGBA_NV21 = 96,
      COLOR_YUV2BGRA_NV21 = 97,
      COLOR_YUV420sp2RGBA = COLOR_YUV2RGBA_NV21,
      COLOR_YUV420sp2BGRA = COLOR_YUV2BGRA_NV21,
      COLOR_YUV2RGB_YV12 = 98,
      COLOR_YUV2BGR_YV12 = 99,
      COLOR_YUV2RGB_IYUV = 100,
      COLOR_YUV2BGR_IYUV = 101,
      COLOR_YUV2RGB_I420 = COLOR_YUV2RGB_IYUV,
      COLOR_YUV2BGR_I420 = COLOR_YUV2BGR_IYUV,
      COLOR_YUV420p2RGB = COLOR_YUV2RGB_YV12,
      COLOR_YUV420p2BGR = COLOR_YUV2BGR_YV12,
      COLOR_YUV2RGBA_YV12 = 102,
      COLOR_YUV2BGRA_YV12 = 103,
      COLOR_YUV2RGBA_IYUV = 104,
      COLOR_YUV2BGRA_IYUV = 105,
      COLOR_YUV2RGBA_I420 = COLOR_YUV2RGBA_IYUV,
      COLOR_YUV2BGRA_I420 = COLOR_YUV2BGRA_IYUV,
      COLOR_YUV420p2RGBA = COLOR_YUV2RGBA_YV12,
      COLOR_YUV420p2BGRA = COLOR_YUV2BGRA_YV12,
      COLOR_YUV2GRAY_420 = 106,
      COLOR_YUV2GRAY_NV21 = COLOR_YUV2GRAY_420,
      COLOR_YUV2GRAY_NV12 = COLOR_YUV2GRAY_420,
      COLOR_YUV2GRAY_YV12 = COLOR_YUV2GRAY_420,
      COLOR_YUV2GRAY_IYUV = COLOR_YUV2GRAY_420,
      COLOR_YUV2GRAY_I420 = COLOR_YUV2GRAY_420,
      COLOR_YUV420sp2GRAY = COLOR_YUV2GRAY_420,
      COLOR_YUV420p2GRAY = COLOR_YUV2GRAY_420,
      COLOR_YUV2RGB_UYVY = 107,
      COLOR_YUV2BGR_UYVY = 108,
      COLOR_YUV2RGB_Y422 = COLOR_YUV2RGB_UYVY,
      COLOR_YUV2BGR_Y422 = COLOR_YUV2BGR_UYVY,
      COLOR_YUV2RGB_UYNV = COLOR_YUV2RGB_UYVY,
      COLOR_YUV2BGR_UYNV = COLOR_YUV2BGR_UYVY,
      COLOR_YUV2RGBA_UYVY = 111,
      COLOR_YUV2BGRA_UYVY = 112,
      COLOR_YUV2RGBA_Y422 = COLOR_YUV2RGBA_UYVY,
      COLOR_YUV2BGRA_Y422 = COLOR_YUV2BGRA_UYVY,
      COLOR_YUV2RGBA_UYNV = COLOR_YUV2RGBA_UYVY,
      COLOR_YUV2BGRA_UYNV = COLOR_YUV2BGRA_UYVY,
      COLOR_YUV2RGB_YUY2 = 115,
      COLOR_YUV2BGR_YUY2 = 116,
      COLOR_YUV2RGB_YVYU = 117,
      COLOR_YUV2BGR_YVYU = 118,
      COLOR_YUV2RGB_YUYV = COLOR_YUV2RGB_YUY2,
      COLOR_YUV2BGR_YUYV = COLOR_YUV2BGR_YUY2,
      COLOR_YUV2RGB_YUNV = COLOR_YUV2RGB_YUY2,
      COLOR_YUV2BGR_YUNV = COLOR_YUV2BGR_YUY2,
      COLOR_YUV2RGBA_YUY2 = 119,
      COLOR_YUV2BGRA_YUY2 = 120,
      COLOR_YUV2RGBA_YVYU = 121,
      COLOR_YUV2BGRA_YVYU = 122,
      COLOR_YUV2RGBA_YUYV = COLOR_YUV2RGBA_YUY2,
      COLOR_YUV2BGRA_YUYV = COLOR_YUV2BGRA_YUY2,
      COLOR_YUV2RGBA_YUNV = COLOR_YUV2RGBA_YUY2,
      COLOR_YUV2BGRA_YUNV = COLOR_YUV2BGRA_YUY2,
      COLOR_YUV2GRAY_UYVY = 123,
      COLOR_YUV2GRAY_YUY2 = 124,
      COLOR_YUV2GRAY_Y422 = COLOR_YUV2GRAY_UYVY,
      COLOR_YUV2GRAY_UYNV = COLOR_YUV2GRAY_UYVY,
      COLOR_YUV2GRAY_YVYU = COLOR_YUV2GRAY_YUY2,
      COLOR_YUV2GRAY_YUYV = COLOR_YUV2GRAY_YUY2,
      COLOR_YUV2GRAY_YUNV = COLOR_YUV2GRAY_YUY2,
      COLOR_RGBA2mRGBA = 125,
      COLOR_mRGBA2RGBA = 126,
      COLOR_RGB2YUV_I420 = 127,
      COLOR_BGR2YUV_I420 = 128,
      COLOR_RGB2YUV_IYUV = COLOR_RGB2YUV_I420,
      COLOR_BGR2YUV_IYUV = COLOR_BGR2YUV_I420,
      COLOR_RGBA2YUV_I420 = 129,
      COLOR_BGRA2YUV_I420 = 130,
      COLOR_RGBA2YUV_IYUV = COLOR_RGBA2YUV_I420,
      COLOR_BGRA2YUV_IYUV = COLOR_BGRA2YUV_I420,
      COLOR_RGB2YUV_YV12 = 131,
      COLOR_BGR2YUV_YV12 = 132,
      COLOR_RGBA2YUV_YV12 = 133,
      COLOR_BGRA2YUV_YV12 = 134,
      COLOR_BayerBG2BGR = 46,
      COLOR_BayerGB2BGR = 47,
      COLOR_BayerRG2BGR = 48,
      COLOR_BayerGR2BGR = 49,
      COLOR_BayerBG2RGB = COLOR_BayerRG2BGR,
      COLOR_BayerGB2RGB = COLOR_BayerGR2BGR,
      COLOR_BayerRG2RGB = COLOR_BayerBG2BGR,
      COLOR_BayerGR2RGB = COLOR_BayerGB2BGR,
      COLOR_BayerBG2GRAY = 86,
      COLOR_BayerGB2GRAY = 87,
      COLOR_BayerRG2GRAY = 88,
      COLOR_BayerGR2GRAY = 89,
      COLOR_BayerBG2BGR_VNG = 62,
      COLOR_BayerGB2BGR_VNG = 63,
      COLOR_BayerRG2BGR_VNG = 64,
      COLOR_BayerGR2BGR_VNG = 65,
      COLOR_BayerBG2RGB_VNG = COLOR_BayerRG2BGR_VNG,
      COLOR_BayerGB2RGB_VNG = COLOR_BayerGR2BGR_VNG,
      COLOR_BayerRG2RGB_VNG = COLOR_BayerBG2BGR_VNG,
      COLOR_BayerGR2RGB_VNG = COLOR_BayerGB2BGR_VNG,
      COLOR_BayerBG2BGR_EA = 135,
      COLOR_BayerGB2BGR_EA = 136,
      COLOR_BayerRG2BGR_EA = 137,
      COLOR_BayerGR2BGR_EA = 138,
      COLOR_BayerBG2RGB_EA = COLOR_BayerRG2BGR_EA,
      COLOR_BayerGB2RGB_EA = COLOR_BayerGR2BGR_EA,
      COLOR_BayerRG2RGB_EA = COLOR_BayerBG2BGR_EA,
      COLOR_BayerGR2RGB_EA = COLOR_BayerGB2BGR_EA,
      COLOR_BayerBG2BGRA = 139,
      COLOR_BayerGB2BGRA = 140,
      COLOR_BayerRG2BGRA = 141,
      COLOR_BayerGR2BGRA = 142,
      COLOR_BayerBG2RGBA = COLOR_BayerRG2BGRA,
      COLOR_BayerGB2RGBA = COLOR_BayerGR2BGRA,
      COLOR_BayerRG2RGBA = COLOR_BayerBG2BGRA,
      COLOR_BayerGR2RGBA = COLOR_BayerGB2BGRA,
      COLOR_COLORCVT_MAX = 143;

  static const int COLORMAP_AUTUMN = 0,
      COLORMAP_BONE = 1,
      COLORMAP_JET = 2,
      COLORMAP_WINTER = 3,
      COLORMAP_RAINBOW = 4,
      COLORMAP_OCEAN = 5,
      COLORMAP_SUMMER = 6,
      COLORMAP_SPRING = 7,
      COLORMAP_COOL = 8,
      COLORMAP_HSV = 9,
      COLORMAP_PINK = 10,
      COLORMAP_HOT = 11,
      COLORMAP_PARULA = 12,
      COLORMAP_MAGMA = 13,
      COLORMAP_INFERNO = 14,
      COLORMAP_PLASMA = 15,
      COLORMAP_VIRIDIS = 16,
      COLORMAP_CIVIDIS = 17,
      COLORMAP_TWILIGHT = 18,
      COLORMAP_TWILIGHT_SHIFTED = 19,
      COLORMAP_TURBO = 20,
      COLORMAP_DEEPGREEN = 21;

  static const int THRESH_BINARY = 0,
      THRESH_BINARY_INV = 1,
      THRESH_TRUNC = 2,
      THRESH_TOZERO = 3,
      THRESH_TOZERO_INV = 4,
      THRESH_MASK = 7,
      THRESH_OTSU = 8,
      THRESH_TRIANGLE = 16;

  static const int DIST_USER = -1,
      DIST_L1 = 1,
      DIST_L2 = 2,
      DIST_C = 3,
      DIST_L12 = 4,
      DIST_FAIR = 5,
      DIST_WELSCH = 6,
      DIST_HUBER = 7;

  static const int ADAPTIVE_THRESH_MEAN_C = 0, ADAPTIVE_THRESH_GAUSSIAN_C = 1;

  static const platform = const MethodChannel('opencv');

  static Future<Uint8List?> bilateralFilter({
    required Uint8List image,
    required int diameter,
    required int sigmaColor,
    required int sigmaSpace,
    required int borderType,
  }) async {
    final Uint8List? result = await BilateralFilter.bilateralFilter(
      image: image,
      diameter: diameter,
      sigmaColor: sigmaColor,
      sigmaSpace: sigmaSpace,
      borderType: borderType,
    );

    return result;
  }

  static Future<Uint8List?> blur({
    required Uint8List image,
    required List<double> kernelSize,
    required List<double> anchorPoint,
    required int borderType,
  }) async {
    final Uint8List? result = await Blur.blur(
      image: image,
      kernelSize: kernelSize,
      anchorPoint: anchorPoint,
      borderType: borderType,
    );

    return result;
  }

  static Future<Uint8List?> medianBlur({
    required Uint8List image,
    required int kernelSize,
  }) async {
    final Uint8List? result = await Blur.medianBlur(
      image: image,
      kernelSize: kernelSize,
    );

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
    final Uint8List? result = await Threshold.adaptiveThreshold(
      image: image,
      maxValue: maxValue,
      adaptiveMethod: adaptiveMethod,
      thresholdType: thresholdType,
      blockSize: blockSize,
      constantValue: constantValue,
    );

    return result;
  }

  static Future<Uint8List?> distanceTransform({
    required Uint8List image,
    required int distanceType,
    required int maskSize,
  }) async {
    final Uint8List? result = await DistanceTransform.distanceTransform(
        image: image, distanceType: distanceType, maskSize: maskSize);

    return result;
  }

  static Future<Uint8List?> threshold({
    required Uint8List image,
    required double thresholdValue,
    required double maxThresholdValue,
    required int thresholdType,
  }) async {
    final Uint8List? result = await Threshold.threshold(
      image: image,
      thresholdValue: thresholdValue,
      maxThresholdValue: maxThresholdValue,
      thresholdType: thresholdType,
    );

    return result;
  }

  static Future<Uint8List?> cvtColor({
    required Uint8List image,
    required int outputType,
  }) async {
    final Uint8List? result = await CvtColor.cvtColor(
      image: image,
      outputType: outputType,
    );

    return result;
  }

  static Future<Uint8List?> applyColorMap({
    required Uint8List image,
    required int colorMap,
  }) async {
    final Uint8List? result = await ApplyColorMap.applyColorMap(
      image: image,
      colorMap: colorMap,
    );

    return result;
  }

  static Future<Uint8List?> absdiff(
      {required Uint8List image1, required Uint8List image2}) async {
    final Uint8List? result =
        await AbsoluteDifference.absdiff(image1: image1, image2: image2);

    return result;
  }

  static Future<Uint8List?> bitwiseOr(
      {required Uint8List image1, required Uint8List image2}) async {
    final Uint8List? result =
        await Bitwise.bitwiseOr(image1: image1, image2: image2);

    return result;
  }

  static Future<List<Uint8List?>> connectedComponentsWithStats(
      {required Uint8List image,
      required int connectivity,
      required int ltype}) async {
    final List<Uint8List?> result =
        await ConnectedComponent.connectedComponentsWithStats(
            image: image, connectivity: connectivity, ltype: ltype);

    return result;
  }
}
