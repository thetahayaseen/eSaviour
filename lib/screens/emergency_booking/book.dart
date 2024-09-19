import 'package:esaviourapp/models/emergency_booking.dart';
import 'package:esaviourapp/services/emergency_booking_service.dart';
import 'package:flutter/material.dart';

class CreateEmergencyBookingScreen extends StatefulWidget {
  @override
  _CreateEmergencyBookingScreenState createState() =>
      _CreateEmergencyBookingScreenState();
}

class _CreateEmergencyBookingScreenState
    extends State<CreateEmergencyBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emergencyBookingService = EmergencyBookingService();

  String _associatedHospitalId = '';
  String _associatedAmbulanceTypeId = '';
  String? _associatedAmbulanceId;
  String? _associatedUserId;
  String _patientName = '';
  String _contactNumber = '';
  String _address = '';
  String _zipcode = '';
  double? _latitude;
  double? _longitude;

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      try {
        final emergencyBooking = EmergencyBooking(
          id: '', // Firestore will generate the ID
          associatedHospitalId: _associatedHospitalId,
          associatedAmbulanceTypeId: _associatedAmbulanceTypeId,
          associatedAmbulanceId: _associatedAmbulanceId,
          associatedUserId: _associatedUserId,
          patientName: _patientName,
          contactNumber: _contactNumber,
          address: _address,
          zipcode: _zipcode,
          bookingLocation: (_latitude != null && _longitude != null)
              ? BookingLocation(lattitude: _latitude!, longitude: _longitude!)
              : null,
        );

        await _emergencyBookingService.createEmergencyBooking(emergencyBooking);
        Navigator.of(context).pop(); // Go back to the previous screen
      } catch (e) {
        // Handle error if necessary
        // For example: print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Emergency Booking'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Associated Hospital ID'),
                onSaved: (value) => _associatedHospitalId = value ?? '',
                validator: (value) =>
                    value!.isEmpty ? 'Please enter hospital ID' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Associated Ambulance Type ID'),
                onSaved: (value) => _associatedAmbulanceTypeId = value ?? '',
                validator: (value) =>
                    value!.isEmpty ? 'Please enter ambulance type ID' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Associated Ambulance ID (Optional)'),
                onSaved: (value) => _associatedAmbulanceId = value,
              ),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Associated User ID (Optional)'),
                onSaved: (value) => _associatedUserId = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Patient Name'),
                onSaved: (value) => _patientName = value ?? '',
                validator: (value) =>
                    value!.isEmpty ? 'Please enter patient name' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Contact Number'),
                onSaved: (value) => _contactNumber = value ?? '',
                validator: (value) =>
                    value!.isEmpty ? 'Please enter contact number' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Address'),
                onSaved: (value) => _address = value ?? '',
                validator: (value) =>
                    value!.isEmpty ? 'Please enter address' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Zipcode'),
                onSaved: (value) => _zipcode = value ?? '',
                validator: (value) =>
                    value!.isEmpty ? 'Please enter zipcode' : null,
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Latitude (Optional)'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onSaved: (value) =>
                    _latitude = value != null ? double.tryParse(value) : null,
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Longitude (Optional)'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onSaved: (value) =>
                    _longitude = value != null ? double.tryParse(value) : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Create Booking'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
