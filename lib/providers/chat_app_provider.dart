import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:udemy_course/models/user_model.dart';

import '../helper/firebase_services/auth_services.dart';

class ChatAppProvider with ChangeNotifier {
  ///
  final Auth auth = Auth.instance;

  //
  final String profileImg =
      "https://scontent.fdkr7-1.fna.fbcdn.net/v/t39.30808-6/494634544_677457065178328_6644007253082550614_n.jpg?_nc_cat=105&ccb=1-7&_nc_sid=6ee11a&_nc_ohc=WuloXO5fqmQQ7kNvwGedvK2&_nc_oc=Adn6ciScyS0FOjOCHfs3-kgZ8mCYmYwqYgR-APydr8onv8ZG_kj6wus5eNI7GTMg8qA&_nc_zt=23&_nc_ht=scontent.fdkr7-1.fna&_nc_gid=61bHhJs81ysb7ERpfLKj1Q&oh=00_AfRB7K7LDdvqeW_Et-Bfgq-I2yHAlF_qu-zR25lER2uJ9g&oe=688D09F9";

  String _username = "";

  String get username => _username;

  final List<UserModel> _users = [];

  List<UserModel> get users => [..._users];

  Future<void> getUsers() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final user = auth.currentUser;

    if (user == null) {
      _users.clear();
      notifyListeners();
      return;
    }

    try {
      QuerySnapshot snapshot = await firestore.collection('users').get();
      _users.clear();
      //

      // for (var doc in snapshot.docs) {
      //   if (doc.get('email') == auth.currentUser!.email) continue;
      //   _users.add(UserModel.fromJson(doc.data() as Map<String, dynamic>));
      // }

      //
      snapshot.docs
          .where((doc) => doc.get('email') != user.email)
          .map(
            (doc) => _users.add(
              UserModel.fromJson(doc.data() as Map<String, dynamic>),
            ),
          )
          .toList();
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> getUsername() async {
    final Auth auth = Auth.instance;
    final user = auth.auth.currentUser;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    if (user == null) {
      _username = "Unknown User";
      notifyListeners();
      return;
    }

    try {
      DocumentSnapshot snapshot = await firestore
          .collection('users')
          .doc(user.uid)
          .get();
      if (snapshot.exists) {
        _username = snapshot.get('userName');
        notifyListeners();
      } else {
        _username = "Unknown User";
      }
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> logOut(BuildContext context) async {
    //
    _messagesSubscription?.cancel();
    _messages.clear();
    notifyListeners();

    try {
      await auth.signOut().whenComplete(() {
        if (context.mounted) {
          Navigator.of(
            context,
          ).pushReplacementNamed('/authGate');
        }
      });
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  /// Send message
  final msgController = TextEditingController();

  //
  String _uniqueChatRoomId(String userId, String otherUserId) {
    final List<String> ids = [userId, otherUserId];
    ids.sort();
    return ids.join('_');
  }

  Future<void> sendMessage(String otherUserId) async {
    final user = auth.auth.currentUser!;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      // Check if message is empty
      if (msgController.text.trim().isEmpty) return;

      //
      DocumentSnapshot userData = await firestore
          .collection('users')
          .doc(user.uid)
          .get();
      //
      final userName = userData.get('userName');
      final userEmail = userData.get('email');
      final message = msgController.text.trim();
      final newMessage = ChatModel(
        email: userEmail,
        message: message,
        sender: userName,
        createdAt: Timestamp.now(),
      );

      // Clear fields
      msgController.clear();

      //
      final String chatRoomId = _uniqueChatRoomId(user.uid, otherUserId);

      //
      await firestore
          .collection('chat_messages')
          .doc(chatRoomId)
          .collection('messages')
          .add(newMessage.toJson());

      //
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  /// Get messages
  List<ChatModel> _messages = [];

  List<ChatModel> get messages => [..._messages];

  StreamSubscription? _messagesSubscription;

  Future<void> getMessages(String otherUserId) async {
    final user = auth.auth.currentUser;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    if (user == null) {
      _messagesSubscription?.cancel();
      _messages.clear();
      notifyListeners();
      return;
    }

    try {
      //
      final String chatRoomId = _uniqueChatRoomId(user.uid, otherUserId);

      //
      _messagesSubscription = firestore
          .collection('chat_messages')
          .doc(chatRoomId)
          .collection("messages")
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen(
            (QuerySnapshot snapshot) {
              _messages.clear();
              _messages = snapshot.docs
                  .map(
                    (message) => ChatModel.fromJson(
                      message.data() as Map<String, dynamic>,
                    ),
                  )
                  .toList();
              notifyListeners();
            },
            onError: (e) {
              log("Error while getting messages from firestore: $e");
            },
          );

      //
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  /// Clear messages
  void clearMessages() {
    _messagesSubscription?.cancel();
    _messages.clear();
    notifyListeners();
  }


  /// Disposer
  @override
  void dispose() {
    msgController.dispose();
    _messagesSubscription?.cancel();
    super.dispose();
  }
}
