import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ruyi_booking/screens/admin_screens/admin_menu_list_screens/admin_menu_list_screen.dart';
import 'package:ruyi_booking/utils/colors.dart';
import 'package:ruyi_booking/widgets/extras/custom_buttons.dart';
import 'package:ruyi_booking/widgets/extras/mobile_app_bar.dart';

class MobileBookingDataScreen extends StatelessWidget {
  final Map<String, dynamic> bookingData;
  const MobileBookingDataScreen({super.key, required this.bookingData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MobileAppbar(title: 'booking_summary'.tr(), isClickable: false),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              _buildInfoCard(context, 'assets/icons/name.png', 'name'.tr(),
                  bookingData['username']),
              _buildDivider(),
              _buildInfoCard(context, 'assets/icons/phone.png', 'phNo'.tr(),
                  bookingData['ph_number']),
              _buildDivider(),
              _buildInfoCard(context, 'assets/icons/email.png', 'email'.tr(),
                  bookingData['email']),
              _buildDivider(),
              _buildInfoCard(context, 'assets/icons/calendar.png',
                  'selectedDate'.tr(), bookingData['date']),
              _buildDivider(),
              _buildInfoCard(context, 'assets/icons/time.png', 'hour'.tr(),
                  bookingData['time']),
              _buildDivider(),
              _buildInfoCard(context, 'assets/icons/group.png',
                  'number_people'.tr(), '${bookingData['guest']} people(s)'),
              _buildDivider(),
              _buildInfoCard(context, 'assets/icons/table_type.png',
                  'roomType'.tr(), bookingData['room_type']),
              _buildDivider(),
              _buildInfoCard(context, 'assets/icons/tag.png', 'roomName'.tr(),
                  bookingData['room_name']),
              _buildDivider(),
              menuWidget(context, bookingData),
              _buildDivider(),
              _buildInfoCard(context, 'assets/icons/detail.png', 'Status',
                  bookingData['status']),
              const SizedBox(height: 40),
              ButtonUtils.backwardButton(double.infinity, 'back'.tr(),
                  () => Navigator.pop(context), 17),
            ],
          ),
        ),
      ),
    );
  }

  Widget menuWidget(BuildContext context, Map<String, dynamic> bookingData) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Image.asset(
        'assets/icons/cart.png',
        height: 17,
        width: 17,
        color: Theme.of(context).iconTheme.color,
      ),
      title: Text(
        'pre_order'.tr(),
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      trailing: Stack(
        children: [
          ButtonUtils.forwardButton(150, 'menu'.tr(), () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AdminMenuListScreen(bookingData: bookingData);
            }));
          }, 13.5),
          bookingData['menu_list'].isNotEmpty
              ? Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.white,
                    child: Text(
                      bookingData['menu_list'].length.toString(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.appAccent,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      thickness: 2,
    );
  }

  Widget _buildInfoCard(
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
