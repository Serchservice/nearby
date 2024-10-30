import 'package:drive/library.dart';

/// Class representing user preferences.
///
/// This is a class called Preference that seems to represent a user's preferences
///  for notifications, biometric authentication, theme, and scheduling.
class Preference {
  final ThemeType theme;
  final bool isNew;

  const Preference({
    this.theme = ThemeType.light,
    this.isNew = true,
  });

  bool get isDarkTheme => theme == ThemeType.dark;
  bool get isLightTheme => theme == ThemeType.light;

  /// Creates a copy of the Preference with optional properties updated.
  Preference copyWith({
    ThemeType? theme,
    bool? isNew,
  }) {
    return Preference(
      theme: theme ?? this.theme,
      isNew: isNew ?? this.isNew,
    );
  }

  factory Preference.fromJson(Map<String, dynamic> map) {
    return Preference(
      theme: map["theme"] != null
        ? (map["theme"] as String).toThemeType()
        : ThemeType.light,
      isNew: map["is_new"] ?? true
    );
  }

  Map<String, dynamic> toJson() => {
    "theme": theme.type,
    "is_new": isNew
  };
}