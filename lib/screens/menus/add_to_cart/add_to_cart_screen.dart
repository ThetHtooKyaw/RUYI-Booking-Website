import 'package:flutter/material.dart';
import 'package:ruyi_booking/screens/menus/add_to_cart/mobile_add_to_cart_screen.dart';
import 'package:ruyi_booking/screens/menus/menu/desktop_menu_screens/desktop_menu_screen.dart';
import 'package:ruyi_booking/widgets/cores/responsive_layout.dart';

class AddToCartScreen extends StatelessWidget {
  const AddToCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobileBody: MobileAddToCartScreen(),
      deskstopBody: DesktopMenuScreen(),
    );
  }
}
