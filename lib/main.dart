import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_journal/firebase_options.dart';
import 'package:dream_journal/pages/landig/landing_view.dart';
import 'package:dream_journal/pages/main.dart';
import 'package:dream_journal/shared/database_provider.dart';
import 'package:dream_journal/shared/firestore_manager.dart';
import 'package:dream_journal/shared/models/dream.dart';
import 'package:dream_journal/shared/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true);
  if (kDebugMode) {
    try {
      FirebaseFirestore.instance.useFirestoreEmulator('192.168.0.52', 8080);
      await FirebaseAuth.instance.useAuthEmulator('192.168.0.52', 9099);
    } catch (e) {
      print('Failed to connect to emulator: $e');
    }
  }

  if (!kIsWeb && Platform.isAndroid) {
    List<Dream> oldDreams = await DatabaseProvider.db.getDreams();
    for (Dream dream in oldDreams) {
      await FirestoreManager.saveDream(dream);
      await DatabaseProvider.db.update(dream);
    }
  }

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
          home: FirebaseAuth.instance.currentUser == null ? const LandingView() : const NavigationView(),
        );
      },
    );
  }
}
