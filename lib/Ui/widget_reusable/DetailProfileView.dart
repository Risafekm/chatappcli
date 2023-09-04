// ignore_for_file: file_names

import 'package:chat_app_cli/Ui/messagePage.dart';
import 'package:chat_app_cli/models/userModel.dart';
import 'package:flutter/material.dart';

class DetailsProfileViewPage extends StatelessWidget {
  final ChatUser user;
  const DetailsProfileViewPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MessagePage(user: user),
                  ));
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
      ),
      body: SingleChildScrollView(
        child: Stack(
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                const SizedBox(height: 40),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        user.image,
                        width: 220,
                        height: 220,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return SizedBox(
                            height: 180,
                            width: 180,
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                backgroundColor: Colors.amber,
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  user.email,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 50),
                Text(
                  'Created by: ${user.createdAt}',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
