// lib/models/driver.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Driver {
  final String id;
  final String name;
  final String cnic;
  final String address;
  final String licenceNumber;
  final String email;
  final bool isAvailable;

  Driver({
    required this.id,
    required this.name,
    required this.cnic,
    required this.address,
    required this.licenceNumber,
    required this.email,
    required this.isAvailable,
  });

  factory Driver.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Driver(
      id: doc.id,
      name: data['name'] ?? '',
      cnic: data['cnic'] ?? '',
      address: data['address'] ?? '',
      licenceNumber: data['licenceNumber'] ?? '',
      email: data['email'] ?? '',
      isAvailable: data['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'cnic': cnic,
      'address': address,
      'licenceNumber': licenceNumber,
      'email': email,
      'isAvailable': isAvailable,
    };
  }
}
