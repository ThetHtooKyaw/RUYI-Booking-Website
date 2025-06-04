import 'package:flutter/material.dart';
import 'package:ruyi_booking/screens/booking_summary_screen/desktop_booking_summary_screen.dart';
import 'package:ruyi_booking/screens/booking_summary_screen/mobile_booking_summary_screen.dart';
import 'package:ruyi_booking/widgets/cores/responsive_layout.dart';

class BookingSummaryScreen extends StatelessWidget {
  const BookingSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
        mobileBody: MobileBookingSummaryScreen(),
        deskstopBody: DesktopBookingSummaryScreen(),
      ),
    );
  }
}
