// lib/home_screen.dart

import 'package:flutter/material.dart';
import 'services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('HomeScreen build called.');
    final AuthService _authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          // Logout Button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              print('Logout button pressed.');
              await _authService.signOut();
              print('User signed out.');
              // After sign out, the StreamBuilder in main.dart will navigate to LoginScreen
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Welcome!',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
