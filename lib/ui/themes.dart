import 'package:flutter/material.dart';

class Themes {
  static ThemeData darkTeal() {
    return ThemeData(
      colorScheme: ColorScheme.dark(
        primary: Colors.teal,
      ),
      primaryColor: Colors.blueGrey[900],
      primaryColorLight: Colors.blueGrey,
      accentColor: Colors.teal,
      canvasColor: Colors.grey[900],
      textTheme: TextTheme(
        bodyText2: TextStyle(
          color: Colors.white,
        ),
        headline4: TextStyle(
          color: Colors.white,
        ),
        headline6: TextStyle(
          color: Colors.white,
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.blueGrey[700],
        textTheme: ButtonTextTheme.primary
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: Colors.teal,
        inactiveTrackColor: Colors.blueGrey[900],
        thumbColor: Colors.tealAccent,
      ),
      dialogTheme: DialogTheme(
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        contentTextStyle: TextStyle(
          color: Colors.white,
        ),
        backgroundColor: Colors.grey[800],
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal,
      )
    );
  }
}