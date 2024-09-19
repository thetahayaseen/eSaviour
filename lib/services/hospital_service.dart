// lib/services/hospital_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/hospital.dart';

class HospitalService {
  final CollectionReference _hospitalCollection =
  FirebaseFirestore.instance.collection('hospitals');

  // Create Hospital
  Future<void> createHospital(Hospital hospital) async {
    final DocumentReference docRef = _hospitalCollection.doc(); // Create a new document reference with an auto-generated ID

    hospital = Hospital(
      id: docRef.id, // Assign the generated ID to the hospital model
      name: hospital.name,
      address: hospital.address,
      zipCode: hospital.zipCode,
    );

    await docRef.set(hospital.toMap()); // Save the hospital data to Firestore
  }

  // Read all Hospitals
  Stream<List<Hospital>> getHospitals() {
    return _hospitalCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Hospital.fromDocument(doc)).toList());
  }

  // Update Hospital
  Future<void> updateHospital(Hospital hospital) async {
    await _hospitalCollection.doc(hospital.id).update(hospital.toMap());
  }

  // Delete Hospital
  Future<void> deleteHospital(String id) async {
    await _hospitalCollection.doc(id).delete();
  }
}
