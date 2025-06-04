import 'package:flutter/material.dart';
import 'package:ruyi_booking/screens/admin_screens/admin_menu_list_screens/desktop_admin_menu_list_screen.dart';
import 'package:ruyi_booking/screens/admin_screens/admin_menu_list_screens/mobile_admin_menu_list_screen.dart';
import 'package:ruyi_booking/widgets/cores/responsive_layout.dart';

class AdminMenuListScreen extends StatelessWidget {
  final Map<String, dynamic> bookingData;
  const AdminMenuListScreen({super.key, required this.bookingData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: MobileAdminMenuListScreen(bookingData: bookingData),
        deskstopBody: DesktopAdminMenuListScreen(bookingData: bookingData),
      ),
    );
  }
}
