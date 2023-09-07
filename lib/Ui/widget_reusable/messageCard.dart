// ignore_for_file: file_names

import 'dart:developer';
import 'package:chat_app_cli/Ui/widget_reusable/photoViewing.dart';
import 'package:chat_app_cli/Ui/widget_reusable/snackbarWidget.dart';
import 'package:chat_app_cli/helper/timeUntil.dart';
import 'package:chat_app_cli/models/messageModel.dart';
import 'package:chat_app_cli/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';

import '../../api/API.dart';

class MessageCard extends StatefulWidget {
  final MessageUser message;
  const MessageCard({super.key, required this.message});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  late ChatUser user;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.message.type == Type.image
            ? showDialog(
                context: context,
                builder: (context) {
                  return PhotoViewing(msg: widget.message);
                },
              )
            : null;
      },
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Colors.white,
              elevation: 1,
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.message.type == Type.text
                      ? iconText(
                          onTap: () async {
                            await Clipboard.setData(
                                    ClipboardData(text: widget.message.msg))
                                .then((value) {
                              Navigator.of(context).pop();
                              WidgetSnackBar.snackBarWidget(context,
                                  message: 'message copied');
                            });
                          },
                          text: 'Copy',
                          color: Colors.black,
                          icon: Icons.copy)
                      : iconText(
                          text: 'Download',
                          color: Colors.black,
                          icon: Icons.download,
                          onTap: () async {
                            try {
                              await GallerySaver.saveImage(widget.message.msg,
                                      albumName: 'Own Chat')
                                  .then((sucess) {
                                Navigator.of(context).pop();
                                if (sucess != null && sucess) {
                                  WidgetSnackBar.snackBarWidget(context,
                                      message: 'image saved');
                                }
                              });
                            } catch (e) {
                              log('error $e');
                            }
                          },
                        ),
                  const SizedBox(height: 10),
                  iconText(
                      text: 'Edit',
                      color: Colors.black,
                      icon: Icons.edit,
                      onTap: () {
                        Navigator.of(context).pop();
                        showDialog(
                          context: context,
                          builder: (context) {
                            var updatedMsg = widget.message.msg;
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: Colors.grey.shade100,
                              contentPadding: const EdgeInsets.all(4),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 45,
                                      width: 240,
                                      child: TextFormField(
                                        initialValue: updatedMsg,
                                        onChanged: (value) =>
                                            updatedMsg = value,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Colors.blue,
                                              width: 1.8,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Colors.blue,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, bottom: 8.0),
                                    child: MaterialButton(
                                      minWidth: 30,
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        API.updateMessage(
                                            widget.message, updatedMsg);
                                        WidgetSnackBar.snackBarWidget(context,
                                            message: 'message updated');
                                      },
                                      color: Colors.lightGreen,
                                      shape: const CircleBorder(),
                                      child: const Icon(
                                        Icons.send,
                                        color: Colors.white,
                                        size: 26,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }),
                  const SizedBox(height: 10),
                  iconText(
                    onTap: () async {
                      await API.deleteMessage(widget.message).then((value) {
                        Navigator.of(context).pop();
                        WidgetSnackBar.snackBarWidget(context,
                            message: 'deleted message');
                      });
                    },
                    text: 'Delete',
                    color: Colors.red,
                    icon: Icons.delete,
                  ),
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
      {required String text,
      required IconData icon,
      required Color color,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 45,
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.cyan.shade200,
          border: Border.all(color: Colors.grey.shade300, width: 2),
        ),
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
                : EdgeInsets.all(MediaQuery.of(context).size.height * .019),
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.height * .03,
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
                  : Border.all(color: Colors.grey.shade300, width: 2),
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
              widget.message.read.isNotEmpty
                  ? const Icon(
                      Icons.done_all_outlined,
                      size: 20,
                      color: Colors.blue,
                    )
                  : const Icon(
                      Icons.done,
                      size: 20,
                      color: Colors.black45,
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
              widget.message.read.isNotEmpty
                  ? const Icon(
                      Icons.done_all_outlined,
                      size: 20,
                      color: Colors.blue,
                    )
                  : const Icon(
                      Icons.done,
                      size: 20,
                      color: Colors.black45,
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
                : EdgeInsets.all(MediaQuery.of(context).size.height * .019),
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.height * .04,
                vertical: MediaQuery.of(context).size.height * .01),
            decoration: BoxDecoration(
              border: widget.message.type == Type.image
                  ? null
                  : Border.all(color: Colors.grey.shade300, width: 2),
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
