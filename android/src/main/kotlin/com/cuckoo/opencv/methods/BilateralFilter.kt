package com.cuckoo.opencv.methods

import org.opencv.core.Mat
import org.opencv.core.MatOfByte
import org.opencv.imgcodecs.Imgcodecs
import org.opencv.imgproc.Imgproc
import java.io.FileInputStream
import java.io.InputStream
import io.flutter.plugin.common.MethodChannel

class BilateralFilter {
    companion object{
        fun process(data: ByteArray, diameter: Int, sigmaColor:Int, sigmaSpace:Int, borderType: Int, result: MethodChannel.Result) {
            result.success(bilateralFilter(data, diameter, sigmaColor, sigmaSpace, borderType))
        }

        private fun bilateralFilter(data: ByteArray, diameter: Int, sigmaColor: Int, sigmaSpace: Int, borderType: Int): ByteArray? {

            return try {
                var byteArray = ByteArray(0)
                val dst = Mat()
                val src = Imgcodecs.imdecode(MatOfByte(*data), Imgcodecs.IMREAD_UNCHANGED)
                val srcRgb = Mat()
                Imgproc.cvtColor(src, srcRgb, Imgproc.COLOR_BGRA2BGR, 0)
                Imgproc.bilateralFilter(srcRgb, dst, diameter, sigmaColor.toDouble(), sigmaSpace.toDouble(), borderType)
                val matOfByte = MatOfByte()
                Imgcodecs.imencode(".jpg", dst, matOfByte)
                byteArray = matOfByte.toArray()
                byteArray
            } catch (e: java.lang.Exception) {
                println("OpenCV Error: $e")
                data
            }

        }

    }
}