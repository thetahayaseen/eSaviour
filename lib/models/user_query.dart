import 'package:cloud_firestore/cloud_firestore.dart';

class UserQuery {
  String id;
  String name;
  String email;
  String contactNumber;
  String message;
  String? reply;
  String userId;

  UserQuery({
    required this.id,
    required this.name,
    required this.email,
    required this.contactNumber,
    required this.message,
    this.reply,
    required this.userId,
  });

  factory UserQuery.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return UserQuery(
      id: doc.id,
      name: data?['name'],
      email: data?['email'],
      contactNumber: data?['contactNumber'],
      message: data?['message'],
      reply: data?['reply'],
      userId: data?['userId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'contactNumber': contactNumber,
      'message': message,
      if (reply != null) 'reply': reply,
      'userId': userId,
    };
  }
}
