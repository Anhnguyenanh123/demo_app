import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:app_links/app_links.dart';

class DeepLinkService {
  final _appLinks = AppLinks();
  final _controller = StreamController<Map<String, String?>>.broadcast();

  Stream<Map<String, String?>> get onDeepLink => _controller.stream;

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

    final data = {
      'type': 'EXISTING USER (Deep Link)',
      'full_link': link,
      'utm_campaign': uri.queryParameters['utm_campaign'],
      'utm_source': uri.queryParameters['utm_source'],
      'utm_medium': uri.queryParameters['utm_medium'],
    };

    debugPrint("=== EXISTING USER ===");
    debugPrint("utm_campaign: ${data['utm_campaign']}");
    debugPrint("utm_source: ${data['utm_source']}");

    _controller.add(data);
  }

  void dispose() {
    _controller.close();
  }
}
