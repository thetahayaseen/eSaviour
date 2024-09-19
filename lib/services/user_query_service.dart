import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_query.dart';

class UserQueryService {
  final CollectionReference _userQueryCollection =
      FirebaseFirestore.instance.collection('userQueries');

  Future<void> createUserQuery(UserQuery userQuery) async {
    try {
      await _userQueryCollection.add(userQuery.toMap());
      print('UserQuery added successfully.');
    } catch (e) {
      print('Error adding userQuery: $e');
    }
  }

  Stream<List<UserQuery>> getUserQueries({String? userId}) {
    return _userQueryCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserQuery.fromDocument(
                doc as DocumentSnapshot<Map<String, dynamic>>))
            .toList());
  }

  Future<void> update(UserQuery userQuery) async {
    try {
      await _userQueryCollection.doc(userQuery.id).update(userQuery.toMap());
      print('Reply to UserQuery updated successfully.');
    } catch (e) {
      print('Error replying to userQuery: $e');
    }
  }

  Future<void> deleteUserQuery(String id) async {
    try {
      await _userQueryCollection.doc(id).delete();
      print('UserQuery deleted successfully.');
    } catch (e) {
      print('Error deleting userQuery: $e');
    }
  }
}
