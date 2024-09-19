// lib/screens/profile_management_screen.dart

import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class ProfileManagementScreen extends StatefulWidget {
  const ProfileManagementScreen({super.key});

  @override
  _ProfileManagementScreenState createState() =>
      _ProfileManagementScreenState();
}

class _ProfileManagementScreenState extends State<ProfileManagementScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController deletePasswordController =
      TextEditingController();

  bool _passwordVisible = false;
  bool _deletePasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentEmail();
  }

  void _loadCurrentEmail() async {
    final user = _authService.user;
    user.listen((user) {
      if (user != null) {
        emailController.text = user.email ?? '';
      }
    });
  }

  void _showUpdateDialog({String? action}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(action == 'email'
            ? 'Update Email'
            : action == 'password'
                ? 'Update Password'
                : 'Delete Account'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (action == 'email')
              Column(
                children: [
                  TextField(
                    controller: currentPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Current Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                    obscureText: !_passwordVisible,
                  ),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'New Email'),
                  ),
                ],
              ),
            if (action == 'password')
              Column(
                children: [
                  TextField(
                    controller: currentPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Current Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                    obscureText: !_passwordVisible,
                  ),
                  TextField(
                    controller: newPasswordController,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                    obscureText: !_passwordVisible,
                  ),
                  TextField(
                    controller: confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm New Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                    obscureText: !_passwordVisible,
                  ),
                ],
              ),
            if (action == 'delete')
              TextField(
                controller: deletePasswordController,
                decoration: InputDecoration(
                  labelText: 'Password for Account Deletion',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _deletePasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _deletePasswordVisible = !_deletePasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_deletePasswordVisible,
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (action == 'email') {
                await _authService.updateEmail(
                  emailController.text,
                  currentPasswordController.text,
                );
              } else if (action == 'password') {
                if (newPasswordController.text ==
                    confirmPasswordController.text) {
                  await _authService.updatePassword(
                    newPasswordController.text,
                    currentPasswordController.text,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Passwords do not match.')),
                  );
                }
              } else if (action == 'delete') {
                await _authService.deleteUser(deletePasswordController.text);
                Navigator.of(context).popUntil(
                    (route) => route.isFirst); // Navigate to the first route
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () => _showUpdateDialog(action: 'email'),
              child: const Text('Update Email'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _showUpdateDialog(action: 'password'),
              child: const Text('Update Password'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _showUpdateDialog(action: 'delete'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete Account'),
            ),
          ],
        ),
      ),
    );
  }
}
