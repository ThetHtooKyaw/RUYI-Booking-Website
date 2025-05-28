import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/booking_data_provider.dart';
import 'package:ruyi_booking/utils/colors.dart';
import 'package:ruyi_booking/widgets/cores/calendar.dart';
import 'package:ruyi_booking/widgets/cores/guest_counter.dart';
import 'package:ruyi_booking/widgets/cores/room_picker.dart';
import 'package:ruyi_booking/widgets/cores/time_picker.dart';
import 'package:ruyi_booking/widgets/extras/calendar_rules.dart';
import 'package:ruyi_booking/widgets/extras/custom_buttons.dart';
import 'package:ruyi_booking/widgets/extras/custom_textfields.dart';
import 'package:ruyi_booking/widgets/extras/desktop_app_bar.dart';

class DesktopBookingScreen extends StatefulWidget {
  const DesktopBookingScreen({super.key});

  @override
  State<DesktopBookingScreen> createState() => _DesktopBookingScreenState();
}

class _DesktopBookingScreenState extends State<DesktopBookingScreen> {
  @override
  Widget build(BuildContext context) {
    var bookingData = Provider.of<BookingDataProvider>(context);
    return Scaffold(
      appBar: DesktopAppBar(title: 'booking'.tr(), isClickable: true),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCardName(context, 'date'.tr()),
                    Calendar(
                        selectedDate: bookingData.selectedDate,
                        onDateChanged: bookingData.onSelectedDate),
                    if (bookingData.dateErrorText != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Text(
                          bookingData.dateErrorText!,
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.appAccent,
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                    const CalendarRules(),
                  ],
                ),
                const SizedBox(width: 50),
                Form(
                  key: bookingData.formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCardName(context, 'time'.tr()),
                      TimePicker(
                        onTimeChanged: bookingData.onTimeChanged,
                        width: 400,
                        currentTime: bookingData.selectedTime,
                      ),
                      _buildCardName(context, 'no_guest'.tr()),
                      GuestCounter(
                        onGuestNumberChanged: bookingData.onGuestCounterChanged,
                        width: 400,
                        height: 70,
                      ),
                      _buildCardName(context, 'roomType'.tr()),
                      RoomPicker(
                        selectedRoomtype: bookingData.selectedRoomtype,
                        onRoomTypeChange: bookingData.onRoomTypeChange,
                        isVipRoomAvailable: bookingData.isVipRoomAvailable,
                        width: 400,
                      ),
                      _buildCardName(context, 'username'.tr()),
                      TextFieldUtils.nameTextField(bookingData.nameController,
                          'Enter your full name', 400),
                      _buildCardName(context, 'phNo'.tr()),
                      TextFieldUtils.phoneNumberTextField(
                          bookingData.phNoController,
                          'Enter your phone number',
                          400),
                      _buildCardName(context, 'email'.tr()),
                      TextFieldUtils.emailTextField(
                          bookingData.emailController, 'Enter your email', 400),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonUtils.backwardButton(
                    400, 'cancel'.tr(), () => bookingData.resetForm(context)),
                const SizedBox(width: 20),
                ButtonUtils.forwardButton(400, 'continue'.tr(),
                    () => bookingData.continueBooking(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardName(BuildContext context, String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        name,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 22,
              fontFamily: 'PlayfairDisplay',
              color: AppColors.appAccent,
            ),
      ),
    );
  }
}
