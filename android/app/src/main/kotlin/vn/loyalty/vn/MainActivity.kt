package vn.loyalty.vn

import android.os.Bundle
import com.android.installreferrer.api.InstallReferrerClient
import com.android.installreferrer.api.InstallReferrerStateListener
import com.android.installreferrer.api.ReferrerDetails
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    private val CHANNEL = "install_referrer_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "getInstallReferrer") {
                    getInstallReferrer(result)
                }
            }
    }

    private fun getInstallReferrer(result: MethodChannel.Result) {
        val referrerClient = InstallReferrerClient.newBuilder(this).build()

        referrerClient.startConnection(object : InstallReferrerStateListener {
            override fun onInstallReferrerSetupFinished(responseCode: Int) {
                if (responseCode == InstallReferrerClient.InstallReferrerResponse.OK) {
                    val response: ReferrerDetails = referrerClient.installReferrer
                    val referrerUrl = response.installReferrer
                    result.success(referrerUrl)
                    referrerClient.endConnection()
                } else {
                    result.error("ERROR", "Referrer not available", null)
                }
            }

            override fun onInstallReferrerServiceDisconnected() {}
        })
    }
}