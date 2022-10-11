package com.cuckoo.opencv.methods

import org.opencv.core.Mat
import org.opencv.core.MatOfByte
import org.opencv.imgcodecs.Imgcodecs
import org.opencv.imgproc.Imgproc
import java.io.FileInputStream
import java.io.InputStream
import io.flutter.plugin.common.MethodChannel

class MedianBlur {
    companion object{

        fun process(data: ByteArray, kernelSize: Int, result: MethodChannel.Result) {
            result.success(medianBlur(data, kernelSize))
        }

        //Module: Image Filtering
        private fun medianBlur(data: ByteArray, kernelSize: Int): ByteArray? {

            try {
                var byteArray = ByteArray(0)
                val dst = Mat()
                // Decode image from input byte array
                val src = Imgcodecs.imdecode(MatOfByte(*data), Imgcodecs.IMREAD_UNCHANGED)
                // Convert the image to Gray
                Imgproc.medianBlur(src, dst, kernelSize)

                // instantiating an empty MatOfByte class
                val matOfByte = MatOfByte()
                // Converting the Mat object to MatOfByte
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