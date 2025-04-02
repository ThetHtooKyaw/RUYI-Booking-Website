import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ruyi_booking/utils/colors.dart';
import 'package:ruyi_booking/widgets/extras/mobileAppBar.dart';

class MobileBookingDataScreen extends StatelessWidget {
  final Map<String, dynamic> bookingData;
  const MobileBookingDataScreen({super.key, required this.bookingData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MobileAppbar(title: 'booking_summary'.tr(), isClickable: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            _buildInfoCard(context, 'name'.tr(), bookingData['username']),
            _buildDivider(),
            _buildInfoCard(context, 'phNo'.tr(), bookingData['ph_number']),
            _buildDivider(),
            _buildInfoCard(context, 'email'.tr(), bookingData['email']),
            _buildDivider(),
            _buildInfoCard(context, 'selectedDate'.tr(), bookingData['date']),
            _buildDivider(),
            _buildInfoCard(context, 'hour'.tr(), bookingData['time']),
            _buildDivider(),
            _buildInfoCard(
                context, 'number_people'.tr(), bookingData['guest'].toString()),
            _buildDivider(),
            _buildInfoCard(context, 'roomType'.tr(), bookingData['room_type']),
            _buildDivider(),
            _buildInfoCard(context, 'roomName'.tr(), bookingData['room_name']),
            _buildDivider(),
            _buildInfoCard(context, 'Status', bookingData['status']),
            const Spacer(),
            Container(
              padding: const EdgeInsets.only(
                bottom: 20,
              ),
              width: 450,
              child: Material(
                elevation: 5,
                shadowColor: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10),
                color: AppColors.appBackground,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    'back'.tr(),
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Divider _buildDivider() {
    return const Divider(
      indent: 18,
      endIndent: 18,
      thickness: 2,
    );
  }

  ListTile _buildInfoCard(BuildContext context, String title, String value) {
    return ListTile(
      leading: Text(
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
