import 'dart:async';
import 'dart:io';
import 'package:android_play_install_referrer/android_play_install_referrer.dart';
import 'package:app_links/app_links.dart';
import 'package:install_referrer/install_referrer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/attribution_data.dart';

class AttributionService {
  static const String _keyReferrerRead = 'referrer_read_v1';
  static const String _keyFirstReferrer = 'first_referrer_data';

  final _appLinks = AppLinks();
  final _attributionController = StreamController<AttributionData>.broadcast();

  AttributionData _currentData = AttributionData();
  StreamSubscription<Uri>? _linkSubscription;

  Stream<AttributionData> get attributionStream =>
      _attributionController.stream;
  AttributionData get currentData => _currentData;

  Future<void> init() async {
    await _initReferrer();
    await _initDeepLinks();
  }

  Future<void> _initReferrer() async {
    if (!Platform.isAndroid) return;

    final prefs = await SharedPreferences.getInstance();
    final alreadyRead = prefs.getBool(_keyReferrerRead) ?? false;

    if (alreadyRead) {
      final savedReferrer = prefs.getString(_keyFirstReferrer);
      if (savedReferrer != null) {
        _currentData = _currentData.copyWith(installReferrer: savedReferrer);
        _attributionController.add(_currentData);
      }
      return;
    }

    try {
      // 1. Get the source using install_referrer (standard enum)
      final source = await InstallReferrer.referrer;

      // 2. Get raw details using android_play_install_referrer (Android only)
      String referrerString = source.toString();
      String? clickTime;
      String? installTime;

      try {
        final details = await AndroidPlayInstallReferrer.installReferrer;
        referrerString = details.installReferrer ?? source.toString();
        clickTime = details.referrerClickTimestampSeconds.toString();
        installTime = details.installBeginTimestampSeconds.toString();
      } catch (e) {
        // Fallback to source enum name if Play API fails
      }

      _currentData = _currentData.copyWith(
        installReferrer: referrerString,
        referrerClickTimestamp: clickTime,
        installTimestamp: installTime,
      );

      await prefs.setBool(_keyReferrerRead, true);
      await prefs.setString(_keyFirstReferrer, referrerString);

      _attributionController.add(_currentData);
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _initDeepLinks() async {
    // Handle cold start
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _updateWithUri(initialUri);
      }
    } catch (e) {
      // Handle error without print
    }

    // Handle background/foreground links
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (uri) {
        _updateWithUri(uri);
      },
      onError: (err) {
        // Handle error without print
      },
    );
  }

  void _updateWithUri(Uri uri) {
    _currentData = _currentData.copyWith(
      fullUri: uri.toString(),
      queryParams: uri.queryParameters,
    );
    _attributionController.add(_currentData);
  }

  void dispose() {
    _linkSubscription?.cancel();
    _attributionController.close();
  }
}
