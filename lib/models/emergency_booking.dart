import 'package:cloud_firestore/cloud_firestore.dart';

class BookingLocation {
  double lattitude;
  double longitude;

  BookingLocation({
    required this.lattitude,
    required this.longitude,
  });
}

class EmergencyBooking {
  String id;
  String associatedHospitalId;
  String associatedAmbulanceTypeId;
  String? associatedAmbulanceId;
  String? associatedUserId;
  String patientName;
  String contactNumber;
  String address;
  String zipcode;
  BookingLocation? bookingLocation;

  EmergencyBooking({
    required this.id,
    required this.associatedHospitalId,
    required this.associatedAmbulanceTypeId,
    this.associatedAmbulanceId,
    this.associatedUserId,
    required this.patientName,
    required this.contactNumber,
    required this.address,
    required this.zipcode,
    this.bookingLocation,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {
      'associatedHospitalId': associatedHospitalId,
      'associatedAmbulanceTypeId': associatedAmbulanceTypeId,
      if (associatedAmbulanceId != null)
        'associatedAmbulanceId': associatedAmbulanceId,
      if (associatedUserId != null) 'associatedUserId': associatedUserId,
      'patientName': patientName,
      'contactNumber': contactNumber,
      'address': address,
      'zipcode': zipcode,
    };

    if (bookingLocation != null) {
      data['bookingLocation'] = {
        'lattitude': bookingLocation!.lattitude,
        'longitude': bookingLocation!.longitude,
      };
    }

    return data;
  }

  factory EmergencyBooking.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Ensure that 'bookingLocation' is cast correctly
    final bookingLocationData =
        data['bookingLocation'] as Map<String, dynamic>?;

    return EmergencyBooking(
      id: doc.id,
      associatedHospitalId: data['associatedHospitalId'] ?? '',
      associatedAmbulanceTypeId: data['associatedAmbulanceTypeId'] ?? '',
      associatedAmbulanceId: data['associatedAmbulanceId'],
      associatedUserId: data['associatedUserId'],
      patientName: data['patientName'] ?? '',
      contactNumber: data['contactNumber'] ?? '',
      address: data['address'] ?? '',
      zipcode: data['zipcode'] ?? '',
      bookingLocation: bookingLocationData != null
          ? BookingLocation(
              lattitude: bookingLocationData['lattitude'] as double,
              longitude: bookingLocationData['longitude'] as double,
            )
          : null,
    );
  }
}
