import 'package:chat_app_cli/Ui/chatHome.dart';
import 'package:chat_app_cli/api/API.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Ui/login/loginPage.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Colors.white),
        primarySwatch: Colors.blue,
      ),
      // home: const SplashScreen(),
      home: StreamBuilder(
        stream: API.auth.authStateChanges(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return const ChatHome();
          } else {
            return const SignInPage();
          }
        },
      ),
    );
  }
}
