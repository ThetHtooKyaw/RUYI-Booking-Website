import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/bookingDataProvider.dart';
import 'package:ruyi_booking/utils/colors.dart';
import 'package:ruyi_booking/widgets/extras/deskstopAppBar.dart';

class DeskstopBookingSummaryScreen extends StatefulWidget {
  const DeskstopBookingSummaryScreen({super.key});

  @override
  State<DeskstopBookingSummaryScreen> createState() =>
      _DeskstopBookingSummaryScreenState();
}

class _DeskstopBookingSummaryScreenState
    extends State<DeskstopBookingSummaryScreen> {
  @override
  Widget build(BuildContext context) {
    var bookingData = Provider.of<BookingDataProvider>(context);
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
                _buildInfoCard(
                    context, 'name'.tr(), bookingData.nameController.text),
                _buildDivider(),
                _buildInfoCard(
                    context, 'phNo'.tr(), bookingData.phNoController.text),
                _buildDivider(),
                _buildInfoCard(
                    context, 'email'.tr(), bookingData.emailController.text),
                _buildDivider(),
                _buildInfoCard(
                    context, 'selectedDate'.tr(), bookingData.formattedDate),
                _buildDivider(),
                _buildInfoCard(context, 'hour'.tr(), bookingData.selectedTime),
                _buildDivider(),
                _buildInfoCard(context, 'number_people'.tr(),
                    bookingData.guestCounter.toString()),
                _buildDivider(),
                _buildInfoCard(context, 'roomType'.tr(),
                    bookingData.selectedRoomtype ?? ''),
                _buildDivider(),
                _buildInfoCard(context, 'roomName'.tr(),
                    bookingData.selectedRoomName ?? ''),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: ElevatedButton(
                    onPressed: () => bookingData.savingBooking(context),
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      'confirm'.tr(),
                      style: const TextStyle(fontSize: 17),
                    ),
                  ),
                ),
                SizedBox(
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
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 20),
      ),
      trailing: Text(
        value,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
