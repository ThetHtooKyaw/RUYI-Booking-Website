import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/booking_data_provider.dart';
import 'package:ruyi_booking/utils/constants.dart';
import 'package:ruyi_booking/screens/bookings/widgets/calendar.dart';
import 'package:ruyi_booking/screens/bookings/widgets/calendar_rules.dart';
import 'package:ruyi_booking/widgets/extras/custom_buttons.dart';

class MobileEditCalendarScreen extends StatefulWidget {
  const MobileEditCalendarScreen({super.key});

  @override
  State<MobileEditCalendarScreen> createState() =>
      _MobileEditCalendarScreenState();
}

class _MobileEditCalendarScreenState extends State<MobileEditCalendarScreen> {
  @override
  Widget build(BuildContext context) {
    var bookingData = Provider.of<BookingDataProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSize.screenPadding),
          child: Column(
            children: [
              Calendar(
                  selectedDate: bookingData.selectedDate,
                  onDateChanged: bookingData.onSelectedDate),
              const SizedBox(height: 20),
              const CalendarRules(),
              const SizedBox(height: 40),
              ButtonUtils.forwardButton(
                context: context,
                width: double.infinity,
                label: 'disable'.tr(),
                fontSize: 17,
                onPressed: () async {
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
                },
              ),
              const SizedBox(height: 10),
              ButtonUtils.backwardButton(
                context: context,
                width: double.infinity,
                label: 'remove'.tr(),
                fontSize: 17,
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
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                          "This date is not disabled!",
                          style: TextStyle(color: AppColors.appBackground),
                        ),
                        backgroundColor: AppColors.appAccent,
                      ));
                    }
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
