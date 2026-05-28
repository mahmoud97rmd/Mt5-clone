// Path: android/app/src/main/kotlin/com/mt5clone/MainActivity.kt
// ============================================================
// MT5 Clone — Main Flutter Activity
// Responsibilities:
//   1. Host Flutter engine
//   2. Register all MethodChannels (Flutter ↔ Kotlin bridge)
//   3. Handle runtime permission requests
//   4. Manage battery optimization bypass flow
//   5. Bridge EA Engine start/stop to Flutter UI
// ============================================================

package com.mt5clone

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.PowerManager
import android.provider.Settings
import androidx.core.content.getSystemService
import com.mt5clone.channels.EaEngineChannel
import com.mt5clone.channels.OandaStreamChannel
import com.mt5clone.channels.PermissionsChannel
import com.mt5clone.channels.FilePickerChannel
import dagger.hilt.android.AndroidEntryPoint
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import javax.inject.Inject

/**
 * 1.4.9 — @AndroidEntryPoint enables Hilt injection into this Activity.
 * FlutterActivity is the base class that hosts the Flutter engine.
 */
@AndroidEntryPoint
class MainActivity : FlutterActivity() {

    // --------------------------------------------------------
    // 1.4.10 — Injected Channel Handlers
    // Each channel handles a specific feature domain
    // --------------------------------------------------------
    @Inject lateinit var eaEngineChannel: EaEngineChannel
    @Inject lateinit var oandaStreamChannel: OandaStreamChannel
    @Inject lateinit var permissionsChannel: PermissionsChannel
    @Inject lateinit var filePickerChannel: FilePickerChannel

    override fun onCreate(savedInstanceState: Bundle?) {
        // Apply the normal (non-launch) theme before Flutter renders
        // This prevents a white flash on some devices
        setTheme(R.style.NormalTheme)
        super.onCreate(savedInstanceState)
    }

    // --------------------------------------------------------
    // 1.4.11 — Flutter Engine Configuration
    // This is called once when the Flutter engine is attached.
    // Register all MethodChannels here.
    // --------------------------------------------------------
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val messenger = flutterEngine.dartExecutor.binaryMessenger

        // ---- Register: EA Engine Channel ----
        // Handles: start EA, stop EA, upload script, get logs, kill switch
        eaEngineChannel.register(messenger, this)

        // ---- Register: OANDA Stream Channel ----
        // Handles: connect/disconnect WebSocket, get latest tick
        oandaStreamChannel.register(messenger)

        // ---- Register: Permissions Channel ----
        // Handles: request battery optimization, storage, notification perms
        permissionsChannel.register(messenger, this)

        // ---- Register: File Picker Channel ----
        // Handles: .py file selection from device storage
        filePickerChannel.register(messenger, this)

        // ---- Register: Battery Optimization Channel ----
        // Inline registration for simple battery check
        MethodChannel(
            messenger,
            CHANNEL_BATTERY_OPTIMIZATION
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "isIgnoringBatteryOptimizations" -> {
                    result.success(isIgnoringBatteryOptimizations())
                }
                "requestBatteryOptimizationExemption" -> {
                    requestBatteryOptimizationExemption()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }

        android.util.Log.i(TAG, "✅ All Flutter MethodChannels registered")
    }

    // --------------------------------------------------------
    // 1.4.12 — Battery Optimization Helpers
    // --------------------------------------------------------

    /**
     * Check if this app is currently excluded from battery optimization.
     * Returns true if the EA can run without Doze mode interference.
     */
    private fun isIgnoringBatteryOptimizations(): Boolean {
        val powerManager = getSystemService<PowerManager>() ?: return false
        return powerManager.isIgnoringBatteryOptimizations(packageName)
    }

    /**
     * Launch the battery optimization exemption settings screen.
     * This opens Android's "Battery optimization" page directly to this app,
     * allowing the user to tap "Don't optimize" with one tap.
     */
    private fun requestBatteryOptimizationExemption() {
        if (isIgnoringBatteryOptimizations()) {
            android.util.Log.i(TAG, "Already excluded from battery optimization")
            return
        }

        try {
            // Direct intent to app-specific battery settings
            val intent = Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS).apply {
                data = Uri.parse("package:$packageName")
            }
            startActivity(intent)
        } catch (e: Exception) {
            android.util.Log.w(TAG, "Could not open battery optimization settings directly, falling back")
            // Fallback: open general battery optimization list
            try {
                startActivity(Intent(Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS))
            } catch (e2: Exception) {
                android.util.Log.e(TAG, "Could not open battery settings at all", e2)
            }
        }
    }

    // --------------------------------------------------------
    // 1.4.13 — Activity Result Handling
    // For file picker results and permission results
    // --------------------------------------------------------
    @Deprecated("Deprecated in Java")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        // Delegate to file picker channel handler
        filePickerChannel.onActivityResult(requestCode, resultCode, data)
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        permissionsChannel.onRequestPermissionsResult(requestCode, permissions, grantResults)
    }

    // --------------------------------------------------------
    // 1.4.14 — Lifecycle
    // --------------------------------------------------------
    override fun onDestroy() {
        super.onDestroy()
        android.util.Log.i(TAG, "MainActivity destroyed — EA Engine service continues in background")
        // Note: We do NOT stop the EA Engine here.
        // The Foreground Service continues running independently.
    }

    companion object {
        private const val TAG = "MainActivity"

        // MethodChannel names — must match exactly in Flutter Dart code
        const val CHANNEL_EA_ENGINE            = "com.mt5clone/ea_engine"
        const val CHANNEL_OANDA_STREAM         = "com.mt5clone/oanda_stream"
        const val CHANNEL_OANDA_STREAM_EVENTS  = "com.mt5clone/oanda_stream_events"
        const val CHANNEL_PERMISSIONS          = "com.mt5clone/permissions"
        const val CHANNEL_FILE_PICKER          = "com.mt5clone/file_picker"
        const val CHANNEL_BATTERY_OPTIMIZATION = "com.mt5clone/battery"
        const val CHANNEL_EA_LOGS_EVENTS       = "com.mt5clone/ea_log_events"
    }
}
