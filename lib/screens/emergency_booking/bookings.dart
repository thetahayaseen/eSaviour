import 'package:esaviourapp/models/emergency_booking.dart';
import 'package:esaviourapp/services/emergency_booking_service.dart';
import 'package:flutter/material.dart';

class EmergencyBookings extends StatelessWidget {
  final EmergencyBookingService _emergencyBookingService =
      EmergencyBookingService();

  EmergencyBookings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Bookings'),
      ),
      body: StreamBuilder<List<EmergencyBooking>>(
        stream: _emergencyBookingService.getEmergencyBookings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final bookings = snapshot.data ?? [];

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return ListTile(
                title: Text('Patient: ${booking.patientName}'),
                subtitle: Text('Contact: ${booking.contactNumber}'),
                trailing: Text('Hospital ID: ${booking.associatedHospitalId}'),
              );
            },
          );
        },
      ),
    );
  }
}
