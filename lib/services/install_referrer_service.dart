import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class InstallReferrerService {
  static const platform = MethodChannel('install_referrer_channel');

  static Future<void> getReferrer() async {
    try {
      final referrer = await platform.invokeMethod<String>(
        'getInstallReferrer',
      );

      if (referrer != null && referrer.isNotEmpty) {
        final uri = Uri.parse("https://dummy?$referrer");

        final utmCampaign = uri.queryParameters['utm_campaign'];
        final utmSource = uri.queryParameters['utm_source'];

        debugPrint("=== NEW USER INSTALL ===");
        debugPrint("utm_campaign: $utmCampaign");
        debugPrint("utm_source: $utmSource");
      }
    } catch (e) {
      debugPrint("Referrer error: $e");
    }
  }
}
