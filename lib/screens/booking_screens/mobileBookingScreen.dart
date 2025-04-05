import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/bookingDataProvider.dart';
import 'package:ruyi_booking/utils/colors.dart';
import 'package:ruyi_booking/widgets/cores/calendar.dart';
import 'package:ruyi_booking/widgets/cores/guest_counter.dart';
import 'package:ruyi_booking/widgets/cores/room_picker.dart';
import 'package:ruyi_booking/widgets/cores/time_picker.dart';
import 'package:ruyi_booking/widgets/extras/calendar_rules.dart';
import 'package:ruyi_booking/widgets/extras/custom_buttons.dart';
import 'package:ruyi_booking/widgets/extras/custom_textfields.dart';
import 'package:ruyi_booking/widgets/extras/mobileAppBar.dart';

class MobileBookingScreen extends StatefulWidget {
  const MobileBookingScreen({super.key});

  @override
  State<MobileBookingScreen> createState() => _MobileBookingScreenState();
}

class _MobileBookingScreenState extends State<MobileBookingScreen> {
  @override
  Widget build(BuildContext context) {
    var bookingData = Provider.of<BookingDataProvider>(context);
    return Scaffold(
      appBar: MobileAppbar(title: 'booking'.tr(), isClickable: true),
      body: Form(
        key: bookingData.formKey,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
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
                  const Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 10),
                    child: CalendarRules(),
                  ),
                  _buildCardName(context, 'time'.tr()),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: TimePicker(
                      onTimeChanged: bookingData.onTimeChanged,
                      width: double.infinity,
                      currentTime: bookingData.selectedTime,
                    ),
                  ),
                  _buildCardName(context, 'no_guest'.tr()),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: GuestCounter(
                      onGuestNumberChanged: bookingData.onGuestCounterChanged,
                      width: double.infinity,
                      height: 50,
                    ),
                  ),
                  _buildCardName(context, 'roomType'.tr()),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: RoomPicker(
                      selectedRoomtype: bookingData.selectedRoomtype,
                      onRoomTypeChange: bookingData.onRoomTypeChange,
                      isVipRoomAvailable: bookingData.isVipRoomAvailable,
                      width: MediaQuery.of(context).size.width * 0.95,
                    ),
                  ),
                  _buildCardName(context, 'username'.tr()),
                  TextFieldUtils.nameTextField(bookingData.nameController,
                      'Enter your full name', double.infinity),
                  _buildCardName(context, 'phNo'.tr()),
                  TextFieldUtils.phoneNumberTextField(
                      bookingData.phNoController,
                      'Enter your phone number',
                      double.infinity),
                  _buildCardName(context, 'email'.tr()),
                  TextFieldUtils.emailTextField(bookingData.emailController,
                      'Enter your email', double.infinity),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ButtonUtils.backwardButton(
                              220, 'cancel'.tr(), bookingData.resetForm),
                          const SizedBox(width: 20),
                          ButtonUtils.forwardButton(220, 'continue'.tr(),
                              () => bookingData.continueBooking(context)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      String? Function(String?) validator) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.95,
        child: TextFormField(
          controller: controller,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            hintText: hintText,
            errorStyle: const TextStyle(
              fontSize: 15,
              color: AppColors.appAccent,
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.appAccent),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardName(BuildContext context, String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        name,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 18,
              fontFamily: 'PlayfairDisplay',
              color: AppColors.appAccent,
            ),
      ),
    );
  }
}
