import 'package:smart/smart.dart';

/// Class representing a user address.
class Address {
  final String id;
  final String place;
  final String country;
  final String state;
  final String city;
  final double latitude;
  final double longitude;
  final String localGovernmentArea;
  final String streetNumber;
  final String streetName;

  /// Creates a new instance of Address with the given properties.
  Address({
    this.id = "",
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.localGovernmentArea = "",
    this.streetName = "",
    this.streetNumber = "",
    this.country = "",
    this.place = "",
    this.state = "",
    this.city = "",
  });

  /// Creates a copy of the Address with optional properties updated.
  Address copyWith({
    String? id,
    String? place,
    double? latitude,
    double? longitude,
    String? country,
    String? state,
    String? city,
    String? localGovernmentArea,
    String? streetNumber,
    String? streetName,
  }) {
    return Address(
      id: id ?? this.id,
      place: place ?? this.place,
      localGovernmentArea: localGovernmentArea ?? this.localGovernmentArea,
      streetName: streetName ?? this.streetName,
      streetNumber: streetNumber ?? this.streetNumber,
      latitude: latitude ?? this.latitude,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      longitude: longitude ?? this.longitude,
    );
  }

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json["id"] ?? "",
    latitude: json["latitude"] ?? 0.0,
    longitude: json["longitude"] ?? 0.0,
    localGovernmentArea: json["local_government_area"] ?? "",
    streetName: json['street_name'] ?? "",
    streetNumber: json['street_number'] ?? "",
    country: json["country"] ?? "",
    state: json["state"] ?? "",
    city: json["city"] ?? "",
    place: json["place"] ?? ""
  );

  factory Address.empty() {
    return Address.fromJson({});
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "latitude": latitude,
    "longitude": longitude,
    "country": country,
    "state": state,
    "city": city,
    "local_government_area": localGovernmentArea,
    'street_name': streetName,
    'street_number': streetNumber,
    "place": place,
  };

  factory Address.fromStringedJson(Map<String, String> json) {
    return Address(
      id: json["id"] ?? "",
      latitude: double.tryParse(json["latitude"] ?? "0.0") ?? 0.0,
      longitude: double.tryParse(json["longitude"] ?? "0.0") ?? 0.0,
      localGovernmentArea: json["local_government_area"] ?? "",
      streetName: json['street_name'] ?? "",
      streetNumber: json['street_number'] ?? "",
      country: json["country"] ?? "",
      state: json["state"] ?? "",
      city: json["city"] ?? "",
      place: json["place"] ?? ""
    );
  }

  Map<String, String> toStringedJson() => {
    "id": id,
    "latitude": latitude.toString(),
    "longitude": longitude.toString(),
    "country": country,
    "state": state,
    "city": city,
    "local_government_area": localGovernmentArea,
    'street_name': streetName,
    'street_number': streetNumber,
    "place": place,
  };

  bool matches(String country, String state) {
    return country.equalsIgnoreCase(this.country) && state.equalsIgnoreCase(this.state);
  }

  bool get hasAddress => !latitude.equals(0.0) || !longitude.equals(0.0) || place.isNotEmpty;
}