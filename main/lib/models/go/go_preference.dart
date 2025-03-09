/// Class representing user preferences.
///
/// This is a class called GoPreference that seems to represent a user's preferences
///  for go actions.
class GoPreference {
  final bool loopBCapVideos;

  GoPreference({
    this.loopBCapVideos = false,
  });

  /// Creates a copy of the GoPreference with optional properties updated.
  GoPreference copyWith({
    bool? loopBCapVideos,
  }) {
    return GoPreference(
      loopBCapVideos: loopBCapVideos ?? this.loopBCapVideos,
    );
  }

  factory GoPreference.fromJson(Map<String, dynamic> map) {
    return GoPreference(
      loopBCapVideos: map["loop_bcap_videos"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "loop_bcap_videos": loopBCapVideos,
  };
}