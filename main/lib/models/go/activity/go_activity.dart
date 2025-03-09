import 'dart:ui' show Color;

import 'package:drive/library.dart' show Address, GoUser, GoPoll, GoInterest, GoFile, CommonColors;
import 'package:smart/smart.dart' show StringExtensions, DoubleExtensions;

class GoActivity {
  final String id;
  final String bcap;
  final String name;
  final String description;
  final String startTime;
  final String endTime;
  final String status;
  final String timestamp;
  final double rating;
  final Address? location;
  final GoUser? user;
  final GoPoll? poll;
  final GoInterest? interest;
  final List<GoFile> images;
  final bool hasResponded;
  final bool hasSimilarActivitiesFromCreator;
  final bool hasSimilarActivitiesFromOtherCreators;
  final bool isCreatedByCurrentUser;
  final bool canRate;
  final bool canComment;
  final bool hasRatings;
  final bool hasComments;
  final List<GoUser> attendingUsers;
  final String totalComments;
  final String totalRatings;
  final String link;

  GoActivity({
    required this.id,
    required this.bcap,
    required this.name,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.timestamp,
    required this.rating,
    required this.location,
    required this.user,
    required this.poll,
    required this.interest,
    required this.images,
    required this.hasResponded,
    required this.hasSimilarActivitiesFromCreator,
    required this.isCreatedByCurrentUser,
    required this.attendingUsers,
    required this.hasSimilarActivitiesFromOtherCreators,
    this.canRate = true,
    this.canComment = true,
    this.hasRatings = false,
    this.hasComments = false,
    this.link = "",
    this.totalComments = "0",
    this.totalRatings = "0",
  });

  GoActivity copyWith({
    String? id,
    String? bcap,
    String? name,
    String? description,
    String? startTime,
    String? endTime,
    String? status,
    String? timestamp,
    double? rating,
    Address? location,
    GoUser? user,
    GoPoll? poll,
    GoInterest? interest,
    List<GoFile>? images,
    bool? hasResponded,
    bool? hasSimilarActivitiesFromCreator,
    bool? hasSimilarActivitiesFromOtherCreators,
    bool? isCreatedByCurrentUser,
    List<GoUser>? attendingUsers,
    bool? canRate,
    bool? canComment,
    bool? hasRatings,
    bool? hasComments,
    String? link,
    String? totalComments,
    String? totalRatings,
  }) {
    return GoActivity(
      id: id ?? this.id,
      bcap: bcap ?? this.bcap,
      name: name ?? this.name,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      rating: rating ?? this.rating,
      location: location ?? this.location,
      user: user ?? this.user,
      poll: poll ?? this.poll,
      interest: interest ?? this.interest,
      images: images ?? this.images,
      hasResponded: hasResponded ?? this.hasResponded,
      hasSimilarActivitiesFromCreator: hasSimilarActivitiesFromCreator ?? this.hasSimilarActivitiesFromCreator,
      isCreatedByCurrentUser: isCreatedByCurrentUser ?? this.isCreatedByCurrentUser,
      attendingUsers: attendingUsers ?? this.attendingUsers,
      hasSimilarActivitiesFromOtherCreators: hasSimilarActivitiesFromOtherCreators ?? this.hasSimilarActivitiesFromOtherCreators,
      canRate: canRate ?? this.canRate,
      canComment: canComment ?? this.canComment,
      hasRatings: hasRatings ?? this.hasRatings,
      hasComments: hasComments ?? this.hasComments,
      link: link ?? this.link,
      totalComments: totalComments ?? this.totalComments,
      totalRatings: totalRatings ?? this.totalRatings,
    );
  }

  factory GoActivity.fromJson(Map<String, dynamic> json){
    return GoActivity(
      id: json["id"] ?? "",
      bcap: json["bcap"] ?? "",
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      startTime: json["startTime"] ?? "",
      endTime: json["endTime"] ?? "",
      status: json["status"] ?? "",
      timestamp: json["timestamp"] ?? "",
      rating: json["rating"] ?? 0.0,
      location: json["location"] == null ? null : Address.fromJson(json["location"]),
      user: json["user"] == null ? null : GoUser.fromJson(json["user"]),
      poll: json["poll"] == null ? null : GoPoll.fromJson(json["poll"]),
      interest: json["interest"] == null ? null : GoInterest.fromJson(json["interest"]),
      images: json["images"] == null
          ? []
          : List<GoFile>.from(json["images"]!.map((x) => GoFile.fromJson(x))),
      hasResponded: json["has_responded"] ?? false,
      hasSimilarActivitiesFromCreator: json["has_similar_activities_from_creator"] ?? false,
      hasSimilarActivitiesFromOtherCreators: json["has_similar_activities_from_other_creators"] ?? false,
      isCreatedByCurrentUser: json["is_created_by_current_user"] ?? false,
      attendingUsers: json["attending_users"] == null
          ? []
          : List<GoUser>.from(json["attending_users"]!.map((x) => GoUser.fromJson(x))),
      canRate: json["can_rate"] ?? true,
      canComment: json["can_comment"] ?? true,
      hasRatings: json["has_ratings"] ?? false,
      hasComments: json["has_comments"] ?? false,
      link: json["link"] ?? "",
      totalComments: json["total_comments"] ?? "0",
      totalRatings: json["total_ratings"] ?? "0",
    );
  }

  factory GoActivity.empty() => GoActivity.fromJson({});

  bool get hasActivity => id != "";

  bool get hasBCap => bcap != "";

  bool get isClosed => status.equalsIgnoreCase("closed");

  bool get isOngoing => status.equalsIgnoreCase("active");

  Color get colored => isClosed ? CommonColors.instance.payu : isOngoing ? CommonColors.instance.green : CommonColors.instance.bluish;

  bool get isPending => status.equalsIgnoreCase("waiting");

  bool get hasRating => rating.notEquals(0.0);

  Map<String, dynamic> toJson() => {
    "id": id,
    "bcap": bcap,
    "name": name,
    "description": description,
    "startTime": startTime,
    "endTime": endTime,
    "status": status,
    "timestamp": timestamp,
    "rating": rating,
    "location": location?.toJson(),
    "user": user?.toJson(),
    "poll": poll?.toJson(),
    "interest": interest?.toJson(),
    "images": images.map((x) => x.toJson()).toList(),
    "has_responded": hasResponded,
    "has_similar_activities_from_creator": hasSimilarActivitiesFromCreator,
    "has_similar_activities_from_other_creators": hasSimilarActivitiesFromOtherCreators,
    "is_created_by_current_user": isCreatedByCurrentUser,
    "attending_users": attendingUsers.map((x) => x.toJson()).toList(),
    "can_rate": canRate,
    "can_comment": canComment,
    "has_ratings": hasRatings,
    "has_comments": hasComments,
    "link": link,
    "total_comments": totalComments,
    "total_ratings": totalRatings,
  };

  @override
  String toString(){
    return "$id, $bcap, $name, $description, $startTime, $endTime, $status, "
        "$timestamp, $rating, $location, $user, $poll, $interest, $images, "
        "$hasResponded, $isCreatedByCurrentUser, $attendingUsers, "
        "$hasSimilarActivitiesFromCreator, $hasSimilarActivitiesFromOtherCreators, "
        "$canRate, $canComment, $hasRatings, $hasComments, $link, $totalComments, $totalRatings";
  }
}