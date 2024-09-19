import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:esaviourapp/models/user_feedback.dart';
import 'package:esaviourapp/services/user_feedback_service.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _messageController = TextEditingController();
  final _userFeedbackService = UserFeedbackService();
  final _auth = FirebaseAuth.instance;
  late String _userEmail;

  @override
  void initState() {
    super.initState();
    _userEmail = _auth.currentUser?.email ?? '';
  }

  Future<void> _submitFeedback() async {
    final email = _userEmail;
    final message = _messageController.text.trim();

    if (message.isEmpty) {
      // Show an error message if the message field is empty
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Please enter a message.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final userFeedback = UserFeedback(
      id: '', // Firestore will automatically generate an ID
      email: email,
      message: message,
      userId: _auth.currentUser?.uid ?? '', // Use the current user's UID
    );

    try {
      await _userFeedbackService.createUserFeedback(userFeedback);
      _messageController.clear();
      // Show a success message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Your feedback has been submitted.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      // Show an error message if submission fails
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('There was an error submitting your feedback.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Feedback'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Message',
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _submitFeedback,
              child: const Text('Submit Feedback'),
            ),
          ],
        ),
      ),
    );
  }
}
