import 'package:dream_journal/ui/navigationview.dart';
import 'package:dream_journal/ui/themes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(DreamJournal());
}

class DreamJournal extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dream Journal',
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      themeMode: ThemeMode.system,
      home: NavigationView(),
    );
  }
}