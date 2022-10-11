package com.cuckoo.opencv.methods

import org.opencv.core.Mat
import org.opencv.core.MatOfByte
import org.opencv.imgcodecs.Imgcodecs
import org.opencv.imgproc.Imgproc
import java.io.FileInputStream
import java.io.InputStream
import io.flutter.plugin.common.MethodChannel

class ConnectedComponent {
    companion object{
        fun process(data: ByteArray, connectivity: Int, ltype: Int, result: MethodChannel.Result) {
            result.success(threshold(data, connectivity, ltype))
        }

        private fun connectedComponentsWithStats(data: ByteArray, connectivity: Int, ltype: Int): ByteArray? {

            try {
                var byteArray = ByteArray(0)
                val srcGray = Mat()
                val labels = Mat()
                val stats = Mat()
                val centroid = Mat()
                val src = Imgcodecs.imdecode(MatOfByte(*data), Imgcodecs.IMREAD_GRAYSCALE)

                Imgproc.connectedComponentsWithStats(src, labels, stats, centroid)

                val matOfByte = MatOfByte()
                Imgcodecs.imencode(".jpg", stats, matOfByte)
                byteArray = matOfByte.toArray()
                return byteArray
            } catch (e: java.lang.Exception) {
                println("OpenCV Error: $e")
                return data
            }

        }
    }
}