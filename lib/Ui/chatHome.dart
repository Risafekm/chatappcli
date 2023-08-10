import 'package:chat_app_cli/Services/auth_service.dart';
import 'package:chat_app_cli/Ui/profilePage.dart';
import 'package:chat_app_cli/Ui/widget_reusable/chatuserCard.dart';
import 'package:chat_app_cli/api/API.dart';
import 'package:chat_app_cli/models/userModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ChatHome extends StatefulWidget {
  const ChatHome({super.key});

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
                      color: Colors.grey),
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
                    ? const Icon(
                        CupertinoIcons.clear_circled,
                        size: 26,
                        color: Colors.black,
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
            onPressed: () {},
            child: const Icon(
              CupertinoIcons.chat_bubble,
              color: Colors.white,
            ),
          ),
          body: StreamBuilder(
            stream: API.getAllUser(),
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
                          .map<ChatUser>((e) => ChatUser.fromJson(e.data()))
                          .toList() ??
                      [];
                  if (list.isNotEmpty) {
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: _isSearch ? searchList.length : list.length,
                      itemBuilder: (context, index) {
                        return ChatUserCard(
                            user: _isSearch ? searchList[index] : list[index]);
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
      ),
    );
  }
}
