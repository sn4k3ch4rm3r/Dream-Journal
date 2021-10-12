import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Themes {

  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.dark(
      primary: Colors.lightBlue[800],
      secondary: Color.fromARGB(255, 0, 74, 119),
    ),
    canvasColor: Colors.black,
    textTheme: GoogleFonts.openSansTextTheme(
      TextTheme(
        bodyText2: TextStyle(
          color: Colors.white,
          fontSize: 13,
        ),
        headline4: TextStyle(
          color: Colors.white,
        ),
        headline6: TextStyle(
          color: Colors.white,
        ),
      ),
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
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: Color.fromARGB(255, 195, 231, 255),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected))
          return Colors.lightBlue[800];
        return Colors.grey;
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected))
          return Colors.lightBlue[900];
        return Colors.grey[700];
      }),
    ),
  );

  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.light(
      primary: Colors.blue,
      secondary: Colors.lightBlue
    )
  );
}