import 'package:flutter/material.dart';
import '../../models/ambulance.dart';
import '../../models/ambulance_type.dart';
import '../../models/hospital.dart';
import '../../models/driver.dart';
import '../../services/ambulance_service.dart';
import '../../services/ambulance_type_service.dart';
import '../../services/hospital_service.dart';
import '../../services/driver_service.dart';

class ManageAmbulancesScreen extends StatefulWidget {
  const ManageAmbulancesScreen({super.key});

  @override
  _ManageAmbulancesScreenState createState() => _ManageAmbulancesScreenState();
}

class _ManageAmbulancesScreenState extends State<ManageAmbulancesScreen> {
  final ambulanceService = AmbulanceService();
  final ambulanceTypeService = AmbulanceTypeService();
  final hospitalService = HospitalService();
  final driverService = DriverService();

  final TextEditingController registrationIdController =
      TextEditingController();
  final TextEditingController numberPlateController = TextEditingController();

  String? selectedAmbulanceTypeId;
  String? selectedHospitalId;
  String? selectedDriverId;

  void _showAmbulanceDialog({Ambulance? ambulance}) {
    if (ambulance != null) {
      registrationIdController.text = ambulance.registrationId;
      numberPlateController.text = ambulance.numberPlate;
      selectedAmbulanceTypeId = ambulance.ambulanceTypeId;
      selectedHospitalId = ambulance.hospitalId;
      selectedDriverId = ambulance.driverId;
    } else {
      registrationIdController.clear();
      numberPlateController.clear();
      selectedAmbulanceTypeId = null;
      selectedHospitalId = null;
      selectedDriverId = null;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(ambulance == null ? 'Add Ambulance' : 'Edit Ambulance'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: registrationIdController,
              decoration: const InputDecoration(labelText: 'Registration ID'),
            ),
            TextField(
              controller: numberPlateController,
              decoration: const InputDecoration(labelText: 'Number Plate'),
            ),
            StreamBuilder<List<AmbulanceType>>(
              stream: ambulanceTypeService.getAmbulanceTypes(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                final ambulanceTypes = snapshot.data!;
                return DropdownButtonFormField<String>(
                  value: selectedAmbulanceTypeId,
                  items: ambulanceTypes
                      .map((type) => DropdownMenuItem<String>(
                            value: type.id,
                            child: Text(type.title),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedAmbulanceTypeId = value;
                    });
                  },
                  decoration:
                      const InputDecoration(labelText: 'Ambulance Type'),
                );
              },
            ),
            StreamBuilder<List<Hospital>>(
              stream: hospitalService.getHospitals(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                final hospitals = snapshot.data!;
                return DropdownButtonFormField<String>(
                  value: selectedHospitalId,
                  items: hospitals
                      .map((hospital) => DropdownMenuItem<String>(
                            value: hospital.id,
                            child: Text(hospital.name),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedHospitalId = value;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Hospital'),
                );
              },
            ),
            StreamBuilder<List<Driver>>(
              stream: driverService.getDrivers(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                final drivers = snapshot.data!;
                return DropdownButtonFormField<String>(
                  value: selectedDriverId,
                  items: drivers
                      .map((driver) => DropdownMenuItem<String>(
                            value: driver.id,
                            child: Text(driver.name),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedDriverId = value;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Driver'),
                );
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
              if (ambulance == null) {
                await ambulanceService.createAmbulance(Ambulance(
                  id: '',
                  registrationId: registrationIdController.text,
                  numberPlate: numberPlateController.text,
                  ambulanceTypeId: selectedAmbulanceTypeId!,
                  hospitalId: selectedHospitalId!,
                  driverId: selectedDriverId!,
                ));
              } else {
                await ambulanceService.updateAmbulance(Ambulance(
                  id: ambulance.id,
                  registrationId: registrationIdController.text,
                  numberPlate: numberPlateController.text,
                  ambulanceTypeId: selectedAmbulanceTypeId!,
                  hospitalId: selectedHospitalId!,
                  driverId: selectedDriverId!,
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
        title: const Text('Manage Ambulances'),
      ),
      body: StreamBuilder<List<Ambulance>>(
        stream: ambulanceService.getAmbulances(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final ambulances = snapshot.data!;
          return ListView.builder(
            itemCount: ambulances.length,
            itemBuilder: (context, index) {
              final ambulance = ambulances[index];
              return ListTile(
                title: Text('Registration ID: ${ambulance.registrationId}'),
                subtitle: Text('Number Plate: ${ambulance.numberPlate}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _showAmbulanceDialog(ambulance: ambulance);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        ambulanceService.deleteAmbulance(ambulance.id);
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
        onPressed: () => _showAmbulanceDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
