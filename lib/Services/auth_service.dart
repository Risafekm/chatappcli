// ignore_for_file: unused_local_variable, use_build_context_synchronously

import 'package:chat_app_cli/Ui/chatHome.dart';
import 'package:chat_app_cli/Ui/login/loginPage.dart';
import 'package:chat_app_cli/api/API.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      //await InternetAddress.lookup('google.com');
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );
        final userCredential =
            await firebaseAuth.signInWithCredential(credential);

        showDialog(
          context: context,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );

        if ((await API.userExists())) {
          //Navigation

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const ChatHome()),
              (route) => false);
        } else {
          API.createUser().then((value) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const ChatHome()),
                (route) => false);
          });
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('try again')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Check your internet connection')));
    }
  }

  Future<void> signOutGoogle(BuildContext context) async {
    try {
      googleSignIn.signOut();
      firebaseAuth.signOut();

      //Navigation
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SignInPage()),
          (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Error is detected')));
    }
  }
}
