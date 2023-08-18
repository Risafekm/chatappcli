// ignore_for_file: unused_local_variable, unnecessary_brace_in_string_interps

import 'dart:developer';
import 'dart:io';

import 'package:chat_app_cli/models/messageModel.dart';
import 'package:chat_app_cli/models/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class API {
  static User get user => auth.currentUser!;

  //self information

  static late ChatUser me;
  //firebase authentication

  static FirebaseAuth auth = FirebaseAuth.instance;

  //firebase database(cloud firestore)

  static FirebaseFirestore fireStore = FirebaseFirestore.instance;

  //firebase database(cloud firestore)

  static FirebaseStorage storage = FirebaseStorage.instance;

  //to return current user

  static Future<bool> userExists() async {
    return (await fireStore.collection('users').doc(user.uid).get()).exists;
  }

// creating a new user

  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch;

    final chatUser = ChatUser(
        image: user.photoURL.toString(),
        name: user.displayName.toString(),
        about: 'Hey new one',
        createdAt: time.toString(),
        isOnline: false,
        lastActive: time.toString(),
        id: user.uid,
        pushToken: '',
        email: user.email.toString());

    return await fireStore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }
  // current user information

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser() {
    return fireStore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

//self information

  static Future<void> selfInfo() async {
    await fireStore.collection('users').doc(user.uid).get().then((value) async {
      if (value.exists) {
        me = ChatUser.fromJson(value.data()!);
      } else {
        await createUser().then((value) => selfInfo());
      }
    });
  }

  // Update function for profile

  static Future<void> updateUserInfo() async {
    await fireStore
        .collection('users')
        .doc(user.uid)
        .update({'name': me.name, 'about': me.about});
  }

// Update profile Image

  static Future<void> updateProfileImage(File file) async {
    final extension = file.path.split('.').last;
    log('extension:${extension}');
    final result = storage.ref().child('profile/ ${user.uid}.$extension');
    final uploadImage = await result
        .putFile(file, SettableMetadata(contentType: 'image/${extension}'))
        .then((p0) {
      log('byte transfered :${p0.bytesTransferred / 1000}');
    });
    me.image = await result.getDownloadURL();
    await fireStore
        .collection('users')
        .doc(user.uid)
        .update({'image': me.image});
  }

  // Conversation id
  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  // for getting all messages of a specific conversation from firestore database

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessage(
      ChatUser user) {
    return fireStore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .snapshots();
  }

  // for sending message
  static Future<void> sendMessage(
      ChatUser chatUser, String msg, Type type) async {
    //message sending time (also used as id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    //message to send

    final MessageUser message = MessageUser(
        toId: chatUser.id,
        msg: msg,
        read: '',
        type: type,
        fromId: user.uid,
        send: time);

    final ref = fireStore
        .collection('chats/${getConversationID(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson());
  }

  // update message read status => time display cheyyan

  static Future<void> updateMessageReadStatus(MessageUser message) async {
    fireStore
        .collection('chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.send)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  // last message => last message user nte listTile il show cheyyikkan veendi update message nu \
  //last message mathram pick cheyyunnathu

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser user) {
    return fireStore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('send', descending: true)
        .limit(1)
        .snapshots();
  }
  // chat image firebase lek send cheyyan veendiyulla function

  static Future<void> sendChatImage(ChatUser chatUser, File file) async {
    final extension = file.path.split('.').last;
    log('extension:${extension}');
    final result = storage.ref().child(
        'image/${getConversationID(chatUser.id)} /${DateTime.now().millisecondsSinceEpoch}.$extension');
    final uploadImage = await result
        .putFile(file, SettableMetadata(contentType: 'image/${extension}'))
        .then((p0) {
      log('byte transfered :${p0.bytesTransferred / 1000}');
    });
    
    //updating image in firebase database

    final imageUrl = await result.getDownloadURL();
    await sendMessage(chatUser, imageUrl, Type.image);
  }
}
