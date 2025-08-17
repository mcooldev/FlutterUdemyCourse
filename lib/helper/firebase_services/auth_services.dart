import 'package:firebase_auth/firebase_auth.dart';

import '../../models/user_model.dart';

class Auth {
  /// singleton class
  Auth._();

  static final Auth instance = Auth._();

  /// Firebase Authentication
  FirebaseAuth auth = FirebaseAuth.instance;

  // Sign in with email and password.
  Future<UserCredential> signInWithEmailAndPassword(UserModel user) async {
    return auth.signInWithEmailAndPassword(
      email: user.email,
      password: user.password,
    );
  }

  // Sign up with email and password.
  Future<UserCredential> signUpWithEmailAndPassword(UserModel user) async {
    return auth.createUserWithEmailAndPassword(
      email: user.email,
      password: user.password,
    );
  }

  // Sign out.
  Future<void> signOut() async {
    return auth.signOut();
  }
}
