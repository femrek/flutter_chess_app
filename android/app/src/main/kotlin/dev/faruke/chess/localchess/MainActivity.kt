package dev.faruke.chess.localchess

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.net.InetAddress
import java.net.NetworkInterface
import java.net.SocketException
import java.util.*

class MainActivity: FlutterActivity() {
    private val CHANNEL = "mychess/localIp"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "getLocalIp") {
                result.success(findLocalIp());
            } else {
                result.notImplemented()
            }
        }
    }

    fun findLocalIp() : String? {
        var ipAddress: String? = null
        try {
            val en: Enumeration<NetworkInterface> = NetworkInterface.getNetworkInterfaces()
            while (en.hasMoreElements()) {
                val intf: NetworkInterface = en.nextElement()
                val enumIpAddr: Enumeration<InetAddress> = intf.getInetAddresses()
                while (enumIpAddr.hasMoreElements()) {
                    val inetAddress: InetAddress = enumIpAddr.nextElement()
                    if (!inetAddress.isLoopbackAddress() && intf.supportsMulticast()) {
                        ipAddress = inetAddress.getHostAddress().toString()
                    }
                }
            }
        } catch (ex: SocketException) {
            println("socketException")
        }
        return ipAddress
    }
}
