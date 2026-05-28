// Path: android/app/src/main/kotlin/com/mt5clone/OandaStreamingService.kt
// ============================================================
// MT5 Clone — OANDA Streaming Foreground Service
// Minimal foreground service for stream monitoring.
// ============================================================

package com.mt5clone

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Intent
import android.os.IBinder

class OandaStreamingService : Service() {

    companion object {
        const val CHANNEL_ID = "price_stream_channel"
        const val NOTIFICATION_ID = 1002
        private var isRunning = false
        fun isServiceRunning(): Boolean = isRunning
    }

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val instrumentCount = intent?.getIntExtra("instrumentCount", 0) ?: 0
        startForeground(NOTIFICATION_ID, buildNotification(instrumentCount))
        isRunning = true
        return START_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onDestroy() {
        isRunning = false
        super.onDestroy()
    }

    private fun createNotificationChannel() {
        val channel = NotificationChannel(
            CHANNEL_ID,
            "Price Stream",
            NotificationManager.IMPORTANCE_MIN
        ).apply {
            description = "OANDA price stream status"
            setShowBadge(false)
        }
        val manager = getSystemService(NotificationManager::class.java)
        manager.createNotificationChannel(channel)
    }

    private fun buildNotification(instrumentCount: Int): Notification {
        val openIntent = Intent(this, MainActivity::class.java)
        val pendingOpen = PendingIntent.getActivity(
            this, 0, openIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        return Notification.Builder(this, CHANNEL_ID)
            .setContentTitle("MT5 Clone")
            .setContentText("Price Stream Active • $instrumentCount instruments")
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setContentIntent(pendingOpen)
            .setOngoing(true)
            .build()
    }

    fun updateInstrumentCount(count: Int) {
        val manager = getSystemService(NotificationManager::class.java)
        manager.notify(NOTIFICATION_ID, buildNotification(count))
    }
}
