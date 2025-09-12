import 'package:flutter/material.dart';
import 'package:ruyi_booking/widgets/cores/responsive_layout.dart';
import 'desktop_edit_menu_list_screen.dart';
import 'mobile_edit_menu_list_screen.dart';

class EditMenuListScreen extends StatelessWidget {
  const EditMenuListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobileBody: MobileEditMenuListScreen(),
      deskstopBody: DesktopEditMenuListScreen(),
    );
  }
}
