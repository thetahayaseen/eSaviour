// lib/screens/manage_hospitals_screen.dart

import 'package:flutter/material.dart';
import '../../models/hospital.dart';
import '../../services/hospital_service.dart';

class ManageHospitalsScreen extends StatefulWidget {
  const ManageHospitalsScreen({super.key});

  @override
  _ManageHospitalsScreenState createState() => _ManageHospitalsScreenState();
}

class _ManageHospitalsScreenState extends State<ManageHospitalsScreen> {
  final hospitalService = HospitalService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();

  void _showHospitalDialog({Hospital? hospital}) {
    if (hospital != null) {
      nameController.text = hospital.name;
      addressController.text = hospital.address;
      zipCodeController.text = hospital.zipCode;
    } else {
      nameController.clear();
      addressController.clear();
      zipCodeController.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(hospital == null ? 'Add Hospital' : 'Edit Hospital'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Hospital Name'),
            ),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            TextField(
              controller: zipCodeController,
              decoration: const InputDecoration(labelText: 'ZIP Code'),
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
              if (hospital == null) {
                await hospitalService.createHospital(Hospital(
                  id: '', // Firestore will assign ID
                  name: nameController.text,
                  address: addressController.text,
                  zipCode: zipCodeController.text,
                ));
              } else {
                await hospitalService.updateHospital(Hospital(
                  id: hospital.id,
                  name: nameController.text,
                  address: addressController.text,
                  zipCode: zipCodeController.text,
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
        title: const Text('Manage Hospitals'),
      ),
      body: StreamBuilder<List<Hospital>>(
        stream: hospitalService.getHospitals(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final hospitals = snapshot.data!;
          return ListView.builder(
            itemCount: hospitals.length,
            itemBuilder: (context, index) {
              final hospital = hospitals[index];
              return ListTile(
                title: Text(hospital.name),
                subtitle: Text('${hospital.address}, ${hospital.zipCode}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _showHospitalDialog(hospital: hospital);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        hospitalService.deleteHospital(hospital.id);
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
        onPressed: () => _showHospitalDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
