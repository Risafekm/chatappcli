import 'package:chat_app_cli/models/userModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            flexibleSpace: _appBar(),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                _messageBody(),
                _bottomField(),
              ],
            ),
          )),
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
