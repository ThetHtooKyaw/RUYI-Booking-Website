import 'package:flutter/material.dart';
import 'package:ruyi_booking/screens/bookingSummary_screen/deskstopBookingSummaryScreen.dart';
import 'package:ruyi_booking/screens/bookingSummary_screen/mobileBookingSummaryScreen.dart';
import 'package:ruyi_booking/widgets/cores/responsive_layout.dart';

class BookingSummaryScreen extends StatelessWidget {
  const BookingSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
        mobileBody: MobileBookingSummaryScreen(),
        deskstopBody: DeskstopBookingSummaryScreen(),
      ),
    );
  }
}
