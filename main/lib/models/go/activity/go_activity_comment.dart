class GoActivityComment {
  final int id;
  final String comment;
  final String name;
  final String avatar;
  final bool isCurrentUser;

  GoActivityComment({
    required this.id,
    required this.comment,
    required this.name,
    required this.avatar,
    required this.isCurrentUser,
  });

  GoActivityComment copyWith({
    int? id,
    String? comment,
    String? name,
    String? avatar,
    bool? isCurrentUser,
  }) {
    return GoActivityComment(
      id: id ?? this.id,
      comment: comment ?? this.comment,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
    );
  }

  factory GoActivityComment.fromJson(Map<String, dynamic> json){
    return GoActivityComment(
      id: json["id"] ?? -1,
      comment: json["comment"] ?? "",
      name: json["name"] ?? "",
      avatar: json["avatar"] ?? "",
      isCurrentUser: json["is_current_user"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "comment": comment,
    "name": name,
    "avatar": avatar,
    "is_current_user": isCurrentUser,
  };

  @override
  String toString(){
    return "$id, $comment, $name, $avatar, $isCurrentUser, ";
  }
}