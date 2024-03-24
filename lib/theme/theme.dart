/// Written by Thiti Phuttaamart 640510660
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData buildTheme() {
  var baseTheme = ThemeData();

  return baseTheme.copyWith(
    textTheme: GoogleFonts.fredokaTextTheme(baseTheme.textTheme),
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    useMaterial3: true,
  );
}