// ignore_for_file: unused_local_variable, unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:chat_app_cli/models/messageModel.dart';
import 'package:chat_app_cli/models/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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

  //firebase messaging push notification

  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  //for getting firebase messaging token

  static Future<void> getFirebaseMessagingToken() async {
    await messaging.requestPermission();
    await messaging.getToken().then((t) {
      if (t != null) {
        me.pushToken = t;
        log('Push token :$t');
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Got a message whilst in the foreground!');
      log('Message data: ${message.data}');

      if (message.notification != null) {
        log('Message also contained a notification: ${message.notification}');
      }
    });
  }

  // for send push notification

  static Future<void> sendPushNotification(
      ChatUser chatUser, String msg) async {
    try {
      final body = {
        'to': chatUser.pushToken,
        'notification': {
          'title': chatUser.name,
          'body': msg,
          "android_channel_id": "chats",
        },
        "data": {
          "some_data": "User ID :${me.id}",
        },
      };

      var response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'key=AAAAoj_4mI0:APA91bEAGkUMmjz2ORj3DRTlv4bjhIo8J5X-wn0FMUFcUoAmbFqQuYg0O1lxKqgQVlbAcoM3HWKHDfqsVOcKiayqBVC4AW_JVKI4FuzIYL4IxdEZ2Ch93PCII2xDy1PO1fgKMtjE4YHV',
        },
        body: jsonEncode(body),
      );
      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');
    } catch (e) {
      log("error :$e");
    }
  }

  // for adding an chat user for our conversation
  static Future<bool> addChatUser(String email) async {
    final data = await fireStore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    log('data: ${data.docs}');

    if (data.docs.isNotEmpty && data.docs.first.id != user.uid) {
      //user exists

      log('user exists: ${data.docs.first.data()}');

      fireStore
          .collection('users')
          .doc(user.uid)
          .collection('my_users')
          .doc(data.docs.first.id)
          .set({});

      return true;
    } else {
      //user doesn't exists
      return false;
    }
  }

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

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(
      List<String> userIds) {
    log('\nUserIds: $userIds');

    return fireStore
        .collection('users')
        .where('id',
            whereIn: userIds.isEmpty
                ? ['']
                : userIds) //because empty list throws an error
        // .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

//self information

  static Future<void> selfInfo() async {
    await fireStore.collection('users').doc(user.uid).get().then((value) async {
      if (value.exists) {
        me = ChatUser.fromJson(value.data()!);
        await getFirebaseMessagingToken();
        //user status to active
        API.updateActiveStatus(true);
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
        .orderBy('send', descending: true)
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
    await ref.doc(time).set(message.toJson()).then((value) =>
        sendPushNotification(chatUser, type == Type.text ? msg : 'image'));
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
  // chat image oru particular person send cheyyan veendiyulla function (firebase lek)

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

  // for getting specific user info
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      ChatUser chatUser) {
    return fireStore
        .collection('users')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

  // update online or last active status of user
  static Future<void> updateActiveStatus(bool isOnline) async {
    fireStore.collection('users').doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token': me.pushToken,
    });
  }

  //delete message function

  static Future<void> deleteMessage(MessageUser message) async {
    fireStore
        .collection('chats/${getConversationID(message.toId)}/messages/')
        .doc(message.send)
        .delete();

    //message is image then delete current storage area
    if (message.type == Type.image) {
      storage.refFromURL(message.msg).delete();
    }
  }

  //update message function

  static Future<void> updateMessage(
      MessageUser message, String updatedMsg) async {
    await fireStore
        .collection('chats/${getConversationID(message.toId)}/messages/')
        .doc(message.send)
        .update({'msg': updatedMsg});
  }

  // for getting id's of known users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersId() {
    return fireStore
        .collection('users')
        .doc(user.uid)
        .collection('my_users')
        .snapshots();
  }

  // for adding an user to my user when first message is send
  static Future<void> sendFirstMessage(
      ChatUser chatUser, String msg, Type type) async {
    await fireStore
        .collection('users')
        .doc(chatUser.id)
        .collection('my_users')
        .doc(user.uid)
        .set({}).then((value) => sendMessage(chatUser, msg, type));
  }
}
