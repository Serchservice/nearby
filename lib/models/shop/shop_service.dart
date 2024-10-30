class ShopService {
  ShopService({
    required this.id,
    required this.service,
  });

  final int id;
  final String service;

  ShopService copyWith({
    int? id,
    String? service,
  }) {
    return ShopService(
      id: id ?? this.id,
      service: service ?? this.service,
    );
  }

  factory ShopService.fromJson(Map<String, dynamic> json) {
    return ShopService(
      id: json["id"] ?? 0,
      service: json["service"] ?? "",
    );
  }

  factory ShopService.empty() {
    return ShopService.fromJson({
      "id": 0,
      "service": ""
    });
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "service": service,
  };
}