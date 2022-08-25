package com.fwh.opencv.methods.miscellaneous

import org.opencv.core.Mat
import org.opencv.core.MatOfByte
import org.opencv.imgcodecs.Imgcodecs
import org.opencv.imgproc.Imgproc
import java.io.FileInputStream
import java.io.InputStream
import io.flutter.plugin.common.MethodChannel

class DistanceTransform {
    companion object{
        fun process(data: ByteArray, distanceType: Int, maskSize: Int, result: MethodChannel.Result) {
            result.success(distanceTransform(data, distanceType, maskSize))
        }

        //Module: Miscellaneous Image Transformations
        private fun distanceTransform(data: ByteArray, distanceType: Int, maskSize: Int): ByteArray? {

            try {
                var byteArray = ByteArray(0)
                val dst = Mat()
                // Decode image from input byte array
                val src = Imgcodecs.imdecode(MatOfByte(*data), Imgcodecs.IMREAD_UNCHANGED)
                // distanceTransform operation
                Imgproc.distanceTransform(src, dst, distanceType, maskSize)
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