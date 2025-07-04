import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/booking_data_provider.dart';
import 'package:ruyi_booking/utils/colors.dart';
import 'package:ruyi_booking/widgets/cores/calendar.dart';
import 'package:ruyi_booking/widgets/extras/calendar_rules.dart';
import 'package:ruyi_booking/widgets/extras/custom_buttons.dart';

class DesktopCalendarEditScreen extends StatefulWidget {
  const DesktopCalendarEditScreen({super.key});

  @override
  State<DesktopCalendarEditScreen> createState() =>
      _DesktopCalendarEditScreenState();
}

class _DesktopCalendarEditScreenState extends State<DesktopCalendarEditScreen> {
  @override
  Widget build(BuildContext context) {
    var bookingData = Provider.of<BookingDataProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.35,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Calendar(
                    selectedDate: bookingData.selectedDate,
                    onDateChanged: bookingData.onSelectedDate),
                const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 10),
                  child: CalendarRules(),
                ),
                const SizedBox(height: 20),
                ButtonUtils.forwardButton(double.infinity, 'disable'.tr(),
                    () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2040, 12, 31),
                  );

                  if (selectedDate != null) {
                    if (bookingData.isDisabledDate(selectedDate)) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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
                }, 17),
                ButtonUtils.backwardButton(double.infinity, 'remove'.tr(),
                    () async {
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
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                          "This date is not disabled!",
                          style: TextStyle(color: AppColors.appBackground),
                        ),
                        backgroundColor: AppColors.appAccent,
                      ));
                    }
                  }
                }, 17),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
