import 'package:flutter/material.dart';
import 'package:ruyi_booking/screens/admins/edit_bookings/edit_booking_detail/desktop_edit_booking_detail_screen.dart';
import 'package:ruyi_booking/screens/admins/edit_bookings/edit_booking_detail/mobile_edit_booking_detail_screen.dart';
import 'package:ruyi_booking/widgets/cores/responsive_layout.dart';

class EditBookingDetial extends StatelessWidget {
  final Map<String, dynamic> bookingData;
  const EditBookingDetial({super.key, required this.bookingData});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: MobileEditBookingDetailScreen(bookingData: bookingData),
      deskstopBody: DesktopEditBookingDetailScreen(bookingData: bookingData),
    );
  }
}
