import 'package:drive/library.dart';

class SearchShopResponse {
  SearchShopResponse({
    required this.user,
    required this.distance,
    required this.shop,
    required this.distanceInKm,
    required this.isGoogle
  });

  final String user;
  final double distance;
  final Shop shop;
  final String distanceInKm;
  final bool isGoogle;

  SearchShopResponse copyWith({
    String? user,
    double? distance,
    Shop? shop,
    String? distanceInKm,
    bool? isGoogle
  }) {
    return SearchShopResponse(
      user: user ?? this.user,
      distance: distance ?? this.distance,
      shop: shop ?? this.shop,
      distanceInKm: distanceInKm ?? this.distanceInKm,
      isGoogle: isGoogle ?? this.isGoogle,
    );
  }

  factory SearchShopResponse.fromJson(Map<String, dynamic> json) {
    return SearchShopResponse(
      user: json["user"] ?? "",
      distance: json["distance"] ?? 0.0,
      shop: Shop.fromJson(json["shop"]),
      distanceInKm: json["distance_in_km"] ?? "",
      isGoogle: json["is_google"] ?? false
    );
  }

  factory SearchShopResponse.empty() {
    return SearchShopResponse(
      user: "",
      distance: 0.0,
      shop: Shop.empty(),
      distanceInKm: "",
      isGoogle: false
    );
  }

  Map<String, dynamic> toJson() => {
    "user": user,
    "distance": distance,
    "shop": shop.toJson(),
    "distance_in_km": distanceInKm,
    "is_google": isGoogle
  };
}