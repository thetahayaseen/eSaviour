import 'package:cloud_firestore/cloud_firestore.dart';

class PlannedBooking {
  String id;
  String associatedHospitalId;
  String associatedAmbulanceTypeId;
  String? associatedAmbulanceId;
  String? associatedUserId;
  String patientName;
  String contactNumber;
  String address;
  String zipcode;
  String? pickupAddress;
  Timestamp? pickupDateTime;
  String? status;

  PlannedBooking({
    required this.id,
    required this.associatedHospitalId,
    required this.associatedAmbulanceTypeId,
    this.associatedAmbulanceId,
    this.associatedUserId,
    required this.patientName,
    required this.contactNumber,
    required this.address,
    required this.zipcode,
    this.pickupAddress,
    this.pickupDateTime,
    this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'associatedHospitalId': associatedHospitalId,
      'associatedAmbulanceTypeId': associatedAmbulanceTypeId,
      if (associatedAmbulanceId != null)
        'associatedAmbulanceId': associatedAmbulanceId,
      if (associatedUserId != null) 'associatedUserId': associatedUserId,
      'patientName': patientName,
      'contactNumber': contactNumber,
      'address': address,
      'zipcode': zipcode,
      if (pickupAddress != null) 'pickupAddress': pickupAddress,
      if (pickupDateTime != null) 'pickupDateTime': pickupDateTime,
      if (status != null) 'status': status,
    };
  }

  factory PlannedBooking.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PlannedBooking(
      id: doc.id,
      associatedHospitalId: data['associatedHospitalId'] ?? '',
      associatedAmbulanceTypeId: data['associatedAmbulanceTypeId'] ?? '',
      associatedAmbulanceId: data['associatedAmbulanceId'],
      associatedUserId: data['associatedUserId'],
      patientName: data['patientName'] ?? '',
      contactNumber: data['contactNumber'] ?? '',
      address: data['address'] ?? '',
      zipcode: data['zipcode'] ?? '',
      pickupAddress: data['pickupAddress'],
      pickupDateTime: data['pickupDateTime'],
      status: data['status'],
    );
  }
}
