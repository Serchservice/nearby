class DriveCategoryResponse {
  final String name;
  final String type;
  final String image;

  DriveCategoryResponse({
    required this.name,
    required this.type,
    required this.image,
  });

  // Factory constructor for creating an instance from JSON
  factory DriveCategoryResponse.fromJson(Map<String, dynamic> json) {
    return DriveCategoryResponse(
      name: json['name'] as String,
      type: json['type'] as String,
      image: json['image'] as String,
    );
  }

  // Method to convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'image': image,
    };
  }

  // Method to create a copy of the current instance with optional new values
  DriveCategoryResponse copyWith({
    String? name,
    String? type,
    String? image,
  }) {
    return DriveCategoryResponse(
      name: name ?? this.name,
      type: type ?? this.type,
      image: image ?? this.image,
    );
  }
}