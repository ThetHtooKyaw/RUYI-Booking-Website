import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ruyi_booking/utils/colors.dart';
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
                _buildInfoCard(context, 'name'.tr(), bookingData['username']),
                _buildDivider(),
                _buildInfoCard(context, 'phNo'.tr(), bookingData['ph_number']),
                _buildDivider(),
                _buildInfoCard(context, 'email'.tr(), bookingData['email']),
                _buildDivider(),
                _buildInfoCard(
                    context, 'selectedDate'.tr(), bookingData['date']),
                _buildDivider(),
                _buildInfoCard(context, 'hour'.tr(), bookingData['time']),
                _buildDivider(),
                _buildInfoCard(context, 'number_people'.tr(),
                    bookingData['guest'].toString()),
                _buildDivider(),
                _buildInfoCard(
                    context, 'roomType'.tr(), bookingData['room_type']),
                _buildDivider(),
                _buildInfoCard(
                    context, 'roomName'.tr(), bookingData['room_name']),
                _buildDivider(),
                _buildInfoCard(context, 'Status', bookingData['status']),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.only(
                    bottom: 20,
                  ),
                  width: MediaQuery.of(context).size.width * 0.35,
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
