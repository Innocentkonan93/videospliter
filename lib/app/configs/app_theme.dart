import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

ThemeData appTheme = ThemeData(
  visualDensity: VisualDensity.adaptivePlatformDensity,
  colorScheme: ColorScheme.fromSeed(
    // brightness: Brightness.dark,
    seedColor: AppColors.primary,
    error: const Color.fromARGB(255, 191, 78, 69),
  ),
  scaffoldBackgroundColor: AppColors.background,
  dataTableTheme: const DataTableThemeData(
    decoration: BoxDecoration(color: AppColors.white),
  ),
  cardTheme: const CardThemeData(
    color: Color.fromARGB(255, 48, 41, 41), // reset margin
  ),
  appBarTheme: AppBarTheme(
    centerTitle: true,
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
    ),
    surfaceTintColor: AppColors.white,
    backgroundColor: AppColors.white,
    titleTextStyle: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w400,
      color: AppColors.black,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.background,
    contentPadding: const EdgeInsets.all(12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: AppColors.grey.withValues(alpha: .45),
        width: 0.5,
      ),
    ),
    isDense: true,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: AppColors.grey.withValues(alpha: .45),
        width: 0.5,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: Colors.red.withValues(alpha: .2),
        width: 0.5,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.primary, width: .8),
    ),
  ),
  radioTheme: const RadioThemeData(),
  textTheme: GoogleFonts.jostTextTheme().copyWith(
    labelSmall: GoogleFonts.jost(color: AppColors.grey),
    labelMedium: GoogleFonts.jost(color: AppColors.grey),
    labelLarge: GoogleFonts.jost(color: AppColors.grey),
  ),
  fontFamily: "Poppins",
  useMaterial3: true,
);
