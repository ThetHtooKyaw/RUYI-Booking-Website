import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/admin_auth_provider.dart';
import 'package:ruyi_booking/screens/admin_screens/desktopAdmin_screens/desktop_booking_list_screen.dart';
import 'package:ruyi_booking/screens/admin_screens/desktopAdmin_screens/desktop_calendar_edit_screen.dart';
import 'package:ruyi_booking/screens/admin_screens/desktopAdmin_screens/desktop_edit_admin_screen.dart';
import 'package:ruyi_booking/services/admin_auth_service.dart';
import 'package:ruyi_booking/services/booking_service.dart';
import 'package:ruyi_booking/utils/colors.dart';
import 'package:ruyi_booking/widgets/cores/language_picker.dart';
import 'package:ruyi_booking/widgets/cores/main_logo.dart';

class DesktopAdminScreen extends StatefulWidget {
  const DesktopAdminScreen({super.key});

  @override
  State<DesktopAdminScreen> createState() => _DesktopAdminScreenState();
}

class _DesktopAdminScreenState extends State<DesktopAdminScreen> {
  BookingService bookingService = BookingService();
  AdminAuthService adminAuthService = AdminAuthService();
  Widget _currentBody = Container();
  String _title = 'manage_booking_title'.tr();

  void _onMenuItemChange(int index) {
    setState(() {
      switch (index) {
        case 0:
          _title = 'edit_title'.tr();
          Provider.of<AdminAuthProvider>(context, listen: false)
              .loadAdminData();
          _currentBody = const DesktopEditAdminScreen();
          break;
        case 1:
          _title = 'manage_booking_title'.tr();
          bookingService.refershBookingList();
          _currentBody = const DesktopBookingListScreen();
          break;
        case 2:
          _title = 'edit_calendar_title'.tr();
          _currentBody = const DesktopCalendarEditScreen();
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    bookingService.refershBookingList();
    _currentBody = const DesktopBookingListScreen();
    _title = 'manage_booking_title'.tr();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 85,
        leadingWidth: 200,
        leading: const Padding(
          padding: EdgeInsets.only(left: 40),
          child: Center(
            child: MainLogo(height: 55, width: 55),
          ),
        ),
        title: Text(
          _title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 30,
                color: AppColors.appAccent,
                fontFamily: 'PlayfairDisplay',
              ),
        ),
        actions: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: LanguagePicker(offset: 45, color: AppColors.appAccent),
          ),
          _buildMenuButton(context),
        ],
      ),
      body: _currentBody,
    );
  }

  Padding _buildMenuButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 40),
      child: PopupMenuButton<int>(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.appAccent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Menu',
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontSize: 18, color: AppColors.appBackground),
          ),
        ),
        onSelected: (value) {
          if (value == 0) {
            _onMenuItemChange(0);
          } else if (value == 1) {
            _onMenuItemChange(1);
          } else if (value == 2) {
            _onMenuItemChange(2);
          } else if (value == 3) {
            adminAuthService.adminSignOut();
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 0,
            child: Center(
              child: Text(
                'edit'.tr(),
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: AppColors.appBackground),
              ),
            ),
          ),
          PopupMenuItem(
            value: 1,
            child: Center(
              child: Text(
                'manage_booking'.tr(),
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: AppColors.appBackground),
              ),
            ),
          ),
          PopupMenuItem(
            value: 2,
            child: Center(
              child: Text(
                'edit_calendar'.tr(),
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: AppColors.appBackground),
              ),
            ),
          ),
          PopupMenuItem(
            value: 3,
            child: Center(
              child: Text(
                'logout'.tr(),
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: AppColors.appBackground),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
