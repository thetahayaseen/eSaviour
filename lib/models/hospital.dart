// lib/models/hospital.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Hospital {
  final String id;
  final String name;
  final String address;
  final String zipCode;

  Hospital({
    required this.id,
    required this.name,
    required this.address,
    required this.zipCode,
  });

  // Factory constructor to create a Hospital from Firestore document
  factory Hospital.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Hospital(
      id: doc.id,
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      zipCode: data['zipCode'] ?? '',
    );
  }

  // Convert Hospital object to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'zipCode': zipCode,
    };
  }
}
