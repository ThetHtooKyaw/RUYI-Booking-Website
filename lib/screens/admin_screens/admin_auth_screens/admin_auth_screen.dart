import 'package:flutter/material.dart';
import 'package:ruyi_booking/screens/admin_screens/admin_auth_screens/desktop_admin_auth_screens/desktop_auth_screen.dart';
import 'package:ruyi_booking/screens/admin_screens/admin_auth_screens/mobile_admin_auth_screens/mobile_auth_screen.dart';
import 'package:ruyi_booking/widgets/cores/responsive_layout.dart';

class AdminAuthScreen extends StatelessWidget {
  const AdminAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
        mobileBody: MobileAuthScreen(),
        deskstopBody: DesktopAuthScreen(),
      ),
    );
  }
}
