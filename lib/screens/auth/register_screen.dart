// lib/register_screen.dart

import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'login_screen.dart'; // Ensure this is at the top

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    print('RegisterScreen build called.');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Email Field
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (val) =>
                          val != null && val.isEmpty ? 'Enter an email' : null,
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        });
                      },
                    ),
                    const SizedBox(height: 16.0),
                    // Password Field
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (val) => val != null && val.length < 6
                          ? 'Enter a password 6+ chars long'
                          : null,
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                      },
                    ),
                    const SizedBox(height: 16.0),
                    // Register Button
                    ElevatedButton(
                      onPressed: () async {
                        print('Register button pressed.');
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            loading = true;
                            error = '';
                          });
                          try {
                            await _authService.registerWithEmailAndPassword(
                                email, password);
                            print(
                                'Registration successful, navigating to Home.');
                            // No need to navigate manually; StreamBuilder will handle it
                          } catch (e) {
                            print('Registration failed: $e');
                            setState(() {
                              error = e.toString();
                              loading = false;
                            });
                          }
                        }
                      },
                      child: const Text('Register'),
                    ),
                    const SizedBox(height: 12.0),
                    // Error Message
                    Text(
                      error,
                      style: const TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                    const SizedBox(height: 12.0),
                    // Navigate to Login
                    TextButton(
                      onPressed: () {
                        print('Navigating to LoginScreen.');
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      },
                      child: const Text('Already have an account? Login'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
