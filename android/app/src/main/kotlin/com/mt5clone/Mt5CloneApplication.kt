// Path: android/app/src/main/kotlin/com/mt5clone/Mt5CloneApplication.kt
// ============================================================
// MT5 Clone — Application Class
// Responsibilities:
//   1. Initialize Chaquopy Python runtime FIRST (before everything)
//   2. Initialize Hilt dependency injection
//   3. Create notification channels for EA Engine service
//   4. Configure WakeLock manager
//   5. Set up crash/error handling
// ============================================================

package com.mt5clone

import android.app.Application
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import androidx.core.content.getSystemService
import com.chaquo.python.Python
import com.chaquo.python.android.AndroidPlatform
import dagger.hilt.android.HiltAndroidApp

/**
 * 1.4.1 — @HiltAndroidApp triggers Hilt's code generation,
 * enabling dependency injection throughout the application.
 *
 * ⭐ This class must be registered in AndroidManifest.xml as:
 *    android:name=".Mt5CloneApplication"
 */
@HiltAndroidApp
class Mt5CloneApplication : Application() {

    override fun onCreate() {
        super.onCreate()

        // --------------------------------------------------------
        // 1.4.2 — Initialize Chaquopy Python Runtime
        // ⭐ MUST be called before any Python.getInstance() calls
        // This loads the CPython interpreter into the JVM
        // Chaquopy handles: stdlib, pip packages, user EA scripts
        // --------------------------------------------------------
        initializePythonRuntime()

        // --------------------------------------------------------
        // 1.4.3 — Create Android Notification Channels
        // Required on Android 8+ (Oreo / API 26+)
        // Channels must be created before posting any notifications
        // --------------------------------------------------------
        createNotificationChannels()

        // --------------------------------------------------------
        // 1.4.4 — Configure Global Error Handler
        // Catches uncaught exceptions and logs them
        // In production, this would report to Crashlytics
        // --------------------------------------------------------
        configureGlobalErrorHandler()
    }

    // --------------------------------------------------------
    // 1.4.5 — Python Runtime Initialization
    // --------------------------------------------------------
    private fun initializePythonRuntime() {
        // Safety check: only initialize once
        if (!Python.isStarted()) {
            try {
                // AndroidPlatform provides Android-specific Python environment:
                // - Correct file paths for bundled Python stdlib
                // - Android asset manager for accessing bundled scripts
                // - Proper JVM ↔ CPython bridge initialization
                Python.start(AndroidPlatform(this))

                android.util.Log.i(
                    TAG,
                    "✅ Chaquopy Python ${Python.getInstance().getModule("sys").callAttr("version")} initialized"
                )
            } catch (e: Exception) {
                android.util.Log.e(TAG, "❌ Failed to initialize Chaquopy Python runtime", e)
                // Note: App can still run without Python — EA Engine will be disabled
                // Flutter UI will show "EA Engine Unavailable" state
            }
        }
    }

    // --------------------------------------------------------
    // 1.4.6 — Notification Channel Creation
    // --------------------------------------------------------
    private fun createNotificationChannels() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return

        val notificationManager = getSystemService<NotificationManager>() ?: return

        // ---- EA Engine Channel (HIGH importance — persistent notification) ----
        val eaEngineChannel = NotificationChannel(
            CHANNEL_ID_EA_ENGINE,
            getString(R.string.ea_notification_channel_name),
            // HIGH importance: shows in status bar, makes sound on first creation
            // We use DEFAULT (not HIGH) to avoid constant sound notifications
            NotificationManager.IMPORTANCE_LOW  // Silent but visible
        ).apply {
            description = getString(R.string.ea_notification_channel_desc)
            setShowBadge(false)         // No badge on launcher icon
            enableLights(true)
            lightColor = 0xFF00D4AA.toInt()  // Teal light color
            enableVibration(false)      // No vibration for persistent service
            setSound(null, null)        // Silent
            lockscreenVisibility = NotificationManager.IMPORTANCE_LOW
        }

        // ---- Trade Alerts Channel (HIGH importance — trade executions) ----
        val tradeAlertsChannel = NotificationChannel(
            CHANNEL_ID_TRADE_ALERTS,
            "Trade Alerts",
            NotificationManager.IMPORTANCE_HIGH
        ).apply {
            description = "Notifications for trade executions, SL/TP hits, and EA events"
            setShowBadge(true)
            enableLights(true)
            lightColor = 0xFF00FF88.toInt()
            enableVibration(true)
            vibrationPattern = longArrayOf(0, 200, 100, 200)
        }

        // ---- Price Stream Channel (LOW importance — connectivity status) ----
        val priceStreamChannel = NotificationChannel(
            CHANNEL_ID_PRICE_STREAM,
            getString(R.string.stream_notification_channel_name),
            NotificationManager.IMPORTANCE_MIN  // Completely silent, no pop-up
        ).apply {
            description = "OANDA price stream connection status"
            setShowBadge(false)
            enableLights(false)
            enableVibration(false)
            setSound(null, null)
        }

        // ---- General Channel (DEFAULT — app notifications) ----
        val generalChannel = NotificationChannel(
            CHANNEL_ID_GENERAL,
            "General",
            NotificationManager.IMPORTANCE_DEFAULT
        ).apply {
            description = "General app notifications"
        }

        // Register all channels at once
        notificationManager.createNotificationChannels(
            listOf(eaEngineChannel, tradeAlertsChannel, priceStreamChannel, generalChannel)
        )

        android.util.Log.i(TAG, "✅ Notification channels created (${notificationManager.notificationChannels.size} total)")
    }

    // --------------------------------------------------------
    // 1.4.7 — Global Error Handler
    // --------------------------------------------------------
    private fun configureGlobalErrorHandler() {
        val defaultHandler = Thread.getDefaultUncaughtExceptionHandler()

        Thread.setDefaultUncaughtExceptionHandler { thread, throwable ->
            android.util.Log.e(
                TAG,
                "💥 Uncaught exception on thread [${thread.name}]: ${throwable.message}",
                throwable
            )

            // If EA Engine was running, attempt graceful shutdown
            // to avoid orphaned foreground service notifications
            try {
                val intent = android.content.Intent(
                    this,
                    services.EaEngineService::class.java
                ).apply {
                    action = "com.mt5clone.action.KILL_SWITCH"
                    putExtra("reason", "app_crash")
                }
                startService(intent)
            } catch (e: Exception) {
                // Ignore — we're already in crash state
            }

            // Delegate to default handler (shows crash dialog)
            defaultHandler?.uncaughtException(thread, throwable)
        }
    }

    // --------------------------------------------------------
    // 1.4.8 — Companion Object: Constants
    // --------------------------------------------------------
    companion object {
        private const val TAG = "Mt5CloneApp"

        // Notification Channel IDs — used throughout the app
        const val CHANNEL_ID_EA_ENGINE    = "ea_engine_channel"
        const val CHANNEL_ID_TRADE_ALERTS = "trade_alerts_channel"
        const val CHANNEL_ID_PRICE_STREAM = "price_stream_channel"
        const val CHANNEL_ID_GENERAL      = "general_channel"

        // WakeLock Tag
        const val WAKELOCK_TAG = "MT5Clone::EaEngineWakeLock"

        /**
         * Helper to get the Application instance from any context.
         * Useful in Kotlin extension functions.
         */
        fun getInstance(context: Context): Mt5CloneApplication {
            return context.applicationContext as Mt5CloneApplication
        }
    }
}
