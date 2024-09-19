import 'package:cloud_firestore/cloud_firestore.dart';

class UserFeedback {
  final String id;
  final String email;
  final String message;
  final String userId;

  UserFeedback({
    required this.id,
    required this.email,
    required this.message,
    required this.userId,
  });

  factory UserFeedback.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return UserFeedback(
      id: doc.id,
      email: data?['email'] ?? '',
      message: data?['message'] ?? '',
      userId: data?['userId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'message': message,
      'userId': userId,
    };
  }
}
