import 'package:chat_app_cli/main.dart';
import 'package:chat_app_cli/models/messageModel.dart';
import 'package:flutter/material.dart';

import '../../api/API.dart';

class MessageCard extends StatefulWidget {
  final MessageUser message;
  const MessageCard({super.key, required this.message});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return API.user.uid == widget.message.fromId
        ? _blueMessage()
        : _greenMessage();
  }

  // from message
  Widget _blueMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // message box

        Flexible(
          child: Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.height * .04),
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.height * .04,
                vertical: MediaQuery.of(context).size.height * .01),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 192, 211, 244),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              border: Border.all(color: Colors.blue),
            ),
            child: Text(widget.message.msg),
          ),
        ),

        // send time

        Padding(
          padding: const EdgeInsets.only(right: 8.0, top: 20),
          child: Text(
            widget.message.send,
            style: const TextStyle(fontSize: 15, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  //to message
  _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // send time

        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 20),
          child: Text(
            widget.message.send,
            style: const TextStyle(fontSize: 15, color: Colors.black54),
          ),
        ),

        // message box

        Flexible(
          child: Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.height * .04),
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.height * .04,
                vertical: MediaQuery.of(context).size.height * .01),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              color: const Color.fromARGB(255, 174, 235, 205),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
            ),
            child: Text(widget.message.msg),
          ),
        ),
      ],
    );
  }
}
