import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class InstallReferrerService {
  static const platform = MethodChannel('install_referrer_channel');

  static Future<Map<String, String?>> getReferrer() async {
    try {
      final referrer = await platform.invokeMethod<String>(
        'getInstallReferrer',
      );

      if (referrer != null && referrer.isNotEmpty) {
        final uri = Uri.parse("https://dummy?$referrer");

        final data = {
          'type': 'NEW USER (Install Referrer)',
          'raw_referrer': referrer,
          'utm_campaign': uri.queryParameters['utm_campaign'],
          'utm_source': uri.queryParameters['utm_source'],
          'utm_medium': uri.queryParameters['utm_medium'],
        };

        debugPrint("=== NEW USER INSTALL ===");
        debugPrint("utm_campaign: ${data['utm_campaign']}");
        debugPrint("utm_source: ${data['utm_source']}");

        return data;
      }
    } catch (e) {
      debugPrint("Referrer error: $e");
    }
    return {
      'type': 'NEW USER (Install Referrer)',
      'utm_source': 'N/A',
      'utm_campaign': 'N/A',
    };
  }
}
