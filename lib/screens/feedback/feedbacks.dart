import 'package:flutter/material.dart';
import 'package:esaviourapp/models/user_feedback.dart';
import 'package:esaviourapp/services/user_feedback_service.dart';

class FeedbacksScreen extends StatefulWidget {
  const FeedbacksScreen({super.key});

  @override
  _FeedbacksScreenState createState() => _FeedbacksScreenState();
}

class _FeedbacksScreenState extends State<FeedbacksScreen> {
  final _userFeedbackService = UserFeedbackService();
  late Stream<List<UserFeedback>> _userFeedbacksStream;

  @override
  void initState() {
    super.initState();
    _userFeedbacksStream = _userFeedbackService.getUserFeedbacks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Feedback'),
      ),
      body: StreamBuilder<List<UserFeedback>>(
        stream: _userFeedbacksStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final feedbacks = snapshot.data!;

          if (feedbacks.isEmpty) {
            return const Center(child: Text('No feedback available.'));
          }

          return ListView.builder(
            itemCount: feedbacks.length,
            itemBuilder: (context, index) {
              final feedback = feedbacks[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(feedback.message),
                  subtitle: Text('Email: ${feedback.email}'),
                  // Optionally, include userId or other details
                ),
              );
            },
          );
        },
      ),
    );
  }
}
