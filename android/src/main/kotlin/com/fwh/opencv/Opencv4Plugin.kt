package com.fwh.opencv

import androidx.annotation.NonNull
import com.fwh.opencv.methods.colormaps.ApplyColorMap
import com.fwh.opencv.methods.colorspace.CvtColor
import com.fwh.opencv.methods.imagefilter.*
import com.fwh.opencv.methods.miscellaneous.AdaptiveThreshold
import com.fwh.opencv.methods.miscellaneous.DistanceTransform
import com.fwh.opencv.methods.miscellaneous.Threshold
import com.fwh.opencv.methods.miscellaneous.ConnectedComponent

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import org.opencv.android.OpenCVLoader
import org.opencv.core.Core

/** Opencv_4Plugin */
class Opencv4Plugin: FlutterPlugin, MethodCallHandler {
  var OpenCVFLag = false
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "opencv")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (!OpenCVFLag) {
      if (!OpenCVLoader.initDebug()) {
        println("Error when initializing OpenCV")
      } else {
        OpenCVFLag = true;
      }
    }

    when (call.method) {

      "bilateralFilter" -> {
        try {
          Bilateral.process(
                  call.argument<ByteArray>("data") as ByteArray,
                  call.argument<Int>("diameter") as Int,
                  call.argument<Int>("sigmaColor") as Int,
                  call.argument<Int>("sigmaSpace") as Int,
                  call.argument<Int>("borderType") as Int,
                  result)
        } catch (e: Exception) {
          result.error("OpenCV Error", "Android: "+e.message, e)
        }
      }
      "blur" -> {
        try {
          Blur.process(
                  call.argument<ByteArray>("data") as ByteArray,
                  call.argument<ArrayList<Double>>("kernelSize") as ArrayList<Double>,
                  call.argument<ArrayList<Double>>("anchorPoint") as ArrayList<Double>,
                  call.argument<Int>("borderType") as Int,
                  result)
        } catch (e: Exception) {
          result.error("OpenCV Error", "Android: "+e.message, e)
        }
      }
      "medianBlur" -> {
        try {
          MedianBlur.process(
                  call.argument<ByteArray>("data") as ByteArray,
                  call.argument<Int>("kernelSize") as Int,
                  result)
        } catch (e: Exception) {
          result.error("OpenCV Error", "Android: "+e.message, e)
        }
      }
      "applyColorMap" -> {
        try {
          ApplyColorMap.process(
                  call.argument<ByteArray>("data") as ByteArray,
                  call.argument<Int>("colorMap") as Int,
                  result)
        } catch (e: Exception) {
          result.error("OpenCV Error", "Android: " + e.message, e)
        }
      }
      "cvtColor" -> {
        try {
          CvtColor.process(
                  call.argument<ByteArray>("data") as ByteArray,
                  call.argument<Int>("outputType") as Int,
                  result)
        } catch (e: Exception) {
          result.error("OpenCV Error", "Android: "+e.message, e)
        }
      }
      "adaptiveThreshold" -> {
        try {
          AdaptiveThreshold.process(
                  call.argument<ByteArray>("data") as ByteArray,
                  call.argument<Double>("maxValue") as Double,
                  call.argument<Int>("adaptiveMethod") as Int,
                  call.argument<Int>("thresholdType") as Int,
                  call.argument<Int>("blockSize") as Int,
                  call.argument<Double>("constantValue") as Double,
                  result)
        } catch (e: Exception) {
          result.error("OpenCV Error", "Android: "+e.message, e)
        }
      }
      "distanceTransform" -> {
        try {
          DistanceTransform.process(
                  call.argument<ByteArray>("data") as ByteArray,
                  call.argument<Int>("distanceType") as Int,
                  call.argument<Int>("maskSize") as Int,
                  result)
        } catch (e: Exception) {
          result.error("OpenCV Error", "Android: "+e.message, e)
        }
      }
      "threshold" -> {
        try {
          Threshold.process(
                  call.argument<ByteArray>("data") as ByteArray,
                  call.argument<Double>("thresholdValue") as Double,
                  call.argument<Double>("maxThresholdValue") as Double,
                  call.argument<Int>("thresholdType") as Int,
                  result)
        } catch (e: Exception) {
          result.error("OpenCV Error", "Android: "+e.message, e)
        }
      }
      "connectedComponentsWithStats" -> {
        try {
          ConnectedComponent.process(
            call.argument<ByteArray>("data") as ByteArray,
            call.argument<Int>("connectivity") as Int,
            call.argument<Int>("ltype") as Int,
            result)
        } catch(e: Exception) {
          result.error("OpenCV Error", "Android: "+e.message, e)
        }
      }

      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
