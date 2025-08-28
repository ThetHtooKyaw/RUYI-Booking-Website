import 'package:flutter/material.dart';
import 'package:ruyi_booking/screens/admins/admin/desktop_admin_screen.dart';
import 'package:ruyi_booking/screens/admins/admin/mobile_admin_screen.dart';
import 'package:ruyi_booking/widgets/cores/responsive_layout.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
        mobileBody: MobileAdminScreen(),
        deskstopBody: DesktopAdminScreen(),
      ),
    );
  }
}
