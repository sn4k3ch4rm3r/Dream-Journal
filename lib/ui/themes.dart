import 'package:flutter/material.dart';

class Themes {
  static ThemeData darkTeal() {
    return ThemeData(
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
        thumbColor: Colors.teal,
      )
    );
  }
}