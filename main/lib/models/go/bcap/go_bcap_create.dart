import 'package:drive/library.dart' show SelectedMedia;

class GoBCapCreate {
  GoBCapCreate({
    required this.id,
    required this.description,
    required this.media,
  });

  final String id;
  final String description;
  final List<SelectedMedia> media;

  GoBCapCreate copyWith({
    String? id,
    String? description,
    List<SelectedMedia>? media,
  }) {
    return GoBCapCreate(
      id: id ?? this.id,
      description: description ?? this.description,
      media: media ?? this.media,
    );
  }

  factory GoBCapCreate.fromJson(Map<String, dynamic> json){
    return GoBCapCreate(
      id: json["id"] ?? "",
      description: json["description"] ?? "",
      media: json["media"] == null
          ? []
          : List<SelectedMedia>.from(json["media"]!.map((x) => SelectedMedia.fromJson(x))),
    );
  }

  bool get hasData => id.isNotEmpty && media.isNotEmpty;

  Map<String, dynamic> toJson() => {
    "id": id,
    "description": description,
    "media": media.map((x) => x.toJson()).toList(),
  };

  @override
  String toString(){
    return "$id, $description, $media, ";
  }
}