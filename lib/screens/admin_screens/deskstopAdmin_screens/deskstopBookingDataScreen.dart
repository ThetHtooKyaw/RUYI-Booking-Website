import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ruyi_booking/widgets/extras/custom_buttons.dart';
import 'package:ruyi_booking/widgets/extras/deskstopAppBar.dart';

class DeskstopBookingDataScreen extends StatelessWidget {
  final Map<String, dynamic> bookingData;
  const DeskstopBookingDataScreen({super.key, required this.bookingData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DeskstopAppBar(title: 'booking_summary'.tr(), isClickable: false),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.35,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                _buildInfoCard(context, Icons.person, 'name'.tr(),
                    bookingData['username']),
                _buildDivider(),
                _buildInfoCard(context, Icons.phone, 'phNo'.tr(),
                    bookingData['ph_number']),
                _buildDivider(),
                _buildInfoCard(context, Icons.email_rounded, 'email'.tr(),
                    bookingData['email']),
                _buildDivider(),
                _buildInfoCard(context, Icons.calendar_month_rounded,
                    'selectedDate'.tr(), bookingData['date']),
                _buildDivider(),
                _buildInfoCard(context, Icons.watch_later_rounded, 'hour'.tr(),
                    bookingData['time']),
                _buildDivider(),
                _buildInfoCard(context, Icons.group_rounded,
                    'number_people'.tr(), bookingData['guest'].toString()),
                _buildDivider(),
                _buildInfoCard(context, Icons.house_rounded, 'roomType'.tr(),
                    bookingData['room_type']),
                _buildDivider(),
                _buildInfoCard(context, Icons.local_offer_rounded,
                    'roomName'.tr(), bookingData['room_name']),
                _buildDivider(),
                _buildInfoCard(context, Icons.info_rounded, 'Status',
                    bookingData['status']),
                const SizedBox(height: 20),
                ButtonUtils.backwardButton(
                    double.infinity, 'back'.tr(), () => Navigator.pop(context)),
              ],
            ),
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
      BuildContext context, IconData icon, String title, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icon,
        color: Theme.of(context).iconTheme.color,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      trailing: Text(
        value,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
