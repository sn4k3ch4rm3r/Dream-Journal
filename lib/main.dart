import 'package:dream_journal/ui/navigationview.dart';
import 'package:dream_journal/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const DreamJournal());
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
  ));
}

class DreamJournal extends StatelessWidget {
  const DreamJournal({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (light, dark) {
        return MaterialApp(
          title: 'Dream Journal',
          theme: DynamicTheme.fromDynamicScheme(light),
          darkTheme: DynamicTheme.fromDynamicScheme(dark, brightness: Brightness.dark),
          themeMode: ThemeMode.system,
          home: const NavigationView(),
        );
      },
    );
  }
}
