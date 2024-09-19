// lib/main.dart
import 'package:esaviourapp/screens/auth/profile_management.dart';
import 'package:esaviourapp/screens/contact/contact_us.dart';
import 'package:esaviourapp/screens/contact/queries.dart';
import 'package:esaviourapp/screens/emergency_booking/book.dart';
import 'package:esaviourapp/screens/emergency_booking/bookings.dart';
import 'package:esaviourapp/screens/feedback/feedback.dart';
import 'package:esaviourapp/screens/feedback/feedbacks.dart';
import 'package:esaviourapp/screens/planned_booking/book.dart';
import 'package:esaviourapp/screens/planned_booking/bookings.dart';

import 'screens/admin/admin_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully.');
  } catch (e) {
    print('Firebase initialization error: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();

    return MaterialApp(
      title: 'Flutter Firebase Auth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder<User?>(
        stream: _authService.user,
        builder: (context, snapshot) {
          print('StreamBuilder Connection State: ${snapshot.connectionState}');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            print('StreamBuilder Error: ${snapshot.error}');
            return Scaffold(
              body: Center(child: Text('An error occurred: ${snapshot.error}')),
            );
          } else if (snapshot.hasData) {
            print('User is signed in: ${snapshot.data?.email}');
            // Navigate all logged-in users to AdminDashboard for now
            return const AdminDashboard();
          } else {
            print('User is not signed in.');
            return const LoginScreen();
          }
        },
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) =>
            const AdminDashboard(), // Temporary route to admin dashboard
        '/admin': (context) => const AdminDashboard(),
        '/profile': (context) => const ProfileManagementScreen(),
        '/contact': (context) => const ContactUsScreen(),
        '/queries': (context) => const QueriesScreen(),
        '/feedback': (context) => const FeedbackScreen(),
        '/feedbacks': (context) => const FeedbacksScreen(),
        '/bookWP': (context) => const CreatePlannedBookingScreen(),
        '/bookDTE': (context) => CreateEmergencyBookingScreen(),
        '/bookWPs': (context) => PlannedBookings(),
        '/bookDTEs': (context) => EmergencyBookings(),
      },
    );
  }
}
