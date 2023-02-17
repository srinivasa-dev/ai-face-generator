
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {

  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    if(isDarkTheme) {
      return ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFD4ECDD),
        ),
        textTheme: GoogleFonts.robotoMonoTextTheme().apply(
            bodyColor: Colors.white,
        ),
      );
    } else {
      return ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF345B63),
        ),
        primaryTextTheme: GoogleFonts.robotoMonoTextTheme(),
        textTheme: GoogleFonts.robotoMonoTextTheme(),
      );
    }
  }
}