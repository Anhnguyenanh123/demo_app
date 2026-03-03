import 'dart:convert';

class AttributionData {
  final String? fullUri;
  final Map<String, String>? queryParams;
  final String? installReferrer;
  final String? referrerClickTimestamp;
  final String? installTimestamp;

  AttributionData({
    this.fullUri,
    this.queryParams,
    this.installReferrer,
    this.referrerClickTimestamp,
    this.installTimestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullUri': fullUri,
      'queryParams': queryParams,
      'installReferrer': installReferrer,
      'referrerClickTimestamp': referrerClickTimestamp,
      'installTimestamp': installTimestamp,
    };
  }

  String toJsonString() {
    return const JsonEncoder.withIndent('  ').convert(toJson());
  }

  AttributionData copyWith({
    String? fullUri,
    Map<String, String>? queryParams,
    String? installReferrer,
    String? referrerClickTimestamp,
    String? installTimestamp,
  }) {
    return AttributionData(
      fullUri: fullUri ?? this.fullUri,
      queryParams: queryParams ?? this.queryParams,
      installReferrer: installReferrer ?? this.installReferrer,
      referrerClickTimestamp:
          referrerClickTimestamp ?? this.referrerClickTimestamp,
      installTimestamp: installTimestamp ?? this.installTimestamp,
    );
  }
}
