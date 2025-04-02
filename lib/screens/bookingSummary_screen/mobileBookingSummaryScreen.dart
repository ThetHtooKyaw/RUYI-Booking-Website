import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/bookingDataProvider.dart';
import 'package:ruyi_booking/utils/colors.dart';
import 'package:ruyi_booking/widgets/extras/mobileAppBar.dart';

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
    return Scaffold(
      appBar: MobileAppbar(title: 'booking_summary'.tr(), isClickable: false),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
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
              _buildInfoCard(
                  context, 'roomType'.tr(), bookingData.selectedRoomtype ?? ''),
              _buildDivider(),
              _buildInfoCard(
                  context, 'roomName'.tr(), bookingData.selectedRoomName ?? ''),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                ),
                width: 450,
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
