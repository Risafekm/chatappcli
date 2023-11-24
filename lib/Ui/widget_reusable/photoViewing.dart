// ignore_for_file: file_names

import 'dart:developer';

import 'package:chat_app_cli/Ui/widget_reusable/snackbarWidget.dart';
import 'package:chat_app_cli/api/API.dart';
import 'package:chat_app_cli/models/messageModel.dart';
import 'package:chat_app_cli/models/userModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_fonts/google_fonts.dart';

class PhotoViewing extends StatefulWidget {
  final MessageUser msg;

  const PhotoViewing({super.key, required this.msg});

  @override
  State<PhotoViewing> createState() => _PhotoViewingState();
}

class _PhotoViewingState extends State<PhotoViewing> {
  List<ChatUser> list = [];
  late ChatUser user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: MaterialButton(
            minWidth: 30,
            onPressed: () => Navigator.pop(context),
            color: Colors.white70,
            shape: const CircleBorder(),
            child: const Icon(
              CupertinoIcons.back,
              size: 26,
            ),
          ),
        ),
        title: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(API.me.image),
                ),
              ),
            ),
            const SizedBox(width: 30),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                Text(
                  list.isNotEmpty ? list[0].name : API.me.name,
                  style: GoogleFonts.acme(color: Colors.black87, fontSize: 20),
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: MaterialButton(
                minWidth: 30,
                onPressed: () async {
                  try {
                    await GallerySaver.saveImage(widget.msg.msg,
                            albumName: 'Own Chat')
                        .then((sucess) {
                      // Navigator.of(context).pop();
                      if (sucess != null && sucess) {
                        WidgetSnackBar.snackBarWidget(context,
                            message: 'image saved');
                      }
                    });
                  } catch (e) {
                    log('error $e');
                  }
                },
                color: Colors.green.shade200,
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.download,
                  size: 26,
                ),
              ),
            ),
          ],
        ),
      ),
      body: GestureDetector(
        child: Center(
          child: Container(
            height: 400,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: Image.network(
              widget.msg.msg,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
