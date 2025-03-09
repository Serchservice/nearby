class GoUserAddonTimeline {
  GoUserAddonTimeline({
    required this.subscribedAt,
    required this.nextBillingDate,
  });

  final String subscribedAt;
  final String nextBillingDate;

  GoUserAddonTimeline copyWith({
    String? subscribedAt,
    String? nextBillingDate,
  }) {
    return GoUserAddonTimeline(
      subscribedAt: subscribedAt ?? this.subscribedAt,
      nextBillingDate: nextBillingDate ?? this.nextBillingDate,
    );
  }

  factory GoUserAddonTimeline.fromJson(Map<String, dynamic> json){
    return GoUserAddonTimeline(
      subscribedAt: json["subscribed_at"] ?? "",
      nextBillingDate: json["next_billing_date"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "subscribed_at": subscribedAt,
    "next_billing_date": nextBillingDate,
  };

  @override
  String toString(){
    return "$subscribedAt, $nextBillingDate, ";
  }
}