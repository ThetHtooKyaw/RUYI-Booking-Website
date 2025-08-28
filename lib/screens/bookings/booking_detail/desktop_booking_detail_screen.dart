import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/booking_data_provider.dart';
import 'package:ruyi_booking/providers/menu_data_provider.dart';
import 'package:ruyi_booking/screens/bookings/booking_detail/widgets/booking_summary_title.dart';
import 'package:ruyi_booking/widgets/extras/custom_buttons.dart';
import 'package:ruyi_booking/widgets/cores/desktop_app_bar.dart';

class DesktopBookingDetailScreen extends StatefulWidget {
  const DesktopBookingDetailScreen({super.key});

  @override
  State<DesktopBookingDetailScreen> createState() =>
      _DesktopBookingDetailScreenState();
}

class _DesktopBookingDetailScreenState
    extends State<DesktopBookingDetailScreen> {
  @override
  Widget build(BuildContext context) {
    var bookingData = Provider.of<BookingDataProvider>(context);
    var menuData = Provider.of<MenuDataProvider>(context);

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
                    value: bookingData.nameController.text),
                _buildDivider(),
                BookingSummaryTitle(
                    icon: 'assets/icons/phone.png',
                    label: 'phNo'.tr(),
                    value: bookingData.phNoController.text),
                _buildDivider(),
                BookingSummaryTitle(
                    icon: 'assets/icons/email.png',
                    label: 'email'.tr(),
                    value: bookingData.emailController.text),
                _buildDivider(),
                BookingSummaryTitle(
                    icon: 'assets/icons/calendar.png',
                    label: 'selectedDate'.tr(),
                    value: bookingData.formattedDate),
                _buildDivider(),
                BookingSummaryTitle(
                    icon: 'assets/icons/time.png',
                    label: 'hour'.tr(),
                    value: bookingData.selectedTime),
                _buildDivider(),
                BookingSummaryTitle(
                    icon: 'assets/icons/group.png',
                    label: 'number_people'.tr(),
                    value: '${bookingData.guestCounter} people(s)'),
                _buildDivider(),
                BookingSummaryTitle(
                    icon: 'assets/icons/table_type.png',
                    label: 'roomType'.tr(),
                    value: bookingData.selectedRoomtype ?? ''),
                _buildDivider(),
                BookingSummaryTitle(
                    icon: 'assets/icons/tag.png',
                    label: 'roomName'.tr(),
                    value: bookingData.selectedRoomName ?? ''),
                _buildDivider(),
                BookingSummaryTitle(
                    icon: 'assets/icons/cart.png',
                    label: 'pre_order'.tr(),
                    value: '${menuData.cartedItems.length} item(s)'),
                const SizedBox(height: 40),
                ButtonUtils.forwardButton(
                  context: context,
                  width: double.infinity,
                  label: 'confirm'.tr(),
                  fontSize: 17,
                  onPressed: () =>
                      bookingData.savingBooking(context, menuData.cartedItems),
                ),
                const SizedBox(height: 10),
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
