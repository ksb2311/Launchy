package com.example.flutter_launcher

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.KeyData.CHANNEL
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class AppChangeReceiver(private val context: Context, private val flutterEngine: FlutterEngine) : BroadcastReceiver() {
    companion object {
        private const val CHANNEL = "receiver_channel"
    }


    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action
        val data = intent.data

        val methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)

        if (Intent.ACTION_PACKAGE_ADDED == action) {
            println("App installed: $data")
            methodChannel.invokeMethod("appInstalled", data.toString())
        } else if (Intent.ACTION_PACKAGE_REMOVED == action) {
            println("App uninstalled: $data")
            methodChannel.invokeMethod("appUninstalled", data.toString())
        }
    }
}