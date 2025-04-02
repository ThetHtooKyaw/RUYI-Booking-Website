import 'package:flutter/material.dart';
import 'package:ruyi_booking/screens/admin_screens/deskstopAdmin_screens/deskstopAdminScreen.dart';
import 'package:ruyi_booking/screens/admin_screens/mobileAdmin_screens/mobileAdminScreen.dart';
import 'package:ruyi_booking/widgets/cores/responsive_layout.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
        mobileBody: MobileAdminScreen(),
        deskstopBody: DeskstopAdminScreen(),
      ),
    );
  }
}
