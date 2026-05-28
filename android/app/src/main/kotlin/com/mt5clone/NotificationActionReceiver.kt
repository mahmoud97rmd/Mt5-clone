// Path: android/app/src/main/kotlin/com/mt5clone/NotificationActionReceiver.kt
// ============================================================
// MT5 Clone — Notification Action Receiver
// Handles taps on foreground service notification buttons.
// ============================================================

package com.mt5clone

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class NotificationActionReceiver : BroadcastReceiver() {

    companion object {
        const val ACTION_NOTIFICATION_STOP = "com.mt5clone.NOTIFICATION_STOP"
        const val ACTION_NOTIFICATION_VIEW = "com.mt5clone.NOTIFICATION_VIEW"
        const val ACTION_NOTIFICATION_KILL = "com.mt5clone.NOTIFICATION_KILL"
    }

    override fun onReceive(context: Context, intent: Intent) {
        when (intent.action) {
            ACTION_NOTIFICATION_STOP -> {
                val eaId = intent.getIntExtra("eaId", -1)
                val stopIntent = Intent(context, EaEngineService::class.java).apply {
                    action = EaEngineService.ACTION_STOP_EA
                    putExtra("eaId", eaId)
                }
                context.startService(stopIntent)
            }
            ACTION_NOTIFICATION_VIEW -> {
                val openIntent = Intent(context, MainActivity::class.java).apply {
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                }
                context.startActivity(openIntent)
            }
            ACTION_NOTIFICATION_KILL -> {
                val killIntent = Intent(context, EaEngineService::class.java).apply {
                    action = EaEngineService.ACTION_KILL_SWITCH
                }
                context.startService(killIntent)
            }
        }
    }
}
