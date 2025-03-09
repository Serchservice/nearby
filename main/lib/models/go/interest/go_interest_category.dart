import 'go_interest.dart';

class GoInterestCategory {
  GoInterestCategory({
    required this.id,
    required this.name,
    required this.interests,
  });

  final int id;
  final String name;
  final List<GoInterest> interests;

  GoInterestCategory copyWith({
    int? id,
    String? name,
    List<GoInterest>? interests,
  }) {
    return GoInterestCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      interests: interests ?? this.interests,
    );
  }

  factory GoInterestCategory.fromJson(Map<String, dynamic> json){
    return GoInterestCategory(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      interests: json["interests"] == null
          ? []
          : List<GoInterest>.from(json["interests"]!.map((x) => GoInterest.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "interests": interests.map((x) => x.toJson()).toList(),
  };

  @override
  String toString(){
    return "$id, $name, $interests, ";
  }
}