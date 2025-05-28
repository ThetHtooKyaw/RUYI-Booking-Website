import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/admin_auth_provider.dart';
import 'package:ruyi_booking/screens/admin_screens/mobileAdmin_screens/mobile_booking_list_screen.dart';
import 'package:ruyi_booking/screens/admin_screens/mobileAdmin_screens/mobile_calendar_edit_screen.dart';
import 'package:ruyi_booking/screens/admin_screens/mobileAdmin_screens/mobile_edit_admin_screen.dart';
import 'package:ruyi_booking/services/booking_service.dart';
import 'package:ruyi_booking/utils/colors.dart';
import 'package:ruyi_booking/widgets/cores/language_picker.dart';
import 'package:ruyi_booking/widgets/cores/main_logo.dart';
import 'package:ruyi_booking/widgets/extras/custom_divider.dart';

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
          _currentBody = const MobileEditAdminScreen();
          break;
        case 1:
          _title = 'manage_booking_title'.tr();
          bookingService.refershBookingList();
          _currentBody = const MobileBookingListScreen();
          break;
        case 2:
          _title = 'edit_calendar_title'.tr();
          _currentBody = const MobileCalendarEditScreen();
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    bookingService.refershBookingList();
    _currentBody = const MobileBookingListScreen();
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
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 18,
                color: AppColors.appAccent,
                fontFamily: 'PlayfairDisplay',
              ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: MainLogo(height: 45, width: 45),
          ),
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
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
