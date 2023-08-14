// ignore_for_file: file_names

import 'package:chat_app_cli/Ui/messagePage.dart';
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
          child: ListTile(
              leading: Container(
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
              title: Text(
                widget.user.name,
                style: GoogleFonts.acme(color: Colors.black87, fontSize: 18),
              ),
              subtitle: Text(
                widget.user.email,
                style: GoogleFonts.acme(color: Colors.black54, fontSize: 12),
              ),
              trailing: Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.greenAccent.shade400,
                ),
              )),
        ),
      ),
    );
  }
}
