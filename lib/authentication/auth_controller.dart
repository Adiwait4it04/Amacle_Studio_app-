import 'dart:developer';
import 'package:amacle_studio_app/main.dart';
import 'package:amacle_studio_app/pages/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../global/globals.dart';

class AuthController extends GetxController {
  //AuthController instance
  static AuthController instance = Get.find();
  //Email, password, name
  late Rx<User?> _user;
  FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  Map<String, dynamic>? facebookMapUserData;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.userChanges());
    Global().getEmail().then((email) async {
      log('Email: $email');
      Global.email = email;
    });
    ever(_user, _initialScreen);
  }

  _initialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => const LoginPage());
    } else {
      Get.offAll(() => const HomePage());
    }
  }

  Future<void> register(String email, String password) async {
    try {
      Global.email = email;
      Global().saveEmail(email);
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Account creation failed",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> login(String email, String password) async {
    try {
      Global.email = email;
      Global().saveEmail(email);
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Login failed",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await GoogleSignIn(scopes: <String>["email"]).signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      // Access the email ID of the registered user
      final String? email = user?.email;
      Global.email = email ?? "";
      Global().saveEmail(email ?? "");

      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    Global().destroy();
    auth.signOut;
    await googleSignIn.signOut();
    await auth.signOut();
  }
}
