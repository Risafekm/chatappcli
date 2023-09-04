// ignore_for_file: must_be_immutable, use_build_context_synchronously, file_names

import 'dart:developer';
import 'dart:io';

import 'package:chat_app_cli/Ui/chatHome.dart';
import 'package:chat_app_cli/api/API.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../models/userModel.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key, required this.user});

  ChatUser user;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _image;

  void selectImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      log('Image path: ${image.path}');
      setState(() {
        _image = image.path;
      });
      API.updateProfileImage(File(_image!));

      //Navigation part
      Navigator.pop(context);
    }
  }

  void selectCamera() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      log('Image path: ${image.path}');
      setState(() {
        _image = image.path;
      });
      API.updateProfileImage(File(_image!));
      //Navigation part
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(color: Colors.black),
          centerTitle: true,
          title: const Text(
            'Profile Screen',
            style: TextStyle(fontSize: 22, color: Colors.black),
          ),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    _image != null
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 25.0),
                              child: Container(
                                height: 160,
                                width: 160,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.file(
                                    File(_image!),
                                    width: 160,
                                    height: 160,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 25.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.network(
                                  widget.user.image,
                                  width: 160,
                                  height: 160,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
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
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                    Positioned(
                      bottom: 10,
                      right: 95,
                      child: MaterialButton(
                        onPressed: () {
                          //BottomModalSheet
                          _showBottomSheet();
                        },
                        color: Colors.white,
                        shape: const CircleBorder(),
                        child: const Icon(MdiIcons.accountEditOutline),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                Text(
                  widget.user.email,
                  style: const TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 40),

                // TextFormField fields

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: widget.user.name,
                    onSaved: (val) => API.me.name = val ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : 'required field',
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      label: const Text(
                        'Name',
                      ),
                      hintText: 'eg : Arun',
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.black.withOpacity(.6),
                        size: 26,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: widget.user.about,
                    onSaved: (val) => API.me.about = val ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : 'required field',
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'eg : feel good',
                      label: const Text(
                        'About',
                      ),
                      prefixIcon: Icon(
                        Icons.error,
                        color: Colors.black.withOpacity(.6),
                        size: 26,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 60),

                // Update  Button

                Container(
                  height: 50,
                  width: 170,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty
                            .all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: const BorderSide(color: Colors.white)))),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        API.updateUserInfo().then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: const Text('successful'),
                                backgroundColor: Colors.green.withOpacity(.8),
                                behavior: SnackBarBehavior.floating),
                          );
                          Future.delayed(
                              const Duration(
                                milliseconds: 500,
                              ), () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ChatHome()));
                          });
                        });
                      }
                    },
                    child: const Text(
                      'Update',
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showBottomSheet() {
    showModalBottomSheet(
      elevation: 0,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      context: context,
      builder: (context) {
        return Stack(
          children: [
            Container(
              margin:
                  const EdgeInsets.only(top: 5, right: 8, left: 8, bottom: 20),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.grey,
              ),
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      selectImage();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: const CircleBorder(),
                    ),
                    child: SizedBox(
                      height: 120,
                      width: 140,
                      child: Image.asset(
                        'assets/file.png',
                        scale: 6.3,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: const CircleBorder(),
                    ),
                    onPressed: () {
                      selectCamera();
                    },
                    child: SizedBox(
                      height: 120,
                      width: 140,
                      child: Image.asset(
                        'assets/camera.webp',
                        scale: 5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 4,
              right: 150,
              left: 150,
              child: Container(
                height: 5,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
