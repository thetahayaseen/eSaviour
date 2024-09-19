// lib/models/ambulance.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Ambulance {
  final String id;
  final String registrationId;
  final String numberPlate;
  final String ambulanceTypeId; // Reference to AmbulanceType
  final String hospitalId; // Reference to Hospital
  final String driverId; // Reference to Driver

  Ambulance({
    required this.id,
    required this.registrationId,
    required this.numberPlate,
    required this.ambulanceTypeId,
    required this.hospitalId,
    required this.driverId,
  });

  factory Ambulance.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Ambulance(
      id: doc.id,
      registrationId: data['registrationId'] ?? '',
      numberPlate: data['numberPlate'] ?? '',
      ambulanceTypeId: data['ambulanceTypeId'] ?? '',
      hospitalId: data['hospitalId'] ?? '',
      driverId: data['driverId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'registrationId': registrationId,
      'numberPlate': numberPlate,
      'ambulanceTypeId': ambulanceTypeId,
      'hospitalId': hospitalId,
      'driverId': driverId,
    };
  }
}
