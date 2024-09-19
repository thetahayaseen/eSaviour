import 'package:esaviourapp/models/planned_booking.dart';
import 'package:esaviourapp/services/planned_booking_service.dart';
import 'package:flutter/material.dart';

class PlannedBookings extends StatelessWidget {
  final PlannedBookingService _plannedBookingService = PlannedBookingService();

  PlannedBookings({super.key}); // Adjust if different service

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planned Bookings'),
      ),
      body: StreamBuilder<List<PlannedBooking>>(
        stream: _plannedBookingService
            .getPlannedBookings(), // Adjust method if different
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
