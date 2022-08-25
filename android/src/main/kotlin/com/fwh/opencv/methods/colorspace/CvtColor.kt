package com.fwh.opencv.methods.colorspace

import org.opencv.core.Mat
import org.opencv.core.MatOfByte
import org.opencv.imgcodecs.Imgcodecs
import org.opencv.imgproc.Imgproc
import java.io.FileInputStream
import java.io.InputStream
import io.flutter.plugin.common.MethodChannel

class CvtColor {
    companion object{
        fun process(data: ByteArray, outputType: Int, result: MethodChannel.Result) {
            result.success(cvtColor(data, outputType))
        }

        private fun cvtColor(data: ByteArray, outputType: Int): ByteArray? {
            return try {
                var byteArray = ByteArray(0)
                val dst = Mat()
                val src = Imgcodecs.imdecode(MatOfByte(*data), Imgcodecs.IMREAD_UNCHANGED)
                Imgproc.cvtColor(src, dst, outputType)
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