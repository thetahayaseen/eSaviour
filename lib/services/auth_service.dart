// lib/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Register a new user with email and password
  Future<User?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      print('Attempting to register user: $email');
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      print('Registration successful: ${cred.user?.uid}');
      return cred.user;
    } on FirebaseAuthException catch (e) {
      print('Registration Error: ${e.message}');
      throw Exception(e.message ?? "An error occurred during registration.");
    } catch (e) {
      print('Unexpected Error: ${e.toString()}');
      throw Exception("An unexpected error occurred during registration.");
    }
  }

  // Sign in a user with email and password
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      print('Attempting to sign in user: $email');
      UserCredential cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      print('Sign in successful: ${cred.user?.uid}');
      return cred.user;
    } on FirebaseAuthException catch (e) {
      print('Sign in Error: ${e.message}');
      throw Exception(e.message ?? "An error occurred during sign in.");
    } catch (e) {
      print('Unexpected Error: ${e.toString()}');
      throw Exception("An unexpected error occurred during sign in.");
    }
  }

  // Sign out the currently signed-in user
  Future<void> signOut() async {
    try {
      print('Signing out user.');
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      print('Sign out Error: ${e.message}');
      throw Exception(e.message ?? "An error occurred during sign out.");
    } catch (e) {
      print('Unexpected Error: ${e.toString()}');
      throw Exception("An unexpected error occurred during sign out.");
    }
  }

  // Stream to listen to authentication state changes
  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  // Update the user's email after reauthentication
  Future<void> updateEmail(String newEmail, String currentPassword) async {
    try {
      User? user = _auth.currentUser;
      if (user != null && user.email != null) {
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(credential);
        await user.updateEmail(newEmail);
        print('Email updated successfully.');
      } else {
        throw Exception("No user is signed in.");
      }
    } on FirebaseAuthException catch (e) {
      print('Error updating email: ${e.message}');
      throw Exception(
          e.message ?? "An error occurred while updating the email.");
    } catch (e) {
      print('Unexpected Error: ${e.toString()}');
      throw Exception("An unexpected error occurred while updating the email.");
    }
  }

  // Update the user's password after reauthentication
  Future<void> updatePassword(
      String newPassword, String currentPassword) async {
    try {
      User? user = _auth.currentUser;
      if (user != null && user.email != null) {
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPassword);
        print('Password updated successfully.');
      } else {
        throw Exception("No user is signed in.");
      }
    } on FirebaseAuthException catch (e) {
      print('Error updating password: ${e.message}');
      throw Exception(
          e.message ?? "An error occurred while updating the password.");
    } catch (e) {
      print('Unexpected Error: ${e.toString()}');
      throw Exception(
          "An unexpected error occurred while updating the password.");
    }
  }

  // Reauthenticate the user to perform sensitive operations
  Future<void> reauthenticateUser(String password) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );
        await user.reauthenticateWithCredential(credential);
        print('User reauthenticated successfully.');
      } else {
        throw Exception("No user is signed in.");
      }
    } on FirebaseAuthException catch (e) {
      print('Error reauthenticating user: ${e.message}');
      throw Exception(
          e.message ?? "An error occurred while reauthenticating the user.");
    } catch (e) {
      print('Unexpected Error: ${e.toString()}');
      throw Exception(
          "An unexpected error occurred while reauthenticating the user.");
    }
  }

  // Delete the user's account after reauthentication
  Future<void> deleteUser(String password) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );
        await user.reauthenticateWithCredential(credential);
        await user.delete();
        print('User deleted successfully.');
      } else {
        throw Exception("No user is signed in.");
      }
    } on FirebaseAuthException catch (e) {
      print('Error deleting user: ${e.message}');
      throw Exception(
          e.message ?? "An error occurred while deleting the user.");
    } catch (e) {
      print('Unexpected Error: ${e.toString()}');
      throw Exception("An unexpected error occurred while deleting the user.");
    }
  }
}
