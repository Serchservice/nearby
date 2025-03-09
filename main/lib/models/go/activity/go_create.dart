import 'package:drive/library.dart' show Address, SelectedMedia;
import 'package:smart/smart.dart' show DynamicExtensions;
import 'package:intl/intl.dart' show DateFormat;

class GoCreate {
  GoCreate({
    required this.message,
    required this.date,
    required this.interest,
    required this.location,
    required this.images,
    required this.startTime,
    required this.endTime,
    required this.emoji,
    required this.name
  });

  final String message;
  final DateTime? date;
  final int interest;
  final String emoji;
  final String name;
  final Address? location;
  final List<SelectedMedia> images;
  final GoCreateTime? startTime;
  final GoCreateTime? endTime;

  GoCreate copyWith({
    String? message,
    DateTime? date,
    int? interest,
    Address? location,
    List<SelectedMedia>? images,
    GoCreateTime? startTime,
    GoCreateTime? endTime,
    String? emoji,
    String? name,
  }) {
    return GoCreate(
      message: message ?? this.message,
      date: date ?? this.date,
      interest: interest ?? this.interest,
      location: location ?? this.location,
      images: images ?? this.images,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      emoji: emoji ?? this.emoji,
      name: name ?? this.name,
    );
  }

  factory GoCreate.fromJson(Map<String, dynamic> json){
    return GoCreate(
      message: json["message"] ?? "",
      date: DateTime.tryParse(json["date"] ?? ""),
      interest: json["interest"] ?? -1,
      location: json["location"] == null ? null : Address.fromJson(json["location"]),
      images: json["images"] == null ? [] : List<SelectedMedia>.from(json["images"]!.map((x) => SelectedMedia.fromJson(x))),
      startTime: json["start_time"] == null ? null : GoCreateTime.fromJson(json["start_time"]),
      endTime: json["end_time"] == null ? null : GoCreateTime.fromJson(json["end_time"]),
      emoji: json["emoji"] ?? "",
      name: json["name"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "message": message,
    "date": date != null ? DateFormat('yyyy-MM-dd').format(date!) : null,
    "interest": interest,
    "location": location?.toJson(),
    "images": images.map((x) => x.toJson()).toList(),
    "start_time": startTime?.toJson(),
    "end_time": endTime?.toJson(),
    "emoji": emoji,
    "name": name,
  };

  bool get hasData => message.isNotEmpty && interest != -1 && location.isNotNull && startTime.isNotNull && endTime.isNotNull;

  @override
  String toString(){
    return "$message, $date, $interest, $location, $images, $startTime, $endTime, ";
  }
}

class GoCreateTime {
  GoCreateTime({
    required this.hour,
    required this.minute,
  });

  final int hour;
  final int minute;

  GoCreateTime copyWith({
    int? hour,
    int? minute,
  }) {
    return GoCreateTime(
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
    );
  }

  factory GoCreateTime.fromJson(Map<String, dynamic> json){
    return GoCreateTime(
      hour: json["hour"] ?? 0,
      minute: json["minute"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "hour": hour,
    "minute": minute,
  };

  @override
  String toString(){
    return "$hour:$minute";
  }
}