import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/booking_data_provider.dart';
import 'package:ruyi_booking/providers/menu_data_provider.dart';
import 'package:ruyi_booking/widgets/extras/custom_buttons.dart';
import 'package:ruyi_booking/widgets/extras/mobile_app_bar.dart';

class MobileBookingSummaryScreen extends StatefulWidget {
  const MobileBookingSummaryScreen({super.key});

  @override
  State<MobileBookingSummaryScreen> createState() =>
      _MobileBookingSummaryScreenState();
}

class _MobileBookingSummaryScreenState
    extends State<MobileBookingSummaryScreen> {
  @override
  Widget build(BuildContext context) {
    var bookingData = Provider.of<BookingDataProvider>(context);
    var menuData = Provider.of<MenuDataProvider>(context);

    return Scaffold(
      appBar: MobileAppbar(title: 'booking_summary'.tr()),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              _buildInfoCard(context, 'assets/icons/name.png', 'name'.tr(),
                  bookingData.nameController.text),
              _buildDivider(),
              _buildInfoCard(context, 'assets/icons/phone.png', 'phNo'.tr(),
                  bookingData.phNoController.text),
              _buildDivider(),
              _buildInfoCard(context, 'assets/icons/email.png', 'email'.tr(),
                  bookingData.emailController.text),
              _buildDivider(),
              _buildInfoCard(context, 'assets/icons/calendar.png',
                  'selectedDate'.tr(), bookingData.formattedDate),
              _buildDivider(),
              _buildInfoCard(context, 'assets/icons/time.png', 'hour'.tr(),
                  bookingData.selectedTime),
              _buildDivider(),
              _buildInfoCard(
                  context,
                  'assets/icons/group.png',
                  'number_people'.tr(),
                  '${bookingData.guestCounter} people(s)'),
              _buildDivider(),
              _buildInfoCard(context, 'assets/icons/table_type.png',
                  'roomType'.tr(), bookingData.selectedRoomtype ?? ''),
              _buildDivider(),
              _buildInfoCard(context, 'assets/icons/tag.png', 'roomName'.tr(),
                  bookingData.selectedRoomName ?? ''),
              _buildDivider(),
              _buildInfoCard(context, 'assets/icons/cart.png', 'pre_order'.tr(),
                  '${menuData.cartedItems.length} item(s)'),
              const SizedBox(height: 40),
              ButtonUtils.forwardButton(
                  context,
                  double.infinity,
                  'confirm'.tr(),
                  () =>
                      bookingData.savingBooking(context, menuData.cartedItems),
                  17),
              ButtonUtils.backwardButton(context, double.infinity, 'back'.tr(),
                  () => Navigator.pop(context), 17),
            ],
          ),
        ),
      ),
    );
  }

  Divider _buildDivider() {
    return const Divider(
      thickness: 2,
    );
  }

  ListTile _buildInfoCard(
      BuildContext context, String icon, String title, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Image.asset(
        icon,
        height: 17,
        width: 17,
        color: Theme.of(context).iconTheme.color,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      trailing: Text(
        value,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
