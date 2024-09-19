// lib/services/ambulance_type_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ambulance_type.dart';

class AmbulanceTypeService {
  final CollectionReference _ambulanceTypeCollection =
  FirebaseFirestore.instance.collection('ambulanceTypes');

  // Create AmbulanceType
  Future<void> createAmbulanceType(AmbulanceType ambulanceType) async {
    final DocumentReference docRef = _ambulanceTypeCollection.doc(); // Create a new document reference with an auto-generated ID

    ambulanceType = AmbulanceType(
      id: docRef.id, // Assign the generated ID to the ambulanceType model
      title: ambulanceType.title,
      equipments: ambulanceType.equipments,
      charges: ambulanceType.charges,
    );

    await docRef.set(ambulanceType.toMap()); // Save the ambulance type data to Firestore
  }

  // Read all AmbulanceTypes
  Stream<List<AmbulanceType>> getAmbulanceTypes() {
    return _ambulanceTypeCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => AmbulanceType.fromDocument(doc)).toList());
  }

  // Update AmbulanceType
  Future<void> updateAmbulanceType(AmbulanceType ambulanceType) async {
    await _ambulanceTypeCollection.doc(ambulanceType.id).update(ambulanceType.toMap());
  }

  // Delete AmbulanceType
  Future<void> deleteAmbulanceType(String id) async {
    await _ambulanceTypeCollection.doc(id).delete();
  }
}
