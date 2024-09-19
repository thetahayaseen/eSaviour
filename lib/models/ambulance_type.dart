// lib/models/ambulance_type.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class AmbulanceType {
  final String id;
  final String title;
  final List<String> equipments;
  final double charges;

  AmbulanceType({
    required this.id,
    required this.title,
    required this.equipments,
    required this.charges,
  });

  factory AmbulanceType.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AmbulanceType(
      id: doc.id,
      title: data['title'] ?? '',
      equipments: List<String>.from(data['equipments'] ?? []),
      charges: (data['charges'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'equipments': equipments,
      'charges': charges,
    };
  }
}
