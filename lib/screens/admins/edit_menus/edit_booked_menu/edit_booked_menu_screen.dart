import 'package:flutter/material.dart';
import 'package:ruyi_booking/screens/admins/edit_menus/edit_booked_menu/desktop_edit_booked_menu_screen.dart';
import 'package:ruyi_booking/screens/menus/add_to_cart/mobile_add_to_cart_screen.dart';
import 'package:ruyi_booking/widgets/cores/responsive_layout.dart';

class EditBookedMenuScreen extends StatelessWidget {
  final Map<String, dynamic> bookingData;
  const EditBookedMenuScreen({super.key, required this.bookingData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: MobileAddToCartScreen(
          type: MobileAddToCartScreenType.adminSite,
          bookingData: bookingData,
        ),
        deskstopBody: DesktopEditBookedMenuScreen(
          bookingData: bookingData,
        ),
      ),
    );
  }
}
