// ignore_for_file: file_names

import 'package:chat_app_cli/models/userModel.dart';
import 'package:flutter/material.dart';

class ViewProfilePic extends StatelessWidget {
  final ChatUser user;
  const ViewProfilePic({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      shape: const CircleBorder(),
      content: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
          showDialog(
            context: context,
            builder: (context) => FullViewProfile(
              user: user,
            ),
          );
        },
        child: Container(
          height: MediaQuery.of(context).size.height * 0.32,
          width: MediaQuery.of(context).size.width * 0.48,
          decoration: BoxDecoration(
            color: Colors.amber,
            image: DecorationImage(
              image: NetworkImage(user.image),
              fit: BoxFit.cover,
            ),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class FullViewProfile extends StatelessWidget {
  final ChatUser user;
  const FullViewProfile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        Navigator.of(context).pop();
      },
      child: SizedBox(
        height: 300,
        width: 300,
        child: Image.network(user.image),
      ),
    );
  }
}
