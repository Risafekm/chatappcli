// ignore_for_file: file_names

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app_cli/helper/timeUntil.dart';
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
        ? _greenMessage()
        : _blueMessage();
  }

  // from message

  Widget _blueMessage() {
    if (widget.message.read.isEmpty) {
      API.updateMessageReadStatus(widget.message);
      log('Message read updated');
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // message box

        Flexible(
          child: Container(
            padding: widget.message.type == Type.image
                ? EdgeInsets.all(MediaQuery.of(context).size.height * .01)
                : EdgeInsets.all(MediaQuery.of(context).size.height * .028),
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.height * .04,
                vertical: MediaQuery.of(context).size.height * .01),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 192, 211, 244),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              border: Border.all(color: Colors.blue),
            ),
            child: widget.message.type == Type.text
                ? Text(
                    widget.message.msg,
                    style: const TextStyle(fontSize: 18),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      widget.message.msg,
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
                              value: loadingProgress.expectedTotalBytes != null
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

        // send time

        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              Text(
                TimeUntil.getTimeUntil(context, widget.message.send),
                style: const TextStyle(fontSize: 15, color: Colors.black54),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * .02),
              const Icon(
                Icons.done_all_outlined,
                size: 20,
                color: Colors.blue,
              ),
              SizedBox(width: MediaQuery.of(context).size.width * .04),
            ],
          ),
        ),
      ],
    );
  }

  //To message
  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // send time

        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              SizedBox(width: MediaQuery.of(context).size.width * .04),
              const Icon(
                Icons.done_all_outlined,
                size: 20,
                color: Colors.blue,
              ),
              SizedBox(width: MediaQuery.of(context).size.width * .02),
              Text(
                TimeUntil.getTimeUntil(context, widget.message.send),
                style: const TextStyle(fontSize: 15, color: Colors.black54),
              ),
            ],
          ),
        ),
        // message box

        Flexible(
          child: Container(
            padding: widget.message.type == Type.image
                ? EdgeInsets.all(MediaQuery.of(context).size.height * .01)
                : EdgeInsets.all(MediaQuery.of(context).size.height * .028),
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.height * .04,
                vertical: MediaQuery.of(context).size.height * .01),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              color: const Color.fromARGB(255, 174, 235, 205),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            child: widget.message.type == Type.text
                ? Text(
                    widget.message.msg,
                    style: const TextStyle(fontSize: 18),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      widget.message.msg,
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
                              value: loadingProgress.expectedTotalBytes != null
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
      ],
    );
  }
}
