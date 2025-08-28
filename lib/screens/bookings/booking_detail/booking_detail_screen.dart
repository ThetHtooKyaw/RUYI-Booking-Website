import 'package:flutter/material.dart';
import 'package:ruyi_booking/screens/bookings/booking_detail/desktop_booking_detail_screen.dart';
import 'package:ruyi_booking/screens/bookings/booking_detail/mobile_booking_detail_screen.dart';
import 'package:ruyi_booking/widgets/cores/responsive_layout.dart';

class BookingDetailScreen extends StatelessWidget {
  const BookingDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
        mobileBody: MobileBookingDetailScreen(),
        deskstopBody: DesktopBookingDetailScreen(),
      ),
    );
  }
}
