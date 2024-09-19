// lib/screens/manage_drivers_screen.dart

import 'package:flutter/material.dart';
import '../../models/driver.dart';
import '../../services/driver_service.dart';

class ManageDriversScreen extends StatefulWidget {
  const ManageDriversScreen({super.key});

  @override
  _ManageDriversScreenState createState() => _ManageDriversScreenState();
}

class _ManageDriversScreenState extends State<ManageDriversScreen> {
  final driverService = DriverService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cnicController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController licenceController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool isAvailable = true;

  void _showDriverDialog({Driver? driver}) {
    if (driver != null) {
      nameController.text = driver.name;
      cnicController.text = driver.cnic;
      addressController.text = driver.address;
      licenceController.text = driver.licenceNumber;
      emailController.text = driver.email;
      isAvailable = driver.isAvailable;
    } else {
      nameController.clear();
      cnicController.clear();
      addressController.clear();
      licenceController.clear();
      emailController.clear();
      isAvailable = true;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(driver == null ? 'Add Driver' : 'Edit Driver'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Driver Name'),
            ),
            TextField(
              controller: cnicController,
              decoration: const InputDecoration(labelText: 'CNIC'),
            ),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            TextField(
              controller: licenceController,
              decoration: const InputDecoration(labelText: 'Licence Number'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            CheckboxListTile(
              title: const Text('Available'),
              value: isAvailable,
              onChanged: (value) {
                setState(() {
                  isAvailable = value!;
                });
              },
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
              if (driver == null) {
                await driverService.createDriver(Driver(
                  id: '', // Firestore will assign ID
                  name: nameController.text,
                  cnic: cnicController.text,
                  address: addressController.text,
                  licenceNumber: licenceController.text,
                  email: emailController.text,
                  isAvailable: isAvailable,
                ));
              } else {
                await driverService.updateDriver(Driver(
                  id: driver.id,
                  name: nameController.text,
                  cnic: cnicController.text,
                  address: addressController.text,
                  licenceNumber: licenceController.text,
                  email: emailController.text,
                  isAvailable: isAvailable,
                ));
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
        title: const Text('Manage Drivers'),
      ),
      body: StreamBuilder<List<Driver>>(
        stream: driverService.getDrivers(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final drivers = snapshot.data!;
          return ListView.builder(
            itemCount: drivers.length,
            itemBuilder: (context, index) {
              final driver = drivers[index];
              return ListTile(
                title: Text(driver.name),
                subtitle: Text('CNIC: ${driver.cnic}, Email: ${driver.email}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _showDriverDialog(driver: driver);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        driverService.deleteDriver(driver.id);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDriverDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
