import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ruyi_booking/screens/admins/edit_bookings/edit_booking_detail/widgets/menu_button.dart';
import 'package:ruyi_booking/screens/bookings/booking_detail/widgets/booking_summary_title.dart';
import 'package:ruyi_booking/widgets/extras/custom_buttons.dart';
import 'package:ruyi_booking/widgets/cores/desktop_app_bar.dart';

class DesktopEditBookingDetailScreen extends StatelessWidget {
  final Map<String, dynamic> bookingData;
  const DesktopEditBookingDetailScreen({super.key, required this.bookingData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DesktopAppBar(title: 'booking_summary'.tr()),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.35,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                BookingSummaryTitle(
                    icon: 'assets/icons/name.png',
                    label: 'name'.tr(),
                    value: bookingData['username']),
                _buildDivider(),
                BookingSummaryTitle(
                    icon: 'assets/icons/phone.png',
                    label: 'phNo'.tr(),
                    value: bookingData['ph_number']),
                _buildDivider(),
                BookingSummaryTitle(
                    icon: 'assets/icons/email.png',
                    label: 'email'.tr(),
                    value: bookingData['email']),
                _buildDivider(),
                BookingSummaryTitle(
                    icon: 'assets/icons/calendar.png',
                    label: 'selectedDate'.tr(),
                    value: bookingData['date']),
                _buildDivider(),
                BookingSummaryTitle(
                    icon: 'assets/icons/time.png',
                    label: 'hour'.tr(),
                    value: bookingData['time']),
                _buildDivider(),
                BookingSummaryTitle(
                    icon: 'assets/icons/group.png',
                    label: 'number_people'.tr(),
                    value: '${bookingData['guest']} people(s)'),
                _buildDivider(),
                BookingSummaryTitle(
                    icon: 'assets/icons/table_type.png',
                    label: 'roomType'.tr(),
                    value: bookingData['room_type']),
                _buildDivider(),
                BookingSummaryTitle(
                    icon: 'assets/icons/tag.png',
                    label: 'roomName'.tr(),
                    value: bookingData['room_name']),
                _buildDivider(),
                MenuButton(bookingData: bookingData),
                _buildDivider(),
                BookingSummaryTitle(
                    icon: 'assets/icons/detail.png',
                    label: 'Status',
                    value: bookingData['status']),
                const SizedBox(height: 40),
                ButtonUtils.backwardButton(
                  context: context,
                  width: double.infinity,
                  label: 'back'.tr(),
                  fontSize: 17,
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      thickness: 2,
    );
  }
}
