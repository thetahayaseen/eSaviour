// lib/services/planned_booking_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/planned_booking.dart';

class PlannedBookingService {
  final CollectionReference _plannedBookingCollection =
      FirebaseFirestore.instance.collection('plannedBookings');

  // Create PlannedBooking
  Future<void> createPlannedBooking(PlannedBooking plannedBooking) async {
    try {
      await _plannedBookingCollection.add(plannedBooking.toMap());
      print('Planned booking added successfully.');
    } catch (e) {
      print('Error adding planned booking: $e');
    }
  }

  // Read all PlannedBookings with optional filters
  Stream<List<PlannedBooking>> getPlannedBookings({
    String? associatedUserId,
    String? zipcode,
    String? associatedHospitalId,
  }) {
    Query query = _plannedBookingCollection;

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

    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => PlannedBooking.fromDocument(doc)).toList());
  }

  // Get all unique zip codes
  Future<List<String>> getAllUniqueZipCodesForPlannedBookings() async {
    try {
      Set<String> uniqueZipCodes = <String>{};
      var snapshot = await _plannedBookingCollection.get();

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

  // Update PlannedBooking
  Future<void> updatePlannedBooking(PlannedBooking plannedBooking) async {
    try {
      await _plannedBookingCollection
          .doc(plannedBooking.id)
          .update(plannedBooking.toMap());
      print('Planned booking updated successfully.');
    } catch (e) {
      print('Error updating planned booking: $e');
    }
  }

  // Delete PlannedBooking
  Future<void> deletePlannedBooking(String id) async {
    try {
      await _plannedBookingCollection.doc(id).delete();
      print('Planned booking deleted successfully.');
    } catch (e) {
      print('Error deleting planned booking: $e');
    }
  }
}
