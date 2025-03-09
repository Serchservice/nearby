import 'package:flutter/material.dart';
import 'package:drive/library.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart/enums.dart';
import 'package:smart/styles.dart';

class MainTheme extends ThemeFactory {
  MainTheme._();
  static MainTheme instance = MainTheme._();

  Color get darkBackgroundColor => DarkTheme(settings).backgroundColor;

  @override
  ThemeData get light => LightTheme(settings).theme;

  @override
  ThemeData get dark => DarkTheme(settings).theme;

  @override
  TextTheme get logo => PlatformEngine.instance.isWebWasm
      ? textThemeBuilder(font: FontFamily.leagueSpartan)
      : GoogleFonts.leagueSpartanTextTheme();

  @override
  ThemeSettings get settings => ThemeSettings(density: VisualDensity.adaptivePlatformDensity, text: text, logo: logo, style: style);

  @override
  TextTheme get text => PlatformEngine.instance.isWebWasm
      ? textThemeBuilder(font: FontFamily.nunito)
      : GoogleFonts.nunitoTextTheme();

  @override
  TextStyle get style => PlatformEngine.instance.isWebWasm
      ? textStyleBuilder(font: FontFamily.nunito)
      : GoogleFonts.nunito();
}