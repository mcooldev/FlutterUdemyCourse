import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../helper/firebase_services/auth_services.dart';
import '../models/user_model.dart';

abstract class AuthProvider with ChangeNotifier {
  /// Auth services instance
  final Auth auth = Auth.instance;

  final emailController = TextEditingController();
  final pwdController = TextEditingController();
  bool isVisible = true;
  bool isVisibleConfirm = true;
  bool isLoading = false;

  void togglePasswordVisibility() {
    isVisible = !isVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    isVisibleConfirm = !isVisibleConfirm;
    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    pwdController.dispose();
    super.dispose();
  }
}

class LoginProvider extends AuthProvider {
  ///
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  Future<void> login(BuildContext context) async {
    if (isLoading) return;

    isLoading = true;
    notifyListeners();
    try {
      if (loginFormKey.currentState!.validate()) {
        final UserModel newUser = UserModel(
          uid: "",
          email: emailController.text,
          password: pwdController.text,
        );
        await auth.signInWithEmailAndPassword(newUser).whenComplete(() {
          if (context.mounted) {
            Navigator.of(context).pushNamed('/authGate');
          }
        });

        /// Clear fields
        emailController.clear();
        pwdController.clear();
        //
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

class RegisterProvider extends AuthProvider {
  ///
  final signupFormKey = GlobalKey<FormState>();
  final pwdConfirmController = TextEditingController();
  final userNameController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> register(BuildContext context) async {
    if (isLoading) return;

    isLoading = true;
    notifyListeners();
    try {
      if (signupFormKey.currentState!.validate()) {
        final newUser = UserModel(
          uid: "",
          email: emailController.text,
          userName: userNameController.text,
          password: pwdController.text,
        );
        final userCredential = await auth.signUpWithEmailAndPassword(newUser);
        final users = firestore.collection('users');
        final doc = users.doc(userCredential.user!.uid);
        await doc.set({
          'email': newUser.email,
          'userName': newUser.userName,
          'uid': userCredential.user!.uid,
        });

        //
        if (context.mounted) {
          Navigator.of(context).pushNamed('/authGate');
        }

        /// Clear fields
        emailController.clear();
        pwdController.clear();
        userNameController.clear();
        pwdConfirmController.clear();

        //
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Dispose controllers
  @override
  void dispose() {
    // TODO: implement dispose
    pwdConfirmController.dispose();
    userNameController.dispose();
    super.dispose();
  }
}
