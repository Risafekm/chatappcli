import 'package:chat_app_cli/Services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widget_reusable/widgets.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  AuthServices authServices = AuthServices();
  User? user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 29, 110, 148),
      body: SingleChildScrollView(
        clipBehavior: Clip.none,
        child: Stack(
          //Stack Starting
          clipBehavior: Clip.none,
          children: [
            backGroundImageSlide(),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                //Column Starting
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),
                  welcome(),
                  const SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: subTitle(),
                  ),
                  const SizedBox(height: 100),
                  iconMsg(),
                  const SizedBox(height: 100),
                  loginButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget iconMsg() {
    return SizedBox(
      height: 250,
      width: 250,
      child: Center(
        child: Image.asset('assets/msgIcon1.png'),
      ),
    );
  }

  Widget loginButton() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 5,
      child: SizedBox(
        height: 60,
        width: 300,
        child: ElevatedButton(
          onPressed: () async {
            showDialog(
              context: context,
              builder: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
            );
            await authServices.signInWithGoogle(context);
          },
          style: elevatedButtonStyle(),
          child: Row(
            children: [
              Image.asset('assets/google.png'),
              Text(
                'Login with Google',
                style: GoogleFonts.crimsonText(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget subTitle() {
    return Text(
      'login now & Continue your chat!!!',
      maxLines: 2,
      style: subHeadingCaption(),
    );
  }

  Widget welcome() {
    return Text(
      'WELCOME',
      style: headingCaptionStyle(),
    );
  }

  Widget backGroundImageSlide() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple,
            Colors.pink,
            Colors.orange,
          ],
        ),
      ),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
    );
  }
}
