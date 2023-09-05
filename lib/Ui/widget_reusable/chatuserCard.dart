// ignore_for_file: file_names

import 'dart:developer';

import 'package:chat_app_cli/Ui/messagePage.dart';
import 'package:chat_app_cli/Ui/widget_reusable/viewProfilePic.dart';
import 'package:chat_app_cli/api/API.dart';
import 'package:chat_app_cli/helper/timeUntil.dart';
import 'package:chat_app_cli/models/messageModel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/userModel.dart';

class ChatUserCard extends StatefulWidget {
  const ChatUserCard({
    super.key,
    required this.user,
  });

  final ChatUser user;

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  MessageUser? _message;
  List<MessageUser> _list = [];
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MessagePage(user: widget.user)));
        },
        child: Container(
            height: 80,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: StreamBuilder(
              stream: API.getLastMessage(widget.user),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;

                _list = data
                        ?.map<MessageUser>(
                            (e) => MessageUser.fromJson(e.data()))
                        .toList() ??
                    [];

                if (_list.isNotEmpty) _message = _list[0];

                return ListTile(
                  leading: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return ViewProfilePic(
                            user: widget.user,
                          );
                        },
                      );
                      log('Clicked');
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        image: DecorationImage(
                            image: NetworkImage(widget.user.image),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(120),
                      ),
                    ),
                  ),
                  title: Text(
                    widget.user.name,
                    style:
                        GoogleFonts.acme(color: Colors.black87, fontSize: 18),
                  ),
                  subtitle: Text(
                    _message != null
                        ? _message!.type == Type.image
                            ? 'image'
                            : _message!.msg
                        : widget.user.about,
                    maxLines: 1,
                    style:
                        GoogleFonts.acme(color: Colors.black54, fontSize: 12),
                  ),
                  trailing: _message == null
                      ? null
                      : _message!.read.isEmpty &&
                              _message?.fromId != API.user.uid
                          ? Container(
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.greenAccent.shade400,
                              ),
                            )
                          : Text(
                              TimeUntil.getLastMessage(context, _message!.send),
                            ),
                );
              },
            )),
      ),
    );
  }
}
