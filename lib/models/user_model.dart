import 'package:cloud_firestore/cloud_firestore.dart';

/// User model
class UserModel {
  UserModel({
    required this.email,
    required this.password,
    required this.uid,
    this.userName,
  });

  String email, password, uid;
  String? userName;

  //
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String? ?? "",
      email: json['email'] as String? ?? "",
      password: json['password'] as String? ?? "",
      userName: json['userName'] as String? ?? "",
    );
  }
}

/// Chat model

class ChatModel {
  ChatModel({
    required this.email,
    required this.message,
    required this.sender,
    required this.createdAt,
  });

  final String email;
  final String message;
  final String sender;
  final Timestamp createdAt;

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      email: json['email'],
      message: json['message'],
      sender: json['sender'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'message': message,
      'sender': sender,
      'createdAt': createdAt,
    };
  }
}
