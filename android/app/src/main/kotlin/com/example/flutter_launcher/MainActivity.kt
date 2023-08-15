package com.example.flutter_launcher

import android.annotation.SuppressLint
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.lang.reflect.Method
import io.flutter.embedding.android.FlutterActivityLaunchConfigs.BackgroundMode.transparent


class MainActivity: FlutterActivity() {
    private val myCHANNEL = "my_channel"

    @RequiresApi(Build.VERSION_CODES.TIRAMISU)
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, myCHANNEL).setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
            when (call.method) {
                "showNotificationPanel" -> {
                    expandNotif()
                    result.success(null)
                }
                "setDefaultLauncher" -> {
                    resetPreferredLauncherAndOpenChooserNew(context)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

   override fun onCreate(savedInstanceState: Bundle?) {
       intent.putExtra("background_mode", transparent.toString())
       super.onCreate(savedInstanceState)
   }

    @RequiresApi(Build.VERSION_CODES.TIRAMISU)
    @SuppressLint("WrongConstant")
    private fun expandNotif() {
        val currentApiVersion = Build.VERSION.SDK_INT
        try {
            val service = getSystemService(Context.STATUS_BAR_SERVICE)
            val statusbarManager = Class.forName("android.app.StatusBarManager")

            val expandMethod: Method = if (currentApiVersion <= Build.VERSION_CODES.N) {
                statusbarManager.getMethod("expand")
            } else {
                statusbarManager.getMethod("expandNotificationsPanel")
            }

            expandMethod.invoke(service)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    private fun displayDefaultLauncherChooser() {
//        val intent = Intent(Intent.ACTION_MAIN)
//        intent.addCategory(Intent.CATEGORY_HOME)
//        intent.addCategory(Intent.CATEGORY_DEFAULT)
//        intent.flags = Intent.FLAG_ACTIVITY_NEW_DOCUMENT
//        startActivity(intent)

//        val startMain = Intent(Intent.ACTION_MAIN)
//        startMain.addCategory(Intent.CATEGORY_HOME)
//        startMain.flags = Intent.FLAG_ACTIVITY_NEW_TASK
//        startActivity(startMain)

        val intent = Intent(Intent.ACTION_MAIN)
        intent.addCategory(Intent.CATEGORY_HOME)
        val resolveInfo = packageManager.resolveActivity(intent, PackageManager.MATCH_DEFAULT_ONLY)
        val currentHomePackage = resolveInfo!!.activityInfo.packageName

    }

    fun resetPreferredLauncherAndOpenChooserNew(context: Context) {
        val packageManager = context.packageManager
        val componentName =
            ComponentName(context, FakeLauncherActivity::class.java)
        packageManager.setComponentEnabledSetting(
            componentName,
            PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
            PackageManager.DONT_KILL_APP
        )
        val selector = Intent(Intent.ACTION_MAIN)
        selector.addCategory(Intent.CATEGORY_HOME)
        selector.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        context.startActivity(selector)
        packageManager.setComponentEnabledSetting(
            componentName,
            PackageManager.COMPONENT_ENABLED_STATE_DEFAULT,
            PackageManager.DONT_KILL_APP
        )
    }
    private fun resetPreferredLauncherAndOpenChooser(context: Context) {
        val packageManager: PackageManager = context.packageManager
        val componentName = ComponentName(context, FakeLauncherActivity::class.java)

        // Enable the fake launcher activity
        packageManager.setComponentEnabledSetting(
            componentName,
            PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
            PackageManager.DONT_KILL_APP
        )

        // Launch the home chooser activity
        val selector = Intent(Intent.ACTION_MAIN)
            .addCategory(Intent.CATEGORY_HOME)
            .setFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        context.startActivity(selector)

        // Set the fake launcher activity back to default
        packageManager.setComponentEnabledSetting(
            componentName,
            PackageManager.COMPONENT_ENABLED_STATE_DEFAULT,
            PackageManager.DONT_KILL_APP
        )
    }





}
