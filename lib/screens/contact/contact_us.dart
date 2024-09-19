import 'package:esaviourapp/models/user_query.dart';
import 'package:esaviourapp/services/user_query_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _messageController = TextEditingController();
  final _userQueryService = UserQueryService();
  final _auth = FirebaseAuth.instance;

  late Stream<List<UserQuery>> _userQueriesStream;
  String? _currentUserEmail;

  @override
  void initState() {
    super.initState();
    final user = _auth.currentUser;
    if (user != null) {
      _currentUserEmail = user.email;
      _userQueriesStream = _userQueryService.getUserQueries(userId: user.uid);
    }
  }

  void _submitQuery() async {
    final user = _auth.currentUser;

    final userQuery = UserQuery(
      id: '',
      name: _nameController.text,
      email: _currentUserEmail ?? _emailController.text,
      contactNumber: _contactNumberController.text,
      message: _messageController.text,
      reply: null,
      userId: user?.uid ?? '',
    );

    await _userQueryService.createUserQuery(userQuery);

    _nameController.clear();
    _emailController.clear();
    _contactNumberController.clear();
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  if (_currentUserEmail == null)
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                  TextField(
                    controller: _contactNumberController,
                    decoration:
                        const InputDecoration(labelText: 'Contact Number'),
                  ),
                  TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(labelText: 'Message'),
                    maxLines: 4,
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _submitQuery,
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
            if (_currentUserEmail != null)
              const Divider(height: 40.0, thickness: 2.0),
            if (_currentUserEmail != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: StreamBuilder<List<UserQuery>>(
                  stream: _userQueriesStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final queries = snapshot.data!;

                    if (queries.isEmpty) {
                      return const Center(child: Text('No queries found.'));
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: queries.length,
                      itemBuilder: (context, index) {
                        final query = queries[index];
                        return ListTile(
                          title: Text(query.message),
                          subtitle:
                              Text('Reply: ${query.reply ?? 'No reply yet'}'),
                        );
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
