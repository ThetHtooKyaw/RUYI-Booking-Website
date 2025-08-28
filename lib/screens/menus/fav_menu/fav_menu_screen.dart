import 'package:flutter/material.dart';
import 'package:ruyi_booking/screens/menus/fav_menu/mobile_fav_menu_screen.dart';
import 'package:ruyi_booking/screens/menus/view_menu/deskstop_view_menu_screens/desktop_view_menu_screen.dart';
import 'package:ruyi_booking/widgets/cores/responsive_layout.dart';

class FavMenuScreen extends StatelessWidget {
  const FavMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobileBody: MobileFavMenuScreen(),
      deskstopBody: DesktopViewMenuScreen(),
    );
  }
}
