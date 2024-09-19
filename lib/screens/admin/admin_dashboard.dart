// lib/screens/admin_dashboard.dart

import 'package:flutter/material.dart';
import 'manage_hospitals_screen.dart';
import 'manage_drivers_screen.dart';
import 'manage_ambulance_types_screen.dart';
import 'manage_ambulances_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ManageHospitalsScreen()),
                );
              },
              child: const Text('Manage Hospitals'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ManageDriversScreen()),
                );
              },
              child: const Text('Manage Drivers'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ManageAmbulanceTypesScreen()),
                );
              },
              child: const Text('Manage Ambulance Types'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ManageAmbulancesScreen()),
                );
              },
              child: const Text('Manage Ambulances'),
            ),
          ],
        ),
      ),
    );
  }
}
