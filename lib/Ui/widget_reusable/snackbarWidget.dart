import 'package:flutter/material.dart';

class WidgetSnackBar {
  static snackBarWidget(BuildContext context, {required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            message,
            style: const TextStyle(color: Colors.black),
          ),
        ),
        backgroundColor: Colors.tealAccent,
        elevation: 0,
        width: 150,
        behavior: SnackBarBehavior.floating,
        shape: const StadiumBorder(),
        duration: const Duration(milliseconds: 700),
        clipBehavior: Clip.none,
        dismissDirection: DismissDirection.down,
      ),
    );
  }
}
