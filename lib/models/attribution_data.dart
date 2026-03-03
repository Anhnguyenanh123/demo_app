import 'dart:convert';

class AttributionData {
  final String? fullUri;
  final Map<String, String>? queryParams;
  final String? installReferrer;
  final String? referrerClickTimestamp;
  final String? installTimestamp;
  final String? utmSource;
  final String? utmCampaign;
  final String? utmMedium;

  AttributionData({
    this.fullUri,
    this.queryParams,
    this.installReferrer,
    this.referrerClickTimestamp,
    this.installTimestamp,
    this.utmSource,
    this.utmCampaign,
    this.utmMedium,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullUri': fullUri,
      'queryParams': queryParams,
      'installReferrer': installReferrer,
      'referrerClickTimestamp': referrerClickTimestamp,
      'installTimestamp': installTimestamp,
      'utmSource': utmSource,
      'utmCampaign': utmCampaign,
      'utmMedium': utmMedium,
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
    String? utmSource,
    String? utmCampaign,
    String? utmMedium,
  }) {
    return AttributionData(
      fullUri: fullUri ?? this.fullUri,
      queryParams: queryParams ?? this.queryParams,
      installReferrer: installReferrer ?? this.installReferrer,
      referrerClickTimestamp:
          referrerClickTimestamp ?? this.referrerClickTimestamp,
      installTimestamp: installTimestamp ?? this.installTimestamp,
      utmSource: utmSource ?? this.utmSource,
      utmCampaign: utmCampaign ?? this.utmCampaign,
      utmMedium: utmMedium ?? this.utmMedium,
    );
  }
}
