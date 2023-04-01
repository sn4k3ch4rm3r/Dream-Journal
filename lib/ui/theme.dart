import 'package:flutter/material.dart';

class DynamicTheme {
  static const Color _fallbackColor = Colors.deepPurple;

  static ThemeData fromDynamicScheme(ColorScheme? dynamicScheme, {Brightness brightness = Brightness.light}) {
    ColorScheme colorScheme = dynamicScheme ?? ColorScheme.fromSeed(seedColor: _fallbackColor, brightness: brightness);
    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w400,
          color: colorScheme.onSurface,
        ),
      ),
    );
  }
}
