import 'dart:developer';

import 'package:chat_app_cli/Ui/SplashScreen/splashScreen.dart';
import 'package:chat_app_cli/api/API.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var result = await FlutterNotificationChannel.registerNotificationChannel(
    description: 'showing message notification',
    id: 'chats',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'Chats',
  );
  log(result);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat_app',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Colors.white),
        primarySwatch: Colors.blue,
      ),
      // home: const SplashScreen(),
      home: StreamBuilder(
        stream: API.auth.authStateChanges(),
        builder: (context, AsyncSnapshot snapshot) {
          return const SplashScreen();
        },
      ),
    );
  }
}
