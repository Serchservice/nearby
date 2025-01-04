import 'package:drive/library.dart';

/// Class representing user preferences.
///
/// This is a class called Preference that seems to represent a user's preferences
///  for notifications, biometric authentication, theme, and scheduling.
class Preference {
  final ThemeType theme;
  final bool isNew;
  final String id;
  final bool useCurrentLocation;

  const Preference({
    this.theme = ThemeType.light,
    this.isNew = true,
    this.id = "",
    this.useCurrentLocation = false
  });

  bool get isDarkTheme => theme == ThemeType.dark;
  bool get isLightTheme => theme == ThemeType.light;

  /// Creates a copy of the Preference with optional properties updated.
  Preference copyWith({
    ThemeType? theme,
    bool? isNew,
    String? id,
    bool? useCurrentLocation
  }) {
    return Preference(
      theme: theme ?? this.theme,
      isNew: isNew ?? this.isNew,
      id: id ?? this.id,
      useCurrentLocation: useCurrentLocation ?? this.useCurrentLocation
    );
  }

  factory Preference.fromJson(Map<String, dynamic> map) {
    return Preference(
      theme: map["theme"] != null
        ? (map["theme"] as String).toThemeType()
        : ThemeType.light,
      isNew: map["is_new"] ?? true,
      id: map["id"] ?? "",
      useCurrentLocation: map["use_current_location"] ?? false
    );
  }

  Map<String, dynamic> toJson() => {
    "theme": theme.type,
    "is_new": isNew,
    "id": id,
    "use_current_location": useCurrentLocation
  };
}