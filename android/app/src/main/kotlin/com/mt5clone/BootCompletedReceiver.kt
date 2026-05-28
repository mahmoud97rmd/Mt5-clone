// Path: android/app/src/main/kotlin/com/mt5clone/BootCompletedReceiver.kt
// ============================================================
// MT5 Clone — Boot Completed Receiver
// Auto-restarts EA engine on device reboot.
// ============================================================

package com.mt5clone

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences

class BootCompletedReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Intent.ACTION_BOOT_COMPLETED ||
            intent.action == "android.intent.action.QUICKBOOT_POWERON") {

            val prefs: SharedPreferences = context.getSharedPreferences(
                "mt5_prefs", Context.MODE_PRIVATE
            )
            val wasRunning = prefs.getBoolean("ea_was_running", false)

            if (wasRunning) {
                val serviceIntent = Intent(context, EaEngineService::class.java).apply {
                    action = EaEngineService.ACTION_START_EA
                }
                context.startForegroundService(serviceIntent)

                // Reset flag
                prefs.edit().putBoolean("ea_was_running", false).apply()
            }
        }
    }
}
