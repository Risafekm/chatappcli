// ignore_for_file: file_names

import 'dart:developer';

import 'package:chat_app_cli/Ui/login/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../api/API.dart';
import '../chatHome.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      //exit full-screen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          statusBarColor: Colors.white));

      if (API.auth.currentUser != null) {
        log('\nUser: ${API.auth.currentUser}');
        //navigate to home screen
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const ChatHome()));
      } else {
        //navigate to login screen
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const SignInPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromARGB(255, 236, 214, 103),
      backgroundColor: Colors.white,

      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 200,
                  width: 200,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/msgIcon1.png'),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Text('Your Friends are waiting......',
                    style: GoogleFonts.acme(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w400)),
              ],
            ),
          ),
          const Positioned(
            bottom: 60,
            right: 170,
            left: 170,
            child: Text('Created by Risaf',
                style: TextStyle(
                    fontSize: 7,
                    color: Colors.black,
                    fontWeight: FontWeight.w400)),
          )
        ],
      ),
    );
  }
}
