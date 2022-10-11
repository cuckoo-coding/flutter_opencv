package com.cuckoo.opencv.methods

import org.opencv.core.Mat
import org.opencv.core.MatOfByte
import org.opencv.imgcodecs.Imgcodecs
import org.opencv.imgproc.Imgproc
import java.io.FileInputStream
import java.io.InputStream
import io.flutter.plugin.common.MethodChannel

class ApplyColorMap {

    companion object{
        fun process(data: ByteArray, colorMap: Int, result: MethodChannel.Result) {
            result.success(applyColorMap(data, colorMap))
        }

        private fun applyColorMap(data: ByteArray, colorMap: Int): ByteArray? {
            try {
                var byteArray = ByteArray(0)
                val dst = Mat()
                val src = Imgcodecs.imdecode(MatOfByte(*data), Imgcodecs.IMREAD_UNCHANGED)
                Imgproc.applyColorMap(src, dst, colorMap)
                val matOfByte = MatOfByte()
                Imgcodecs.imencode(".jpg", dst, matOfByte)
                byteArray = matOfByte.toArray()
                return byteArray
            } catch (e: java.lang.Exception) {
                println("OpenCV Error: $e")
                return data
            }
        }

    }

}