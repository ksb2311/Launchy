package com.example.flutter_launcher

import android.annotation.SuppressLint
import android.app.role.RoleManager
import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.graphics.Rect
import android.os.Build
import android.os.Bundle
import android.util.DisplayMetrics
import android.view.View
import android.view.Window
import android.view.WindowInsets
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterActivityLaunchConfigs.BackgroundMode.transparent
import io.flutter.embedding.android.KeyData.CHANNEL
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.lang.reflect.Method

class MainActivity : FlutterActivity() {
    companion object {
        private const val SETTINGS_CHANNEL = "settings_channel"
        private const val EXPAND_METHOD = "expand"
        private const val EXPAND_NOTIFICATIONS_PANEL_METHOD = "expandNotificationsPanel"
        private const val ROLE_HOME_REQUEST_CODE = 1
    }
    private lateinit var appChangeReceiver: AppChangeReceiver

    @RequiresApi(Build.VERSION_CODES.TIRAMISU)
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SETTINGS_CHANNEL)
                .setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
                    when (call.method) {
                        "showNotificationPanel" -> {
                            expandNotif()
                            result.success(null)
                        }
                        "setDefaultLauncher" -> {
                            resetPreferredLauncherAndOpenChooserNew(context)
                        }
                        "getStatusBarHeight" -> {
                            val height = getStatusBarHeight()
                            result.success(height)
                        }
                        "getNavigationBarHeight" -> {
                            val height = getNavigationBarHeight()
                            result.success(height)
                        }
                        "getScreenWidth" -> {
                            val width = getScreenWidth()
                            result.success(width)
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

        flutterEngine?.let { AppChangeReceiver(this, it).also { appChangeReceiver = it } }
        val filter = IntentFilter()
        filter.addAction(Intent.ACTION_PACKAGE_ADDED)
        filter.addAction(Intent.ACTION_PACKAGE_REMOVED)
        filter.addDataScheme("package")
        registerReceiver(appChangeReceiver, filter)
    }


    override fun onDestroy() {
        super.onDestroy()
        unregisterReceiver(appChangeReceiver)
    }
//    fun onReceive(context: Context, intent: Intent) {
//        val action = intent.action
//        val data = intent.data
//
//        val methodChannel =
//            flutterEngine?.dartExecutor?.let { MethodChannel(it.binaryMessenger, CHANNEL) }
//
//        if (Intent.ACTION_PACKAGE_ADDED == action) {
//            println("App installed: $data")
//            methodChannel?.invokeMethod("appInstalled", data.toString())
//        } else if (Intent.ACTION_PACKAGE_REMOVED == action) {
//            println("App uninstalled: $data")
//            methodChannel?.invokeMethod("appUninstalled", data.toString())
//        }
//    }


    @RequiresApi(Build.VERSION_CODES.TIRAMISU)
    @SuppressLint("WrongConstant")
    private fun expandNotif() {
        val currentApiVersion = Build.VERSION.SDK_INT
        try {
            val service = getSystemService(Context.STATUS_BAR_SERVICE)
            val statusbarManager = Class.forName("android.app.StatusBarManager")

            val expandMethod: Method =
                    if (currentApiVersion <= Build.VERSION_CODES.N) {
                        statusbarManager.getMethod(EXPAND_METHOD)
                    } else {
                        statusbarManager.getMethod(EXPAND_NOTIFICATIONS_PANEL_METHOD)
                    }

            expandMethod.invoke(service)
        } catch (e: Exception) {
            // Handle exception appropriately for your application
        }
    }

    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    private fun resetPreferredLauncherAndOpenChooserNew(context: Context) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
            val packageManager = context.packageManager
            val componentName = ComponentName(context, FakeLauncherActivity::class.java)
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
        } else {
            val roleManager = activity.getSystemService(ROLE_SERVICE) as RoleManager
            if (!roleManager.isRoleAvailable(RoleManager.ROLE_HOME) ||
                            roleManager.isRoleHeld(RoleManager.ROLE_HOME)
            ) {
                return
            }
            activity.startActivityForResult(
                    roleManager.createRequestRoleIntent(RoleManager.ROLE_HOME),
                    ROLE_HOME_REQUEST_CODE
            )
        }
    }

    private fun getStatusBarHeight(): Double {
        val rectangle = Rect()
        // This line do not work since AndroidUtils do not inherit from Activity
        // This line do not work since AndroidUtils do not inherit from Activity
        val window = window
        window.decorView.getWindowVisibleDisplayFrame(rectangle)
        val statusBarHeight = rectangle.top
        val contentViewTop = window.findViewById<View>(Window.ID_ANDROID_CONTENT).top
        val px = contentViewTop - statusBarHeight
        val metrics = context.resources.displayMetrics
        val dp = px / (metrics.densityDpi.toDouble() / DisplayMetrics.DENSITY_DEFAULT)
        return dp
    }
    private fun getNavigationBarHeight(): Double {
        val rectangle = Rect()
        // This line do not work since AndroidUtils do not inherit from Activity
        // This line do not work since AndroidUtils do not inherit from Activity
        val window = window
        window.decorView.getWindowVisibleDisplayFrame(rectangle)
        val navBarHeight = rectangle.bottom
        val contentViewTop = window.findViewById<View>(Window.ID_ANDROID_CONTENT).bottom
        val px = contentViewTop - navBarHeight
        val metrics = context.resources.displayMetrics
        val dp = px / (metrics.densityDpi.toDouble() / DisplayMetrics.DENSITY_DEFAULT)
        return dp
    }

    private fun getScreenWidth(): Double {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            val windowMetrics = windowManager.currentWindowMetrics
            val insets = windowMetrics.windowInsets.getInsetsIgnoringVisibility(WindowInsets.Type.systemBars())
            val widthPx = windowMetrics.bounds.width().toDouble() - insets.left.toDouble() - insets.right.toDouble()
            val metrics = context.resources.displayMetrics
            val widthDp = widthPx / (metrics.densityDpi.toDouble() / DisplayMetrics.DENSITY_DEFAULT)
            widthDp
        } else {
            val displayMetrics = DisplayMetrics()
            windowManager.defaultDisplay.getMetrics(displayMetrics)
            val widthPx = displayMetrics.widthPixels
            (widthPx / displayMetrics.density).toDouble()
        }
    }

}


// package com.example.flutter_launcher

// import android.annotation.SuppressLint
// import android.app.role.RoleManager
// import android.content.ComponentName
// import android.content.Context
// import android.content.Intent
// import android.content.pm.PackageManager
// import android.os.Build
// import android.os.Bundle
// import androidx.annotation.RequiresApi
// import io.flutter.embedding.android.FlutterActivity
// import io.flutter.embedding.android.FlutterActivityLaunchConfigs.BackgroundMode.transparent
// import io.flutter.embedding.engine.FlutterEngine
// import io.flutter.plugin.common.MethodCall
// import io.flutter.plugin.common.MethodChannel
// import java.lang.reflect.Method

// class MainActivity: FlutterActivity() {
//     private val settingsChannel = "settings_channel"

//     @RequiresApi(Build.VERSION_CODES.TIRAMISU)
//     override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//         super.configureFlutterEngine(flutterEngine)

//         MethodChannel(flutterEngine.dartExecutor.binaryMessenger,
// settingsChannel).setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
//             when (call.method) {
//                 "showNotificationPanel" -> {
//                     expandNotif()
//                     result.success(null)
//                 }
//                 "setDefaultLauncher" -> {
//                     resetPreferredLauncherAndOpenChooserNew(context)
//                 }
//                 else -> {
//                     result.notImplemented()
//                 }
//             }
//         }
//     }

//    override fun onCreate(savedInstanceState: Bundle?) {
//        intent.putExtra("background_mode", transparent.toString())
//        super.onCreate(savedInstanceState)
//    }

//     @RequiresApi(Build.VERSION_CODES.TIRAMISU)
//     @SuppressLint("WrongConstant")
//     private fun expandNotif() {
//         val currentApiVersion = Build.VERSION.SDK_INT
//         try {
//             val service = getSystemService(Context.STATUS_BAR_SERVICE)
//             val statusbarManager = Class.forName("android.app.StatusBarManager")

//             val expandMethod: Method = if (currentApiVersion <= Build.VERSION_CODES.N) {
//                 statusbarManager.getMethod("expand")
//             } else {
//                 statusbarManager.getMethod("expandNotificationsPanel")
//             }

//             expandMethod.invoke(service)
//         } catch (e: Exception) {
//             e.printStackTrace()
//         }
//     }

//     // @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
// //     private fun displayDefaultLauncherChooser() {
// // //        val intent = Intent(Intent.ACTION_MAIN)
// // //        intent.addCategory(Intent.CATEGORY_HOME)
// // //        intent.addCategory(Intent.CATEGORY_DEFAULT)
// // //        intent.flags = Intent.FLAG_ACTIVITY_NEW_DOCUMENT
// // //        startActivity(intent)
// // //
// // //        val startMain = Intent(Intent.ACTION_MAIN)
// // //        startMain.addCategory(Intent.CATEGORY_HOME)
// // //        startMain.flags = Intent.FLAG_ACTIVITY_NEW_TASK
// // //        startActivity(startMain)

// //     }

//     @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
//     private fun resetPreferredLauncherAndOpenChooserNew(context: Context) {
//         if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
//             val packageManager = context.packageManager
//             val componentName =
//                 ComponentName(context, FakeLauncherActivity::class.java)
//             packageManager.setComponentEnabledSetting(
//                 componentName,
//                 PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
//                 PackageManager.DONT_KILL_APP
//             )
//             val selector = Intent(Intent.ACTION_MAIN)
//             selector.addCategory(Intent.CATEGORY_HOME)
//             selector.flags = Intent.FLAG_ACTIVITY_NEW_TASK
//             context.startActivity(selector)
//             packageManager.setComponentEnabledSetting(
//                 componentName,
//                 PackageManager.COMPONENT_ENABLED_STATE_DEFAULT,
//                 PackageManager.DONT_KILL_APP
//             )
//         }else {
//             val roleManager = activity.getSystemService(
//                 ROLE_SERVICE
//             ) as RoleManager
//             if (!roleManager.isRoleAvailable(RoleManager.ROLE_HOME) ||
//                 roleManager.isRoleHeld(RoleManager.ROLE_HOME)
//             ) {
//                 return
//             }
//             activity.startActivityForResult(
//                 roleManager.createRequestRoleIntent(
//                     RoleManager.ROLE_HOME
//                 ),
//                 1
//             )
//         }

//     }
//     private fun resetPreferredLauncherAndOpenChooser(context: Context) {
//          val packageManager: PackageManager = context.packageManager
//          val componentName = ComponentName(context, FakeLauncherActivity::class.java)

//          // Enable the fake launcher activity
//          packageManager.setComponentEnabledSetting(
//              componentName,
//              PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
//              PackageManager.DONT_KILL_APP
//          )

//          // Launch the home chooser activity
//          val selector = Intent(Intent.ACTION_MAIN)
//              .addCategory(Intent.CATEGORY_HOME)
//              .setFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
//          context.startActivity(selector)

//          // Set the fake launcher activity back to default
//          packageManager.setComponentEnabledSetting(
//              componentName,
//              PackageManager.COMPONENT_ENABLED_STATE_DEFAULT,
//              PackageManager.DONT_KILL_APP
//          )

//     }

// }
