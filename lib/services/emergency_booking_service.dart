// lib/services/emergency_booking_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/emergency_booking.dart';

class EmergencyBookingService {
  final CollectionReference _emergencyBookingCollection =
      FirebaseFirestore.instance.collection('emergencyBookings');

  // Create EmergencyBooking
  Future<void> createEmergencyBooking(EmergencyBooking emergencyBooking) async {
    try {
      await _emergencyBookingCollection.add(emergencyBooking.toMap());
      print('Emergency booking added successfully.');
    } catch (e) {
      print('Error adding emergency booking: $e');
    }
  }

  // Read all EmergencyBookings with optional filters
  Stream<List<EmergencyBooking>> getEmergencyBookings({
    String? associatedUserId,
    String? zipcode,
    String? associatedHospitalId,
  }) {
    Query query = _emergencyBookingCollection;

    if (associatedUserId != null) {
      query = query.where("associatedUserId", isEqualTo: associatedUserId);
    }
    if (zipcode != null) {
      query = query.where("zipcode", isEqualTo: zipcode);
    }
    if (associatedHospitalId != null) {
      query =
          query.where("associatedHospitalId", isEqualTo: associatedHospitalId);
    }

    return query.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => EmergencyBooking.fromDocument(doc))
        .toList());
  }

  // Get all unique zip codes
  Future<List<String>> getAllUniqueZipCodesForEmergencyBookings() async {
    try {
      Set<String> uniqueZipCodes = <String>{};
      var snapshot = await _emergencyBookingCollection.get();

      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>?;
        var zipCode = data != null && data.containsKey('zipcode')
            ? data['zipcode'] as String?
            : null;
        if (zipCode != null) {
          uniqueZipCodes.add(zipCode);
        }
      }

      return uniqueZipCodes.toList();
    } catch (e) {
      print('Error getting unique zip codes: $e');
      return [];
    }
  }

  // Update EmergencyBooking
  Future<void> updateEmergencyBooking(EmergencyBooking emergencyBooking) async {
    try {
      await _emergencyBookingCollection
          .doc(emergencyBooking.id)
          .update(emergencyBooking.toMap());
      print('Emergency booking updated successfully.');
    } catch (e) {
      print('Error updating emergency booking: $e');
    }
  }

  // Delete EmergencyBooking
  Future<void> deleteEmergencyBooking(String id) async {
    try {
      await _emergencyBookingCollection.doc(id).delete();
      print('Emergency booking deleted successfully.');
    } catch (e) {
      print('Error deleting emergency booking: $e');
    }
  }
}
