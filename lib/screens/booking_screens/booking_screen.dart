import 'package:flutter/material.dart';
import 'package:ruyi_booking/screens/booking_screens/desktop_booking_screen.dart';
import 'package:ruyi_booking/screens/booking_screens/mobile_booking_screen.dart';
import 'package:ruyi_booking/widgets/cores/responsive_layout.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
        mobileBody: MobileBookingScreen(),
        deskstopBody: DesktopBookingScreen(),
      ),
    );
  }
}
