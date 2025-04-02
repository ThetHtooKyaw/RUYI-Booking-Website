import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/bookingDataProvider.dart';
import 'package:ruyi_booking/utils/colors.dart';
import 'package:ruyi_booking/widgets/cores/calendar.dart';
import 'package:ruyi_booking/widgets/extras/custom_checkbox.dart';

class MobileCalendarEditScreen extends StatefulWidget {
  const MobileCalendarEditScreen({super.key});

  @override
  State<MobileCalendarEditScreen> createState() =>
      _MobileCalendarEditScreenState();
}

class _MobileCalendarEditScreenState extends State<MobileCalendarEditScreen> {
  @override
  Widget build(BuildContext context) {
    var bookingData = Provider.of<BookingDataProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Calendar(
                  selectedDate: bookingData.selectedDate,
                  onDateChanged: bookingData.onSelectedDate),
              _buildCalendarRules(context),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                width: MediaQuery.of(context).size.width * 0.95,
                child: ElevatedButton(
                  onPressed: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2040, 12, 31),
                    );

                    if (selectedDate != null) {
                      if (bookingData.isDisabledDate(selectedDate)) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                            "This date is already disabled!",
                            style: TextStyle(color: AppColors.appBackground),
                          ),
                          backgroundColor: AppColors.appAccent,
                        ));
                      } else {
                        bookingData.addDisabledDate(selectedDate);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    'disable'.tr(),
                    style: const TextStyle(fontSize: 17),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                width: MediaQuery.of(context).size.width * 0.95,
                child: ElevatedButton(
                  onPressed: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2040, 12, 31),
                    );

                    if (selectedDate != null) {
                      if (bookingData.isDisabledDate(selectedDate)) {
                        bookingData.removeDisabledDate(selectedDate);
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                            "This date is not disabled!",
                            style: TextStyle(color: AppColors.appBackground),
                          ),
                          backgroundColor: AppColors.appAccent,
                        ));
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    'remove'.tr(),
                    style: const TextStyle(fontSize: 17),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarRules(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomCheckbox(
            color: Colors.white,
            borderColor: Colors.black,
            text: 'available'.tr(),
          ),
          const SizedBox(width: 15),
          Row(
            children: [
              const Icon(
                Icons.disabled_by_default,
                color: Colors.grey,
              ),
              const SizedBox(width: 5),
              Text(
                'not_available'.tr(),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(width: 15),
          CustomCheckbox(
            color: AppColors.appAccent,
            borderColor: Colors.black,
            text: 'selected'.tr(),
          ),
        ],
      ),
    );
  }
}
