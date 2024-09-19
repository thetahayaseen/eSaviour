import 'package:flutter/material.dart';
import 'package:esaviourapp/models/user_query.dart';
import 'package:esaviourapp/services/user_query_service.dart';

class QueriesScreen extends StatefulWidget {
  const QueriesScreen({super.key});

  @override
  _QueriesScreenState createState() => _QueriesScreenState();
}

class _QueriesScreenState extends State<QueriesScreen> {
  final _userQueryService = UserQueryService();
  late Stream<List<UserQuery>> _userQueriesStream;

  @override
  void initState() {
    super.initState();
    _userQueriesStream = _userQueryService.getUserQueries();
  }

  void _replyToQuery(UserQuery query) async {
    final replyController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reply to Query'),
        content: TextField(
          controller: replyController,
          decoration: const InputDecoration(labelText: 'Reply'),
          maxLines: 4,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final reply = replyController.text;
              if (reply.isNotEmpty) {
                await _userQueryService.update(UserQuery(
                  id: query.id,
                  name: query.name,
                  email: query.email,
                  contactNumber: query.contactNumber,
                  message: query.message,
                  reply: reply,
                  userId: query.userId,
                ));
                Navigator.pop(context);
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Queries'),
      ),
      body: StreamBuilder<List<UserQuery>>(
        stream: _userQueriesStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final queries = snapshot.data!;
          final unansweredQueries = queries
              .where((q) => q.reply == null || q.reply!.isEmpty)
              .toList();
          final answeredQueries = queries
              .where((q) => q.reply != null && q.reply!.isNotEmpty)
              .toList();

          return ListView(
            children: [
              if (unansweredQueries.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Unanswered Queries',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ...unansweredQueries.map((query) => ListTile(
                    title: Text(query.message),
                    subtitle: Text('Contact: ${query.contactNumber}'),
                    trailing: query.userId.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.reply),
                            onPressed: () => _replyToQuery(query),
                          )
                        : null,
                  )),
              if (answeredQueries.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Answered Queries',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ...answeredQueries.map((query) => ListTile(
                    title: Text(query.message),
                    subtitle: Text('Reply: ${query.reply}'),
                  )),
            ],
          );
        },
      ),
    );
  }
}
