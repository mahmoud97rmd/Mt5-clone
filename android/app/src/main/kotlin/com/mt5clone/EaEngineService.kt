// Path: android/app/src/main/kotlin/com/mt5clone/EaEngineService.kt
// ============================================================
// MT5 Clone — EA Engine Foreground Service
// Manages background execution of Expert Advisors.
// Survives app swipe (stopWithTask=false).
// ============================================================

package com.mt5clone

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.IBinder
import android.os.PowerManager
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

class EaEngineService : Service() {

    companion object {
        const val CHANNEL_ID = "ea_engine_channel"
        const val NOTIFICATION_ID = 1001
        const val ACTION_START_EA = "com.mt5clone.START_EA"
        const val ACTION_STOP_EA = "com.mt5clone.STOP_EA"
        const val ACTION_PAUSE_EA = "com.mt5clone.PAUSE_EA"
        const val ACTION_RESUME_EA = "com.mt5clone.RESUME_EA"
        const val ACTION_KILL_SWITCH = "com.mt5clone.KILL_SWITCH"
        const val ACTION_STREAM_CONNECTED = "com.mt5clone.STREAM_CONNECTED"
        const val ACTION_STREAM_DISCONNECTED = "com.mt5clone.STREAM_DISCONNECTED"

        private var isRunning = false
        fun isServiceRunning(): Boolean = isRunning
    }

    private var wakeLock: PowerManager.WakeLock? = null
    private var flutterEngine: FlutterEngine? = null
    private var methodChannel: MethodChannel? = null

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
        acquireWakeLock()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val action = intent?.action

        when (action) {
            ACTION_START_EA -> {
                val eaId = intent.getIntExtra("eaId", -1)
                val symbol = intent.getStringExtra("symbol") ?: ""
                startForeground(NOTIFICATION_ID, buildNotification("EA Running: $symbol"))
                isRunning = true
                // Dispatch to Flutter
                methodChannel?.invokeMethod("onEaStarted", mapOf("eaId" to eaId))
            }
            ACTION_STOP_EA -> {
                val eaId = intent.getIntExtra("eaId", -1)
                methodChannel?.invokeMethod("onEaStopped", mapOf("eaId" to eaId))
                stopSelf()
            }
            ACTION_PAUSE_EA -> {
                val eaId = intent.getIntExtra("eaId", -1)
                methodChannel?.invokeMethod("onEaPaused", mapOf("eaId" to eaId))
            }
            ACTION_RESUME_EA -> {
                val eaId = intent.getIntExtra("eaId", -1)
                methodChannel?.invokeMethod("onEaResumed", mapOf("eaId" to eaId))
            }
            ACTION_KILL_SWITCH -> {
                methodChannel?.invokeMethod("onKillSwitch", null)
                stopSelf()
            }
            ACTION_STREAM_CONNECTED -> {
                updateNotification("Stream connected")
            }
            ACTION_STREAM_DISCONNECTED -> {
                updateNotification("Stream disconnected — monitoring")
            }
        }

        return START_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onDestroy() {
        isRunning = false
        releaseWakeLock()
        super.onDestroy()
    }

    override fun onTaskRemoved(rootIntent: Intent?) {
        // Service survives app swipe (stopWithTask=false in manifest)
        super.onTaskRemoved(rootIntent)
    }

    private fun createNotificationChannel() {
        val channel = NotificationChannel(
            CHANNEL_ID,
            "EA Engine",
            NotificationManager.IMPORTANCE_LOW
        ).apply {
            description = "Expert Advisor background execution"
            setShowBadge(false)
        }
        val manager = getSystemService(NotificationManager::class.java)
        manager.createNotificationChannel(channel)
    }

    private fun buildNotification(content: String): Notification {
        val openIntent = Intent(this, MainActivity::class.java)
        val pendingOpen = PendingIntent.getActivity(
            this, 0, openIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val stopIntent = Intent(this, EaEngineService::class.java).apply {
            action = ACTION_STOP_EA
        }
        val pendingStop = PendingIntent.getService(
            this, 1, stopIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val killIntent = Intent(this, EaEngineService::class.java).apply {
            action = ACTION_KILL_SWITCH
        }
        val pendingKill = PendingIntent.getService(
            this, 2, killIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        return Notification.Builder(this, CHANNEL_ID)
            .setContentTitle("MT5 Clone — EA Engine")
            .setContentText(content)
            .setSmallIcon(android.R.drawable.ic_media_play)
            .setContentIntent(pendingOpen)
            .addAction(Notification.Action.Builder(
                null, "Stop", pendingStop
            ).build())
            .addAction(Notification.Action.Builder(
                null, "Kill", pendingKill
            ).build())
            .setOngoing(true)
            .build()
    }

    private fun updateNotification(content: String) {
        val manager = getSystemService(NotificationManager::class.java)
        manager.notify(NOTIFICATION_ID, buildNotification(content))
    }

    private fun acquireWakeLock() {
        val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
        wakeLock = pm.newWakeLock(
            PowerManager.PARTIAL_WAKE_LOCK,
            "MT5Clone::EaEngineWakeLock"
        ).apply {
            acquire(24 * 60 * 60 * 1000L) // 24 hours
        }
    }

    private fun releaseWakeLock() {
        wakeLock?.let {
            if (it.isHeld) it.release()
        }
        wakeLock = null
    }
}
