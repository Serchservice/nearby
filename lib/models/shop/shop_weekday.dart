class ShopWeekday {
  ShopWeekday({
    required this.day,
    required this.opening,
    required this.closing,
    required this.open,
    required this.id
  });

  final String day;
  final String opening;
  final String closing;
  final bool open;
  final int id;

  ShopWeekday copyWith({
    String? day,
    String? opening,
    String? closing,
    bool? open,
    int? id,
  }) {
    return ShopWeekday(
      day: day ?? this.day,
      opening: opening ?? this.opening,
      closing: closing ?? this.closing,
      open: open ?? this.open,
      id: id ?? this.id,
    );
  }

  factory ShopWeekday.fromJson(Map<String, dynamic> json) {
    return ShopWeekday(
      day: json["day"] ?? "",
      opening: json["opening"] ?? "",
      closing: json["closing"] ?? "",
      open: json["open"] ?? false,
      id: json["id"] ?? 0
    );
  }

  factory ShopWeekday.empty() {
    return ShopWeekday.fromJson({
      "day": "",
      "opening": "",
      "closing": "",
      "open": false,
      "id": 0
    });
  }

  Map<String, dynamic> toJson() => {
    "day": day,
    "opening": opening,
    "closing": closing,
    "open": open,
    "id": id
  };
}