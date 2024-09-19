// lib/services/driver_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/driver.dart';

class DriverService {
  final CollectionReference _driverCollection =
  FirebaseFirestore.instance.collection('drivers');

  // Create Driver
  Future<void> createDriver(Driver driver) async {
    try {
      await _driverCollection.add(driver.toMap());
      print('Driver added successfully.');
    } catch (e) {
      print('Error adding driver: $e');
    }
  }

  // Read all Drivers
  Stream<List<Driver>> getDrivers() {
    return _driverCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Driver.fromDocument(doc)).toList());
  }

  // Update Driver
  Future<void> updateDriver(Driver driver) async {
    try {
      await _driverCollection.doc(driver.id).update(driver.toMap());
      print('Driver updated successfully.');
    } catch (e) {
      print('Error updating driver: $e');
    }
  }

  // Delete Driver
  Future<void> deleteDriver(String id) async {
    try {
      await _driverCollection.doc(id).delete();
      print('Driver deleted successfully.');
    } catch (e) {
      print('Error deleting driver: $e');
    }
  }
}
