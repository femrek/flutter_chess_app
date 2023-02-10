package dev.faruke.chess.localchess

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.net.InetAddress
import java.net.NetworkInterface
import java.net.SocketException
import java.util.*

class MainActivity: FlutterActivity() {
    private val CHANNEL = "mychess/localIp"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "getLocalIp") {
                val ipAndMask = findLocalIpAndMask()
                if (ipAndMask == null) {
                    result.error("", "any ip address could not found", null)
                } else {
                    val ip = ipAndMask.substring(0, ipAndMask.indexOf('/'))
                    val maskLength = ipAndMask.substring(ipAndMask.indexOf('/')+1)
                    result.success(mapOf<String, Any>(
                        Pair("ipAddress", ip),
                        Pair("maskLength", maskLength)
                    ))
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun findLocalIpAndMask() : String? {
        var ipAddress: String? = null
        var prefixLength: String? = null
        try {
            val en: Enumeration<NetworkInterface> = NetworkInterface.getNetworkInterfaces()
            while (en.hasMoreElements()) {
                val intf: NetworkInterface = en.nextElement()
                val enumIpAddr: Enumeration<InetAddress> = intf.inetAddresses
                while (enumIpAddr.hasMoreElements()) {
                    val inetAddress: InetAddress = enumIpAddr.nextElement()
                    if (!inetAddress.isLoopbackAddress && intf.supportsMulticast()) {
                        ipAddress = inetAddress.hostAddress?.toString()
                    }
                }

                for (interfaceAddress in intf.interfaceAddresses) {
                    val address = interfaceAddress.address.toString()
                    if (address.substring(1, address.length) == ipAddress) {
                        prefixLength = (interfaceAddress.networkPrefixLength).toString()
                    }
                }
            }
        } catch (ex: SocketException) {
            println("socketException when finding local ip address")
            return null
        }
        return "$ipAddress/$prefixLength"
    }
}
