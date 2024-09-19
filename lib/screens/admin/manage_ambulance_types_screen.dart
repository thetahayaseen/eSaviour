// lib/screens/manage_ambulance_types_screen.dart

import 'package:flutter/material.dart';
import '../../models/ambulance_type.dart';
import '../../services/ambulance_type_service.dart';

class ManageAmbulanceTypesScreen extends StatefulWidget {
  const ManageAmbulanceTypesScreen({super.key});

  @override
  _ManageAmbulanceTypesScreenState createState() =>
      _ManageAmbulanceTypesScreenState();
}

class _ManageAmbulanceTypesScreenState
    extends State<ManageAmbulanceTypesScreen> {
  final ambulanceTypeService = AmbulanceTypeService();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController chargesController = TextEditingController();
  final TextEditingController equipmentController = TextEditingController();
  List<String> equipments = [];

  void _showAmbulanceTypeDialog({AmbulanceType? ambulanceType}) {
    if (ambulanceType != null) {
      titleController.text = ambulanceType.title;
      chargesController.text = ambulanceType.charges.toString();
      equipments = List.from(ambulanceType.equipments);
    } else {
      titleController.clear();
      chargesController.clear();
      equipments.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(ambulanceType == null
            ? 'Add Ambulance Type'
            : 'Edit Ambulance Type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration:
                  const InputDecoration(labelText: 'Ambulance Type Title'),
            ),
            TextField(
              controller: chargesController,
              decoration: const InputDecoration(labelText: 'Charges'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: equipmentController,
              decoration: const InputDecoration(labelText: 'Equipment'),
              onSubmitted: (value) {
                setState(() {
                  equipments.add(value);
                  equipmentController.clear();
                });
              },
            ),
            Wrap(
              children: equipments.map((e) => Chip(label: Text(e))).toList(),
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
              if (ambulanceType == null) {
                await ambulanceTypeService.createAmbulanceType(AmbulanceType(
                  id: '',
                  title: titleController.text,
                  charges: double.parse(chargesController.text),
                  equipments: equipments,
                ));
              } else {
                await ambulanceTypeService.updateAmbulanceType(AmbulanceType(
                  id: ambulanceType.id,
                  title: titleController.text,
                  charges: double.parse(chargesController.text),
                  equipments: equipments,
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
        title: const Text('Manage Ambulance Types'),
      ),
      body: StreamBuilder<List<AmbulanceType>>(
        stream: ambulanceTypeService.getAmbulanceTypes(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final ambulanceTypes = snapshot.data!;
          return ListView.builder(
            itemCount: ambulanceTypes.length,
            itemBuilder: (context, index) {
              final ambulanceType = ambulanceTypes[index];
              return ListTile(
                title: Text(ambulanceType.title),
                subtitle:
                    Text('Charges: \$${ambulanceType.charges.toString()}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _showAmbulanceTypeDialog(ambulanceType: ambulanceType);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        ambulanceTypeService
                            .deleteAmbulanceType(ambulanceType.id);
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
        onPressed: () => _showAmbulanceTypeDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
