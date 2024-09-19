import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_feedback.dart';

class UserFeedbackService {
  final CollectionReference _feedbackCollection =
      FirebaseFirestore.instance.collection('userFeedbacks');

  Future<void> createUserFeedback(UserFeedback userFeedback) async {
    try {
      await _feedbackCollection.add(userFeedback.toMap());
      print('User feedback added successfully.');
    } catch (e) {
      print('Error adding user feedback: $e');
    }
  }

  Stream<List<UserFeedback>> getUserFeedbacks() {
    return _feedbackCollection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => UserFeedback.fromDocument(
            doc as DocumentSnapshot<Map<String, dynamic>>))
        .toList());
  }

  Future<void> updateUserFeedback(UserFeedback userFeedback) async {
    try {
      await _feedbackCollection
          .doc(userFeedback.id)
          .update(userFeedback.toMap());
      print('User feedback updated successfully.');
    } catch (e) {
      print('Error updating user feedback: $e');
    }
  }

  Future<void> deleteUserFeedback(String id) async {
    try {
      await _feedbackCollection.doc(id).delete();
      print('User feedback deleted successfully.');
    } catch (e) {
      print('Error deleting user feedback: $e');
    }
  }
}
