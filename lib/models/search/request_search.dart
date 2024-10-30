import '../device/address.dart';

class RequestSearch {
  final String category;
  final Address pickup;

  RequestSearch({
    required this.category,
    required this.pickup,
  });

  // Converts a JSON map into a RequestSearch instance
  factory RequestSearch.fromJson(Map<String, dynamic> json) {
    return RequestSearch(
      category: json['category'] as String,
      pickup: Address.fromJson(json['pickup'] as Map<String, dynamic>),
    );
  }

  // Converts a RequestSearch instance into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'pickup': pickup.toJson(),
    };
  }

  Map<String, String> toParams() {
    return {
      "category": category,
      "pickup_coordinates": "lat_lng=[${pickup.latitude}, ${pickup.longitude}]",
      "pickup_address": pickup.place
    };
  }

  // Creates a copy of this model with specified fields modified
  RequestSearch copyWith({
    String? category,
    Address? pickup,
  }) {
    return RequestSearch(
      category: category ?? this.category,
      pickup: pickup ?? this.pickup,
    );
  }
}