import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../pages/chat_app/home_chat.dart';
import '../../pages/chat_app/login.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    ///
    final stream = FirebaseAuth.instance.authStateChanges();

    ///
    return StreamBuilder(
      stream: stream,
      builder: (ctx, snapshot) {
        //
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        //
        if (snapshot.hasData) {
          return const HomeChat();
        }
        //
        if (!snapshot.hasData) {
          return const Login();
        }
        //
        return const Center(child: Text("⚠️ An unknown error occurred !"));
      },
    );
  }
}
