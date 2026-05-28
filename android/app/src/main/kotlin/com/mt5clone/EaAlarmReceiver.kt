// Path: android/app/src/main/kotlin/com/mt5clone/EaAlarmReceiver.kt
// ============================================================
// MT5 Clone — EA Alarm Receiver
// Handles scheduled alarm callbacks for EA tick dispatch.
// ============================================================

package com.mt5clone

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class EaAlarmReceiver : BroadcastReceiver() {

    companion object {
        const val ACTION_EA_ALARM_TICK = "com.mt5clone.EA_ALARM_TICK"
        const val ACTION_EA_SESSION_START = "com.mt5clone.EA_SESSION_START"
        const val ACTION_EA_SESSION_END = "com.mt5clone.EA_SESSION_END"
    }

    override fun onReceive(context: Context, intent: Intent) {
        when (intent.action) {
            ACTION_EA_ALARM_TICK -> {
                // Fallback tick dispatch when stream is unavailable
                val symbol = intent.getStringExtra("symbol") ?: return
                val bid = intent.getDoubleExtra("bid", 0.0)
                val ask = intent.getDoubleExtra("ask", 0.0)
                // Forward to EA engine service
                val serviceIntent = Intent(context, EaEngineService::class.java).apply {
                    action = "DISPATCH_TICK"
                    putExtra("symbol", symbol)
                    putExtra("bid", bid)
                    putExtra("ask", ask)
                }
                context.startService(serviceIntent)
            }
            ACTION_EA_SESSION_START -> {
                android.util.Log.i("EaAlarmReceiver", "Trading session started")
            }
            ACTION_EA_SESSION_END -> {
                android.util.Log.i("EaAlarmReceiver", "Trading session ended")
            }
        }
    }
}
