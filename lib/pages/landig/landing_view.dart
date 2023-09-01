import 'dart:io';
import 'package:dream_journal/pages/main.dart';
import 'package:dream_journal/shared/database_provider.dart';
import 'package:dream_journal/shared/firestore_manager.dart';
import 'package:dream_journal/shared/models/dream.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LandingView extends StatefulWidget {
  const LandingView({super.key});

  @override
  State<LandingView> createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  Future<void> _handleLogin() async {
    if (!kIsWeb && Platform.isAndroid) {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (FirebaseAuth.instance.currentUser != null) {
        List<Dream> oldDreams = await DatabaseProvider.db.getDreams();
        for (Dream dream in oldDreams) {
          await FirestoreManager.saveDream(dream);
          await DatabaseProvider.db.update(dream);
        }
      }
    } else {
      await FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Login to sync with the cloud',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              //google auth button using firebase auth
              SignInButton(
                Buttons.google,
                onPressed: () => _handleLogin().then((_) {
                  if (FirebaseAuth.instance.currentUser != null) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const NavigationView()));
                  }
                }),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              //maybe later
            ],
          ),
        ),
      ),
    );
  }
}
