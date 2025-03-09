class GoInterest {
  GoInterest({
    required this.id,
    required this.name,
    required this.verb,
    required this.emoji,
    required this.popularity,
    required this.title,
    required this.category,
    required this.nearbyPopularity,
    required this.categoryId,
  });

  final int id;
  final String name;
  final String verb;
  final String emoji;
  final int popularity;
  final String title;
  final String category;
  final int nearbyPopularity;
  final int categoryId;

  GoInterest copyWith({
    int? id,
    String? name,
    String? verb,
    String? emoji,
    int? popularity,
    String? title,
    String? category,
    int? nearbyPopularity,
    int? categoryId,
  }) {
    return GoInterest(
      id: id ?? this.id,
      name: name ?? this.name,
      verb: verb ?? this.verb,
      emoji: emoji ?? this.emoji,
      popularity: popularity ?? this.popularity,
      title: title ?? this.title,
      category: category ?? this.category,
      nearbyPopularity: nearbyPopularity ?? this.nearbyPopularity,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  factory GoInterest.fromJson(Map<String, dynamic> json){
    return GoInterest(
      id: json["id"] ?? -1,
      name: json["name"] ?? "",
      verb: json["verb"] ?? "",
      emoji: json["emoji"] ?? "",
      popularity: json["popularity"] ?? 0,
      title: json["title"] ?? "",
      category: json["category"] ?? "",
      nearbyPopularity: json["nearby_popularity"] ?? 0,
      categoryId: json["category_id"] ?? -1,
    );
  }

  factory GoInterest.empty() {
    return GoInterest.fromJson({});
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "verb": verb,
    "emoji": emoji,
    "popularity": popularity,
    "title": title,
    "category": category,
    "nearby_popularity": nearbyPopularity,
    "category_id": categoryId,
  };

  bool get hasInterest => id != -1;

  @override
  String toString(){
    return "$id, $name, $verb, $emoji, $popularity, $title, $category, $nearbyPopularity, $categoryId, ";
  }
}