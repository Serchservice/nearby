import 'package:drive/library.dart';

class Shop {
  Shop({
    required this.name,
    required this.category,
    required this.image,
    required this.logo,
    required this.open,
    required this.status,
    required this.rating,
    required this.id,
    required this.address,
    required this.phone,
    required this.current,
    required this.weekdays,
    required this.services,
    required this.latitude,
    required this.longitude,
    required this.link,
  });

  final String name;
  final String category;
  final String image;
  final String logo;
  final bool open;
  final String status;
  final double rating;
  final String id;
  final String address;
  final String phone;
  final ShopWeekday? current;
  final List<ShopWeekday> weekdays;
  final List<ShopService> services;
  final double latitude;
  final double longitude;
  final String link;

  Shop copyWith({
    String? name,
    String? category,
    String? image,
    String? logo,
    bool? open,
    String? status,
    double? rating,
    String? id,
    String? address,
    String? phone,
    ShopWeekday? current,
    List<ShopWeekday>? weekdays,
    List<ShopService>? services,
    double? latitude,
    double? longitude,
    String? link,
  }) {
    return Shop(
      name: name ?? this.name,
      category: category ?? this.category,
      image: image ?? this.image,
      logo: logo ?? this.logo,
      open: open ?? this.open,
      status: status ?? this.status,
      rating: rating ?? this.rating,
      id: id ?? this.id,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      current: current ?? this.current,
      weekdays: weekdays ?? this.weekdays,
      services: services ?? this.services,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      link: link ?? this.link,
    );
  }

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      name: json["name"] ?? "",
      category: json["category"] ?? "",
      image: json["image"] ?? "",
      logo: json["logo"] ?? "",
      open: json["open"] ?? false,
      status: json["status"] ?? "",
      rating: json["rating"] ?? 0.0,
      id: json["id"] ?? "",
      address: json["address"] ?? "",
      phone: json["phone"] ?? "",
      current: json["current"] == null ? null : ShopWeekday.fromJson(json["current"]),
      weekdays: json["weekdays"] == null
          ? []
          : List<ShopWeekday>.from(json["weekdays"]!.map((x) => ShopWeekday.fromJson(x))),
      services: json["services"] == null
          ? []
          : List<ShopService>.from(json["services"]!.map((x) => ShopService.fromJson(x))),
      latitude: json["latitude"] ?? 0.0,
      longitude: json["longitude"] ?? 0.0,
      link: json["link"] ?? "",
    );
  }

  factory Shop.empty() {
    return Shop.fromJson({
      "name": "string",
      "category": "string",
      "image": "string",
      "logo": "string",
      "open": true,
      "status": "OPEN",
      "rating": 0.0,
      "id": "string",
      "address": "string",
      "phone": "string",
      "current": {
        "day": "string",
        "opening": "string",
        "closing": "string",
        "open": true
      },
      "weekdays": [
        {
          "day": "string",
          "opening": "string",
          "closing": "string",
          "open": true
        }
      ],
      "services": [
        {
          "id": 0,
          "service": "string"
        }
      ],
      "latitude": 0.0,
      "longitude": 0.0,
      "link": "string",
    });
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "category": category,
    "image": image,
    "logo": logo,
    "open": open,
    "status": status,
    "rating": rating,
    "id": id,
    "address": address,
    "phone": phone,
    "current": current?.toJson(),
    "weekdays": weekdays.map((x) => x.toJson()).toList(),
    "services": services.map((x) => x.toJson()).toList(),
    "latitude": latitude,
    "longitude": longitude,
    "link": link,
  };
}