import 'package:flutter/foundation.dart';
import 'package:app_links/app_links.dart';

class DeepLinkService {
  final _appLinks = AppLinks();

  void init() async {
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      _handle(initialUri.toString());
    }

    _appLinks.uriLinkStream.listen((uri) {
      _handle(uri.toString());
    });
  }

  void _handle(String link) {
    final uri = Uri.parse(link);

    final utmCampaign = uri.queryParameters['utm_campaign'];
    final utmSource = uri.queryParameters['utm_source'];

    debugPrint("=== EXISTING USER ===");
    debugPrint("utm_campaign: $utmCampaign");
    debugPrint("utm_source: $utmSource");
  }
}
