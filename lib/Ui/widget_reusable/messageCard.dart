// ignore_for_file: file_names

import 'dart:developer';
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
    return InkWell(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              elevation: 1,
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.message.type == Type.text
                      ? iconText(
                          text: 'Copy', color: Colors.black, icon: Icons.copy)
                      : iconText(
                          text: 'Download',
                          color: Colors.black,
                          icon: Icons.download),
                  const SizedBox(height: 10),
                  iconText(text: 'Edit', color: Colors.black, icon: Icons.edit),
                  const SizedBox(height: 10),
                  iconText(
                      text: 'Delete', color: Colors.red, icon: Icons.delete),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
        log('Clicked');
      },
      child: API.user.uid == widget.message.fromId
          ? _greenMessage()
          : _blueMessage(),
    );
  }

// alert box icons and text

  Widget iconText(
      {required String text, required IconData icon, required Color color}) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 45,
        width: 150,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.shade300),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(
                width: 20,
              ),
              Text(
                text,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
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
                ? null
                : EdgeInsets.all(MediaQuery.of(context).size.height * .028),
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.height * .04,
                vertical: MediaQuery.of(context).size.height * .01),
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
              borderRadius: widget.message.type == Type.image
                  ? const BorderRadius.all(
                      Radius.circular(20),
                    )
                  : const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
              border: widget.message.type == Type.image
                  ? null
                  : Border.all(color: Colors.grey),
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
                ? null
                : EdgeInsets.all(MediaQuery.of(context).size.height * .028),
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.height * .04,
                vertical: MediaQuery.of(context).size.height * .01),
            decoration: BoxDecoration(
              border: widget.message.type == Type.image
                  ? null
                  : Border.all(color: Colors.grey),
              color: const Color.fromARGB(255, 17, 228, 207),
              borderRadius: widget.message.type == Type.image
                  ? const BorderRadius.all(
                      Radius.circular(20),
                    )
                  : const BorderRadius.only(
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
