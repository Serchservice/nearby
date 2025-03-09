class GoActivityRating {
  GoActivityRating({
    required this.id,
    required this.rating,
    required this.name,
    required this.avatar,
    required this.isCurrentUser,
  });

  final int id;
  final double rating;
  final String name;
  final String avatar;
  final bool isCurrentUser;

  GoActivityRating copyWith({
    int? id,
    double? rating,
    String? name,
    String? avatar,
    bool? isCurrentUser,
  }) {
    return GoActivityRating(
      id: id ?? this.id,
      rating: rating ?? this.rating,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
    );
  }

  factory GoActivityRating.fromJson(Map<String, dynamic> json){
    return GoActivityRating(
      id: json["id"] ?? 0,
      rating: json["rating"] ?? 0.0,
      name: json["name"] ?? "",
      avatar: json["avatar"] ?? "",
      isCurrentUser: json["is_current_user"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "rating": rating,
    "name": name,
    "avatar": avatar,
    "is_current_user": isCurrentUser,
  };

  @override
  String toString(){
    return "$id, $rating, $name, $avatar, $isCurrentUser, ";
  }
}