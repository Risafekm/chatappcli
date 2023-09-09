// ignore_for_file: file_names, curly_braces_in_flow_control_structures

import 'dart:developer';

import 'package:chat_app_cli/Services/auth_service.dart';
import 'package:chat_app_cli/Ui/profilePage.dart';
import 'package:chat_app_cli/Ui/widget_reusable/chatuserCard.dart';
import 'package:chat_app_cli/api/API.dart';
import 'package:chat_app_cli/models/userModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'widget_reusable/snackbarWidget.dart';

class ChatHome extends StatefulWidget {
  const ChatHome({
    super.key,
  });

  @override
  State<ChatHome> createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  AuthServices authServices = AuthServices();
  List<ChatUser> list = [];
  List<ChatUser> searchList = [];
  bool _isSearch = false;

  @override
  void initState() {
    API.selfInfo();
    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message:$message');
      if (API.auth.currentUser != null) if (message
          .toString()
          .contains('resume')) {
        API.updateActiveStatus(true);
      }
      if (message.toString().contains('pause')) API.updateActiveStatus(false);
      return Future.value(message);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_isSearch) {
            setState(() {
              _isSearch = !_isSearch;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: _isSearch
                ? TextField(
                    onChanged: (value) {
                      searchList.clear();

                      for (var i in list) {
                        if (i.name
                                .toLowerCase()
                                .contains(value.toLowerCase()) ||
                            (i.email
                                .toLowerCase()
                                .contains(value.toLowerCase()))) {
                          searchList.add(i);
                        }
                        setState(() {
                          searchList;
                        });
                      }
                    },
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'name or email.....',
                      border: InputBorder.none,
                    ),
                  )
                : const Text(
                    'OwnChat',
                    style: TextStyle(fontSize: 22, color: Colors.black),
                  ),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return ProfilePage(
                      user: API.me,
                    );
                  }));
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(180),
                    color: Colors.black,
                  ),
                  child: const Icon(
                    CupertinoIcons.person,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _isSearch = !_isSearch;
                  });
                },
                icon: _isSearch
                    ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(180),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: const Icon(
                          CupertinoIcons.clear_circled,
                          size: 26,
                          color: Colors.black,
                        ),
                      )
                    : const Icon(
                        Icons.search_outlined,
                        color: Colors.black,
                        size: 26,
                      ),
              ),
              const SizedBox(width: 5),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: MaterialButton(
                  minWidth: 30,
                  onPressed: () async {
                    API.updateActiveStatus(false);
                    await authServices.signOutGoogle(context);
                  },
                  color: Colors.white,
                  shape: const CircleBorder(),
                  child: const Icon(MdiIcons.logout),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.green,
            onPressed: () {
              showMessageUpdateBox();
            },
            child: const Icon(
              Icons.email_sharp,
              color: Colors.white,
            ),
          ),
          body: StreamBuilder(
            stream: API.getMyUsersId(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                //if data is loading
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(child: CircularProgressIndicator());

                //if some or all data is loaded then show it
                case ConnectionState.active:
                case ConnectionState.done:
                  return StreamBuilder(
                    stream: API.getAllUsers(
                        snapshot.data?.docs.map((e) => e.id).toList() ?? []),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      switch (snapshot.connectionState) {
                        // data is loading
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        //if some or all data is loaded
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;

                          list = data
                                  .map<ChatUser>(
                                      (e) => ChatUser.fromJson(e.data()))
                                  .toList() ??
                              [];
                          if (list.isNotEmpty) {
                            return ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount:
                                  _isSearch ? searchList.length : list.length,
                              itemBuilder: (context, index) {
                                return ChatUserCard(
                                    user: _isSearch
                                        ? searchList[index]
                                        : list[index]);
                              },
                            );
                          } else {
                            return const Center(
                              child: Text('Add your friends email'),
                            );
                          }
                      }
                    },
                  );
              }
            },
          ),
        ),
      ),
    );
  }

  void showMessageUpdateBox() {
    String email = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: SizedBox(
            height: 120,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Text(
                  'Add Friends',
                  style: GoogleFonts.acme(
                      fontSize: 22, color: Colors.blue.shade400),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 80,
                        child: TextFormField(
                          onChanged: (value) => email = value,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.email),
                            label: const Text(
                              'Email',
                              style: TextStyle(fontSize: 12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 26.0),
                      child: MaterialButton(
                        color: Colors.lightGreen,
                        shape: const CircleBorder(),
                        minWidth: 35,
                        onPressed: () async {
                          if (email.isNotEmpty) {
                            await API.addChatUser(email).then((value) {
                              if (!value) {
                                WidgetSnackBar.snackBarWidget(context,
                                    message: 'user not found!');
                              }
                              Navigator.pop(context);
                            });
                          }
                        },
                        child: const Icon(
                          CupertinoIcons.add,
                          size: 26,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
