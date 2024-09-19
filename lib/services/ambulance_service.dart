// lib/services/ambulance_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ambulance.dart';

class AmbulanceService {
  final CollectionReference _ambulanceCollection =
  FirebaseFirestore.instance.collection('ambulances');

  // Create Ambulance
  Future<void> createAmbulance(Ambulance ambulance) async {
    final DocumentReference docRef = _ambulanceCollection.doc(); // Create a new document reference with an auto-generated ID

    ambulance = Ambulance(
      id: docRef.id, // Assign the generated ID to the ambulance model
      registrationId: ambulance.registrationId,
      numberPlate: ambulance.numberPlate,
      ambulanceTypeId: ambulance.ambulanceTypeId,
      hospitalId: ambulance.hospitalId,
      driverId: ambulance.driverId,
    );

    await docRef.set(ambulance.toMap()); // Save the ambulance data to Firestore
  }

  // Read all Ambulances
  Stream<List<Ambulance>> getAmbulances() {
    return _ambulanceCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Ambulance.fromDocument(doc)).toList());
  }

  // Update Ambulance
  Future<void> updateAmbulance(Ambulance ambulance) async {
    await _ambulanceCollection.doc(ambulance.id).update(ambulance.toMap());
  }

  // Delete Ambulance
  Future<void> deleteAmbulance(String id) async {
    await _ambulanceCollection.doc(id).delete();
  }
}
