import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/admin_auth_provider.dart';
import 'package:ruyi_booking/screens/admins/edit_admin_detail/mobile_edit_admin_detail_screen.dart';
import 'package:ruyi_booking/screens/admins/edit_bookings/edit_booking_list/mobile_edit_booking_list_screen.dart';
import 'package:ruyi_booking/screens/admins/edit_bookings/edit_calendar/mobile_edit_calendar_screen.dart';
import 'package:ruyi_booking/services/booking_service.dart';
import 'package:ruyi_booking/utils/constants.dart';
import 'package:ruyi_booking/widgets/cores/language_picker.dart';
import 'package:ruyi_booking/widgets/cores/main_logo.dart';
import 'package:ruyi_booking/widgets/extras/custom_divider.dart';

import '../edit_menus/edit_menu_list/edit_menu_list_screen.dart';

class MobileAdminScreen extends StatefulWidget {
  const MobileAdminScreen({super.key});

  @override
  State<MobileAdminScreen> createState() => _MobileAdminScreenState();
}

class _MobileAdminScreenState extends State<MobileAdminScreen> {
  BookingService bookingService = BookingService();
  Widget _currentBody = Container();
  String _title = 'manage_booking_title'.tr();

  void _onDrawerItemChange(int index) {
    setState(() {
      switch (index) {
        case 0:
          _title = 'edit_title'.tr();
          Provider.of<AdminAuthProvider>(context, listen: false)
              .loadAdminData();
          _currentBody = const MobileEditAdminDetailScreen();
          break;
        case 1:
          _title = 'manage_booking_title'.tr();
          bookingService.refershBookingList();
          _currentBody = const MobileEditBookingListScreen();
          break;
        case 2:
          _title = 'edit_calendar_title'.tr();
          _currentBody = const MobileEditCalendarScreen();
          break;
        case 3:
          _title = 'edit_menu_title'.tr();
          _currentBody = const EditMenuListScreen();
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    bookingService.refershBookingList();
    _currentBody = const MobileEditBookingListScreen();
    _title = 'manage_booking_title'.tr();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          _title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.appAccent,
                fontFamily: 'PlayfairDisplay',
              ),
        ),
        actions: const [
          MainLogo(height: 45, width: 45, isClickable: true),
          SizedBox(width: 12),
        ],
      ),
      body: _currentBody,
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const SizedBox(height: 40),
          const LanguagePicker(
            offset: -35,
            color: Colors.black,
          ),
          const SizedBox(height: 40),
          _buildDrawerTab(context, 'edit'.tr(), () {
            _onDrawerItemChange(0);
            Navigator.pop(context);
          }),
          const CustomDivider(),
          _buildDrawerTab(context, 'manage_booking'.tr(), () {
            _onDrawerItemChange(1);
            Navigator.pop(context);
          }),
          const CustomDivider(),
          _buildDrawerTab(context, 'edit_calendar'.tr(), () {
            _onDrawerItemChange(2);
            Navigator.pop(context);
          }),
          const CustomDivider(),
          _buildDrawerTab(context, 'edit_menu'.tr(), () {
            _onDrawerItemChange(3);
            Navigator.pop(context);
          }),
          const CustomDivider(),
          _buildDrawerTab(context, 'logout'.tr(), () {
            Provider.of<AdminAuthProvider>(context, listen: false)
                .adminSignOut(context);
          }),
          const CustomDivider(),
        ],
      ),
    );
  }

  InkWell _buildDrawerTab(
      BuildContext context, String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
