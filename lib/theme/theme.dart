import 'package:flutter/material.dart';

class ThemeColor {

  static const Color lightBackground = Color(0xFFF2F2F7); 
  static const Color lightSurface = Color(0xFFFFFFFF); 
  static const Color lightCardBackground = Color(0xFFFFFFFF);
  static const Color lightSecondaryBackground = Color(0xFFF2F2F7);

  static const Color darkBackground = Color(0xFF000000); 
  static const Color darkSurface = Color(0xFF1C1C1E); 
  static const Color darkCardBackground = Color(0xFF2C2C2E);
  static const Color darkSecondaryBackground = Color(0xFF1C1C1E);

  static const Color systemBlue = Color(0xFF007AFF);
  static const Color systemBlueDark = Color(0xFF0A84FF);
  
  static const Color systemGreen = Color(0xFF34C759);
  static const Color systemGreenDark = Color(0xFF30D158);

  static const Color systemRed = Color(0xFFFF3B30);
  static const Color systemRedDark = Color(0xFFFF453A);

  static const Color systemOrange = Color(0xFFFF9500);
  static const Color systemOrangeDark = Color(0xFFFF9F0A);

  static const Color systemYellow = Color(0xFFFFCC00);
  static const Color systemYellowDark = Color(0xFFFFD60A);
  
  static const Color systemGray = Color(0xFF8E8E93);
  static const Color systemGray2 = Color(0xFFAEAEB2);
  static const Color systemGray3 = Color(0xFFC7C7CC);
  static const Color systemGray4 = Color(0xFFD1D1D6);
  static const Color systemGray5 = Color(0xFFE5E5EA);
  static const Color systemGray6 = Color(0xFFF2F2F7);

  static const Color lightPrimaryText = Color(0xFF000000);
  static const Color lightSecondaryText = Color(0xFF3C3C43);
  static const Color lightTertiaryText = Color(0xFF8E8E93);
  
  static const Color darkPrimaryText = Color(0xFFFFFFFF);
  static const Color darkSecondaryText = Color(0xFFEBEBF5);
  static const Color darkTertiaryText = Color(0xFF8E8E93);
}

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  fontFamily: 'SF Pro Display',

  appBarTheme: AppBarTheme(
    backgroundColor: ThemeColor.darkBackground,
    foregroundColor: ThemeColor.darkPrimaryText,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w600,
      color: ThemeColor.darkPrimaryText,
    ),
  ),

  cardTheme: CardTheme(
    color: ThemeColor.darkCardBackground,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  
  iconTheme: IconThemeData(
    color: ThemeColor.systemBlueDark,
    size: 24,
  ),
  
  textTheme: TextTheme(
    headlineLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: ThemeColor.darkPrimaryText,
    ),
    headlineMedium: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: ThemeColor.darkPrimaryText,
    ),
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: ThemeColor.darkPrimaryText,
    ),
    bodyLarge: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w400,
      color: ThemeColor.darkPrimaryText,
    ),
    bodyMedium: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: ThemeColor.darkSecondaryText,
    ),
    bodySmall: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: ThemeColor.darkTertiaryText,
    ),
  ),
  
  colorScheme: ColorScheme.dark(
    brightness: Brightness.dark,
    primary: ThemeColor.systemBlueDark,
    onPrimary: Colors.white,
    secondary: ThemeColor.systemGreenDark,
    onSecondary: Colors.white,
    tertiary: ThemeColor.systemOrangeDark,
    onTertiary: Colors.white,
    error: ThemeColor.systemRedDark,
    onError: Colors.white,
    surface: ThemeColor.darkSurface,
    onSurface: ThemeColor.darkPrimaryText,
    background: ThemeColor.darkBackground,
    onBackground: ThemeColor.darkPrimaryText,
    primaryContainer: ThemeColor.darkCardBackground,
    onPrimaryContainer: ThemeColor.darkPrimaryText,
    secondaryContainer: ThemeColor.darkSecondaryBackground,
    onSecondaryContainer: ThemeColor.darkSecondaryText,
    outline: ThemeColor.systemGray,
  ),
);

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  fontFamily: 'SF Pro Display',

  appBarTheme: AppBarTheme(
    backgroundColor: ThemeColor.lightBackground,
    foregroundColor: ThemeColor.lightPrimaryText,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w600,
      color: ThemeColor.lightPrimaryText,
    ),
  ),

  cardTheme: CardTheme(
    color: ThemeColor.lightCardBackground,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    shadowColor: Colors.black.withOpacity(0.1),
  ),

  iconTheme: IconThemeData(
    color: ThemeColor.systemBlue,
    size: 24,
  ),
  
  textTheme: TextTheme(
    headlineLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: ThemeColor.lightPrimaryText,
    ),
    headlineMedium: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: ThemeColor.lightPrimaryText,
    ),
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: ThemeColor.lightPrimaryText,
    ),
    bodyLarge: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w400,
      color: ThemeColor.lightPrimaryText,
    ),
    bodyMedium: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: ThemeColor.lightSecondaryText,
    ),
    bodySmall: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: ThemeColor.lightTertiaryText,
    ),
  ),
  
  colorScheme: ColorScheme.light(
    brightness: Brightness.light,
    primary: ThemeColor.systemBlue,
    onPrimary: Colors.white,
    secondary: ThemeColor.systemGreen,
    onSecondary: Colors.white,
    tertiary: ThemeColor.systemOrange,
    onTertiary: Colors.white,
    error: ThemeColor.systemRed,
    onError: Colors.white,
    surface: ThemeColor.lightSurface,
    onSurface: ThemeColor.lightPrimaryText,
    background: ThemeColor.lightBackground,
    onBackground: ThemeColor.lightPrimaryText,
    primaryContainer: ThemeColor.lightCardBackground,
    onPrimaryContainer: ThemeColor.lightPrimaryText,
    secondaryContainer: ThemeColor.lightSecondaryBackground,
    onSecondaryContainer: ThemeColor.lightSecondaryText,
    outline: ThemeColor.systemGray,
  ),
);