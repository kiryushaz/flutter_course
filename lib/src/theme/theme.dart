import 'package:flutter/material.dart';

import 'app_colors.dart';

final coffeeAppTheme = ThemeData(
  fontFamily: 'Roboto',
  primaryColor: CoffeeAppColors.primary,
  elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all(CoffeeAppColors.primary),
    foregroundColor: MaterialStateProperty.all(CoffeeAppColors.secondaryTextColor)
  )
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: CoffeeAppColors.primary,
    background: CoffeeAppColors.screenBackground,
    surface: CoffeeAppColors.screenBackground,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: CoffeeAppColors.primary,
    foregroundColor: CoffeeAppColors.secondaryTextColor
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal)
  ),
  useMaterial3: true
);
