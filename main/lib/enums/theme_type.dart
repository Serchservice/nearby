/// This enum represents the different types of themes available in the system.
///
///The ThemeType enum represents the two possible themes for an application: light and dark. It has two fields:
///
/// light: represents the light theme.
///
/// dark: represents the dark theme.
///
/// Each field has a string value associated with it that describes the type of the theme.
/// The type field is a constant string that cannot be changed and is set during initialization using the constructor.
enum ThemeType{
  /// Represents the light theme.
  light("Light"),

  /// Represents the dark theme.
  dark("Dark");

  /// The type of the theme as a string.
  final String type;

  /// Constructor for the ThemeType enum.
  const ThemeType(this.type);
}


/// ConvertThemeType: This is an extension class on the String class.
///
/// on String: This specifies that the extension applies to the String class.
///
/// toThemeEnum(): This function converts a string to a ThemeType enum.
///
/// switch (this): This is a switch statement on the String object that the function is being called on.
///
/// case "Light": return ThemeType.light;: This maps the string value "Light" to the ThemeType.light enum.
///
/// case "Dark": return ThemeType.dark;: This maps the string value "Dark" to the ThemeType.dark enum.
///
/// default: return ThemeType.light;: This is the default case that maps any other string value to the ThemeType.light enum.
/// Extension on the `String` class to convert a string to a `ThemeType` enum.
extension StringToThemeType on String {
  /// Convert a string to a `ThemeType` enum.
  ThemeType toThemeType() {
    switch (this) {
      case "Light":
        return ThemeType.light;
      case "Dark":
        return ThemeType.dark;
      default:
        return ThemeType.light;
    }
  }
}