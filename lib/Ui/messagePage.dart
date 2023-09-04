// ignore_for_file: unused_local_variable, file_names, use_build_context_synchronously, unused_field

import 'dart:developer';
import 'dart:io';

import 'package:chat_app_cli/Ui/widget_reusable/DetailProfileView.dart';
import 'package:chat_app_cli/helper/timeUntil.dart';
import 'package:chat_app_cli/models/messageModel.dart';
import 'package:chat_app_cli/models/userModel.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:image_picker/image_picker.dart';
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
  List<MessageUser> _list = [];
  final TextEditingController _textController = TextEditingController();
  bool isEmoji = false;
  late String _image;
  List<ChatUser> list = [];

  void selectCamera() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      log('Image path: ${image.path}');
      setState(() {
        _image = image.path;
      });
      await API.sendChatImage(widget.user, File(image.path));
    }
  }

  void selectGallery() async {
    final ImagePicker picker = ImagePicker();

    List<XFile> image = await picker.pickMultiImage(imageQuality: 80);
    for (var i in image) {
      log('Image path: ${i.path}');
      await API.sendChatImage(widget.user, File(i.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () {
            if (isEmoji) {
              setState(() {
                isEmoji = !isEmoji;
              });
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
              // backgroundColor: Color.fromARGB(238, 255, 255, 255),
              appBar: AppBar(
                elevation: 0,
                automaticallyImplyLeading: false,
                flexibleSpace: _appBar(),
              ),
              body: Column(
                children: [
                  const SizedBox(height: 10),
                  Expanded(
                    child: StreamBuilder(
                      stream: API.getAllMessage(widget.user),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        switch (snapshot.connectionState) {
                          // data is loading
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return const SizedBox();
                          //all data is loaded
                          case ConnectionState.active:
                          case ConnectionState.done:
                            final data = snapshot.data?.docs;

                            _list = data
                                    .map<MessageUser>(
                                        (e) => MessageUser.fromJson(e.data()))
                                    .toList() ??
                                [];

                            if (_list.isNotEmpty) {
                              return ListView.builder(
                                reverse: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount: _list.length,
                                itemBuilder: (context, index) {
                                  //messageCard
                                  return MessageCard(message: _list[index]);
                                },
                              );
                            } else {
                              return const Center(
                                child: Text('Say Hi'),
                              );
                            }
                        }
                      },
                    ),
                  ),
                  _bottomField(),
                  if (isEmoji)
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .30,
                      child: EmojiPicker(
                        onBackspacePressed: () {},
                        textEditingController: _textController,
                        config: Config(
                          columns: 7,
                          emojiSizeMax: 32 *
                              (foundation.defaultTargetPlatform ==
                                      TargetPlatform.iOS
                                  ? 1.30
                                  : 1.0),
                          verticalSpacing: 0,
                          horizontalSpacing: 0,
                          bgColor: const Color(0xFFF2F2F2),
                          indicatorColor: Colors.blue,
                          iconColor: Colors.grey,
                          iconColorSelected: Colors.blue,
                          backspaceColor: Colors.blue,
                          skinToneDialogBgColor: Colors.white,
                          skinToneIndicatorColor: Colors.grey,
                          enableSkinTones: true,
                          recentTabBehavior: RecentTabBehavior.RECENT,
                          recentsLimit: 28,
                          noRecents: const Text(
                            'No Recents',
                            style:
                                TextStyle(fontSize: 20, color: Colors.black26),
                            textAlign: TextAlign.center,
                          ), // Needs to be const Widget
                          loadingIndicator: const SizedBox
                              .shrink(), // Needs to be const Widget
                          tabIndicatorAnimDuration: kTabScrollDuration,
                          categoryIcons: const CategoryIcons(),
                          buttonMode: ButtonMode.MATERIAL,
                        ),
                      ),
                    ),
                ],
              )),
        ),
      ),
    );
  }

// Text message input area and icons

  _bottomField() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 3.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          isEmoji = !isEmoji;
                        });
                      },
                      icon: const Icon(Icons.emoji_emotions,
                          color: Colors.blueAccent, size: 26)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      onTap: () {
                        if (isEmoji) {
                          setState(() => isEmoji = !isEmoji);
                        }
                      },
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type message...',
                        hintStyle: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        selectGallery();
                      },
                      icon: const Icon(Icons.attach_file_sharp,
                          color: Colors.blueAccent, size: 26)),
                  IconButton(
                    onPressed: () {
                      selectCamera();
                    },
                    icon: const Icon(CupertinoIcons.camera_circle_fill,
                        color: Colors.blueAccent, size: 31),
                  ),
                ],
              ),
            ),
          ),
        ),
        MaterialButton(
          minWidth: 0,
          onPressed: () {
            if (_textController.text.isNotEmpty) {
              API.sendMessage(widget.user, _textController.text, Type.text);
              _textController.text = '';
              log(API.getAllMessage(widget.user) as String);
            }
          },
          color: Colors.lightGreen,
          shape: const CircleBorder(),
          child: const Icon(Icons.send, size: 26, color: Colors.white),
        ),
      ],
    );
  }

  //AppBar

  _appBar() {
    return StreamBuilder(
      stream: API.getUserInfo(widget.user),
      builder: (context, snapshot) {
        final data = snapshot.data?.docs;

        list =
            data?.map<ChatUser>((e) => ChatUser.fromJson(e.data())).toList() ??
                [];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailsProfileViewPage(
                  user: widget.user,
                ),
              ),
            );
          },
          child: Row(
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
                    list.isNotEmpty ? list[0].name : widget.user.name,
                    style:
                        GoogleFonts.acme(color: Colors.black87, fontSize: 18),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    list.isNotEmpty
                        ? list[0].isOnline
                            ? 'Online'
                            : TimeUntil.getLastActiveTime(
                                context: context,
                                lastActive: widget.user.lastActive)
                        : widget.user.about,
                    style: const TextStyle(color: Colors.black45, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
