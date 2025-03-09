import 'package:drive/library.dart' show GoInterest, GoFile;
import 'package:smart/smart.dart';

class GoBCap {
  final String id;
  final String activity;
  final String name;
  final String description;
  final double rating;
  final GoInterest? interest;
  final List<GoFile> files;
  final bool canActOnActivity;
  final double? ratingFromCurrentUser;
  final bool canRate;
  final bool canComment;
  final bool hasRatings;
  final bool hasComments;
  final bool isCreatedByCurrentUser;
  final String totalComments;
  final String totalRatings;
  final String link;

  GoBCap({
    required this.id,
    required this.activity,
    required this.name,
    required this.description,
    required this.rating,
    required this.interest,
    required this.files,
    required this.canActOnActivity,
    required this.ratingFromCurrentUser,
    this.canRate = true,
    this.canComment = true,
    this.hasRatings = false,
    this.hasComments = false,
    this.totalComments = "0",
    this.totalRatings = "0",
    this.isCreatedByCurrentUser = false,
    this.link = "",
  });

  GoBCap copyWith({
    String? id,
    String? activity,
    String? name,
    String? description,
    double? rating,
    GoInterest? interest,
    List<GoFile>? files,
    bool? canActOnActivity,
    double? ratingFromCurrentUser,
    bool? canRate,
    bool? canComment,
    bool? hasRatings,
    bool? hasComments,
    String? totalComments,
    String? totalRatings,
    bool? isCreatedByCurrentUser,
    String? link,
  }) {
    return GoBCap(
      id: id ?? this.id,
      activity: activity ?? this.activity,
      name: name ?? this.name,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      interest: interest ?? this.interest,
      files: files ?? this.files,
      canActOnActivity: canActOnActivity ?? this.canActOnActivity,
      ratingFromCurrentUser: ratingFromCurrentUser ?? this.ratingFromCurrentUser,
      canRate: canRate ?? this.canRate,
      canComment: canComment ?? this.canComment,
      hasRatings: hasRatings ?? this.hasRatings,
      hasComments: hasComments ?? this.hasComments,
      totalComments: totalComments ?? this.totalComments,
      totalRatings: totalRatings ?? this.totalRatings,
      isCreatedByCurrentUser: isCreatedByCurrentUser ?? this.isCreatedByCurrentUser,
      link: link ?? this.link,
    );
  }

  factory GoBCap.fromJson(Map<String, dynamic> json){
    return GoBCap(
      id: json["id"] ?? "",
      activity: json["activity"] ?? "",
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      rating: json["rating"] ?? 0.0,
      interest: json["interest"] == null ? null : GoInterest.fromJson(json["interest"]),
      files: json["files"] == null
          ? []
          : List<GoFile>.from(json["files"]!.map((x) => GoFile.fromJson(x))),
      canActOnActivity: json["can_act_on_activity"] ?? false,
      ratingFromCurrentUser: json["rating_from_current_user"],
      canRate: json["can_rate"] ?? true,
      canComment: json["can_comment"] ?? true,
      hasRatings: json["has_ratings"] ?? false,
      hasComments: json["has_comments"] ?? false,
      totalComments: json["total_comments"] ?? "0",
      totalRatings: json["total_ratings"] ?? "0",
      isCreatedByCurrentUser: json["is_created_by_current_user"] ?? false,
      link: json["link"] ?? "",
    );
  }

  factory GoBCap.empty() => GoBCap.fromJson({});

  Map<String, dynamic> toJson() => {
    "id": id,
    "activity": activity,
    "name": name,
    "description": description,
    "rating": rating,
    "interest": interest?.toJson(),
    "files": files.map((x) => x.toJson()).toList(),
    "can_act_on_activity": canActOnActivity,
    "rating_from_current_user": ratingFromCurrentUser,
    "can_rate": canRate,
    "can_comment": canComment,
    "has_ratings": hasRatings,
    "has_comments": hasComments,
    "total_comments": totalComments,
    "total_ratings": totalRatings,
    "is_created_by_current_user": isCreatedByCurrentUser,
    "link": link,
  };

  bool get hasActivity => activity.isNotEmpty;

  bool get hasBCap => id.isNotEmpty;

  bool get hasRating => rating.isGt(0.0);

  @override
  String toString(){
    return "$id, $activity, $name, $description, $rating, $interest, $files, "
        "$canActOnActivity, $ratingFromCurrentUser, "
        "$canRate, $canComment, $hasRatings, $hasComments, "
        "$totalComments, $totalRatings, $isCreatedByCurrentUser, $link";
  }
}