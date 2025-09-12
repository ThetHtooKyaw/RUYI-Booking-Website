import 'package:flutter/material.dart';
import 'package:ruyi_booking/widgets/cores/responsive_layout.dart';

import 'desktop_edit_menu_options_screen.dart';
import 'mobile_edit_menu_options_screen.dart';

class EditMenuOptionsScreen extends StatelessWidget {
  final String menuName;
  final Map<String, dynamic> menuOption;
  const EditMenuOptionsScreen(
      {super.key, required this.menuName, required this.menuOption});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileBody: MobileEditMenuOptionsScreen(
          menuName: menuName,
          menuOption: menuOption,
        ),
        deskstopBody: DesktopEditMenuOptionsScreen(
          menuName: menuName,
          menuOption: menuOption,
        ));
  }
}
