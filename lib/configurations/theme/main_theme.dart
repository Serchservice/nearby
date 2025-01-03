import 'package:flutter/material.dart';
import 'package:drive/library.dart';
import 'package:google_fonts/google_fonts.dart';

class MainTheme {
  static final visualDensity = VisualDensity.adaptivePlatformDensity;
  static final textTheme = GoogleFonts.nunitoTextTheme();
  static final logoTheme = GoogleFonts.leagueSpartanTextTheme();
  static final mainFont = GoogleFonts.nunito();

  static ThemeData get light => LightTheme(
    logoTheme: logoTheme,
    textTheme: textTheme,
    visualDensity: visualDensity,
    mainFont: mainFont
  ).theme;

  static ThemeData get dark => DarkTheme(
    logoTheme: logoTheme,
    textTheme: textTheme,
    visualDensity: visualDensity,
    mainFont: mainFont
  ).theme;
}