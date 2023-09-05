// ignore_for_file: file_names

import 'package:chat_app_cli/helper/timeUntil.dart';
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
              Navigator.of(context).pop();
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
                const SizedBox(height: 10),
                //image ,name and gmail
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(180),
                      child: Image.network(
                        user.image,
                        width: 200,
                        height: 200,
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
                const SizedBox(height: 25),

                //about and created date
                Text(
                  user.name,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                Text(
                  user.email,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 25),

                // row call,video and search icons
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.call,
                          color: Colors.teal,
                          size: 28,
                        ),
                        SizedBox(height: 5),
                        Text(
                          'call',
                          style: TextStyle(color: Colors.teal, fontSize: 17),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.video_call,
                          color: Colors.teal,
                          size: 30,
                        ),
                        SizedBox(height: 5),
                        Text(
                          'video',
                          style: TextStyle(color: Colors.teal, fontSize: 17),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          color: Colors.teal,
                          size: 30,
                        ),
                        SizedBox(height: 5),
                        Text(
                          'search',
                          style: TextStyle(color: Colors.teal, fontSize: 17),
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 100),
                Card(
                  child: Container(
                    height: 80,
                    width: MediaQuery.of(context).size.width,
                    decoration:
                        const BoxDecoration(color: Colors.white30, boxShadow: [
                      BoxShadow(
                        color: Colors.white24,
                        offset: Offset(0, 3),
                        spreadRadius: 6,
                        blurRadius: 4,
                      ),
                    ]),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          'about: ${user.about}',
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Created by: ${TimeUntil.getLastMessage(context, user.createdAt)}',
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
