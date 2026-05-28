// Path: android/app/src/main/kotlin/com/mt5clone/NetworkStateReceiver.kt
// ============================================================
// MT5 Clone — Network State Receiver
// Monitors connectivity changes for EA kill switch.
// ============================================================

package com.mt5clone

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.net.ConnectivityManager
import android.net.NetworkCapabilities

class NetworkStateReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == ConnectivityManager.CONNECTIVITY_ACTION) {
            val cm = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
            val network = cm.activeNetwork
            val capabilities = network?.let { cm.getNetworkCapabilities(it) }
            val isConnected = capabilities?.hasCapability(
                NetworkCapabilities.NET_CAPABILITY_INTERNET
            ) == true

            if (isConnected) {
                // Network restored — cancel kill switch timers
                val reconnectIntent = Intent(context, EaEngineService::class.java).apply {
                    action = EaEngineService.ACTION_STREAM_CONNECTED
                }
                context.startService(reconnectIntent)
            } else {
                // Network lost — kill switch timer will handle timeout
                val disconnectIntent = Intent(context, EaEngineService::class.java).apply {
                    action = EaEngineService.ACTION_STREAM_DISCONNECTED
                }
                context.startService(disconnectIntent)
            }
        }
    }
}
