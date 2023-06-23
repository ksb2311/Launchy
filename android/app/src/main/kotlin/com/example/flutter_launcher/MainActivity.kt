package com.example.flutter_launcher

import android.annotation.SuppressLint
import android.content.Context
import android.os.Build
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.lang.reflect.Method

class MainActivity: FlutterActivity() {
    private val myCHANNEL = "my_channel"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, myCHANNEL).setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
            if (call.method == "showNotificationPanel") {
                expandNotif()
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    @SuppressLint("WrongConstant")
    private fun expandNotif() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN) {
            val currentApiVersion = Build.VERSION.SDK_INT
            try {
                val service = getSystemService(Context.STATUS_BAR_SERVICE)
                val statusbarManager = Class.forName("android.app.StatusBarManager")
                val expandMethod: Method

                expandMethod = if (currentApiVersion <= Build.VERSION_CODES.N) {
                    statusbarManager.getMethod("expand")
                } else {
                    statusbarManager.getMethod("expandNotificationsPanel")
                }

                expandMethod.invoke(service)
            } catch (e: Exception) {
                e.printStackTrace()
            }
        } else {
            try {
                val service = getSystemService(Context.STATUS_BAR_SERVICE)
                val statusbarManager = Class.forName("android.app.StatusBarManager")
                val expandMethod = statusbarManager.getMethod("expand")

                expandMethod.invoke(service)
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }


}
