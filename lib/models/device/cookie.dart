class Cookie {
  final bool isEssentialGranted;
  final bool isAdvertisingGranted;
  final bool isAnalyticsGranted;
  final bool isRejected;

  Cookie({
    required this.isEssentialGranted,
    required this.isAdvertisingGranted,
    required this.isAnalyticsGranted,
    required this.isRejected
  });

  factory Cookie.fromJson(Map<String, dynamic> json) {
    return Cookie(
      isEssentialGranted: json["is_essential_granted"] ?? false,
      isAdvertisingGranted: json["is_advertising_granted"] ?? false,
      isAnalyticsGranted: json["is_analytics_granted"] ?? false,
      isRejected: json["is_rejected"] ?? false,
    );
  }

  Cookie copyWith({
    bool? isEssentialGranted,
    bool? isAdvertisingGranted,
    bool? isAnalyticsGranted,
    bool? isRejected
  }) {
    return Cookie(
      isEssentialGranted: isEssentialGranted ?? this.isEssentialGranted,
      isAdvertisingGranted: isAdvertisingGranted ?? this.isAdvertisingGranted,
      isAnalyticsGranted: isAnalyticsGranted ?? this.isAnalyticsGranted,
      isRejected: isRejected ?? this.isRejected
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "is_essential_granted": isEssentialGranted,
      "is_advertising_granted": isAdvertisingGranted,
      "is_analytics_granted": isAnalyticsGranted,
      "is_rejected": isRejected
    };
  }

  factory Cookie.empty() {
    return Cookie(isEssentialGranted: false, isAdvertisingGranted: false, isAnalyticsGranted: false, isRejected: false);
  }
}