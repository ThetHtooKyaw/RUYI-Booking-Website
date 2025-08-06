import 'package:flutter/material.dart';
import 'package:ruyi_booking/screens/view_menu_screens/deskstop_menu_view/desktop_view_menu_screen.dart';
import 'package:ruyi_booking/screens/view_menu_screens/mobile_menu_view/mobile_view_menu_screen.dart';
import 'package:ruyi_booking/widgets/cores/responsive_layout.dart';

class ViewMenuScreen extends StatelessWidget {
  const ViewMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
        mobileBody: MobileViewMenuScreen(),
        deskstopBody: DesktopViewMenuScreen(),
      ),
    );
  }
}
