// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:developer';

import 'package:chat_app_cli/models/messageModel.dart';
import 'package:chat_app_cli/models/userModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../api/API.dart';
import 'widget_reusable/messageCard.dart';

class MessagePage extends StatefulWidget {
  final ChatUser user;
  const MessagePage({
    super.key,
    required this.user,
  });

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  List<MessageUser> list = [];
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              flexibleSpace: _appBar(),
            ),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: API.getAllMessages(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      switch (snapshot.connectionState) {
                        // data is loading
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        //all data is loaded
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;

                          list = data
                                  .map<MessageUser>(
                                      (e) => MessageUser.fromJson(e.data()))
                                  .toList() ??
                              [];
                          list.add(MessageUser(
                              toId: 'ghh',
                              msg: 'Hi Risaf',
                              read: '',
                              type: Type.text,
                              fromId: API.user.uid,
                              send: '10.00 am'));
                          list.add(MessageUser(
                              toId: API.user.uid,
                              msg:
                                  'enthokke und visheshammmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm',
                              read: '',
                              type: Type.text,
                              fromId: 'dgc',
                              send: '10.10 am'));
                          if (list.isNotEmpty) {
                            return ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                //messageCard
                                return MessageCard(message: list[index]);
                              },
                            );
                          } else {
                            return const Center(
                              child: Text('No data'),
                            );
                          }
                      }
                    },
                  ),
                ),
                _bottomField(),
              ],
            )),
      ),
    );
  }

// Text message input area and icons
  _bottomField() {
    return Row(
      children: [
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.emoji_emotions,
                        color: Colors.blueAccent, size: 26)),
                const SizedBox(width: 10),
                const Expanded(
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Type message...',
                      hintStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.attach_file_sharp,
                        color: Colors.blueAccent, size: 26)),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(CupertinoIcons.camera_circle_fill,
                      color: Colors.blueAccent, size: 31),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: MaterialButton(
            minWidth: 20,
            onPressed: () {},
            color: Colors.lightGreen,
            shape: const CircleBorder(),
            child: const Icon(Icons.send, size: 26, color: Colors.white),
          ),
        ),
      ],
    );
  }

  //AppBar
  _appBar() {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
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
        const SizedBox(width: 10),
        Container(
          height: 43,
          width: 43,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Stack(
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    widget.user.image,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              widget.user.name,
              style: GoogleFonts.acme(color: Colors.black87, fontSize: 18),
            ),
            const SizedBox(height: 2),
            const Text(
              'last active time',
              style: TextStyle(color: Colors.black45, fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }
}
