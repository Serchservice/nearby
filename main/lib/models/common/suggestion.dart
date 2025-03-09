import '../../backend/core/category.dart';

class Suggestion {
  final String title;
  final bool canPublish;
  final List<CategorySection> sections;

  Suggestion({required this.title, required this.sections, this.canPublish = true});

  factory Suggestion.fromJson(Map<String, dynamic> json) {
    return Suggestion(
      title: json["season"] ?? "",
      canPublish: json["can_publish"] ?? true,
      sections: (json["sections"] as List<dynamic>).map((i) {
        return CategorySection.fromJsonWithColorStrings(i);
      }).toList(),
    );
  }
}