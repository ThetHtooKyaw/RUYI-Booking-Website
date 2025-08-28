import 'package:flutter/material.dart';
import 'package:ruyi_booking/screens/menus/menu/desktop_menu_screens/desktop_menu_screen.dart';
import 'package:ruyi_booking/screens/menus/menu/mobile_menu_screen.dart';
import 'package:ruyi_booking/widgets/cores/responsive_layout.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
        mobileBody: MobileMenuScreen(),
        deskstopBody: DesktopMenuScreen(),
      ),
    );
  }
}
