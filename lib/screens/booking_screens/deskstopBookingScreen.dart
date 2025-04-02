import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/bookingDataProvider.dart';
import 'package:ruyi_booking/utils/colors.dart';
import 'package:ruyi_booking/widgets/cores/calendar.dart';
import 'package:ruyi_booking/widgets/cores/guest_counter.dart';
import 'package:ruyi_booking/widgets/cores/room_picker.dart';
import 'package:ruyi_booking/widgets/cores/time_picker.dart';
import 'package:ruyi_booking/widgets/extras/custom_checkbox.dart';
import 'package:ruyi_booking/widgets/extras/deskstopAppBar.dart';

class DeskstopBookingScreen extends StatefulWidget {
  const DeskstopBookingScreen({super.key});

  @override
  State<DeskstopBookingScreen> createState() => _DeskstopBookingScreenState();
}

class _DeskstopBookingScreenState extends State<DeskstopBookingScreen> {
  @override
  Widget build(BuildContext context) {
    var bookingData = Provider.of<BookingDataProvider>(context);
    return Scaffold(
      appBar: DeskstopAppBar(title: 'booking'.tr(), isClickable: true),
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
                    _buildCalendarRules(context),
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
                      _buildTextField(
                        bookingData.nameController,
                        'Your full name',
                        (value) {
                          if (value == null || value.isEmpty) {
                            return 'Username is required';
                          } else if (value.length < 3) {
                            return 'Username must have at least 3 characters';
                          }

                          return null;
                        },
                      ),
                      _buildCardName(context, 'phNo'.tr()),
                      _buildTextField(
                        bookingData.phNoController,
                        'Enter your phone number',
                        (value) {
                          if (value == null || value.isEmpty) {
                            return 'Phone number is required';
                          } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                            return 'Phone number must contain only digits';
                          } else if (value.length < 10) {
                            return 'Phone number must have at least 10 characters';
                          } else if (value.contains(' ')) {
                            return 'Email should not contain spaces';
                          }

                          return null;
                        },
                      ),
                      _buildCardName(context, 'email'.tr()),
                      _buildTextField(
                        bookingData.emailController,
                        'Enter your email',
                        (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          } else if (value.length < 6) {
                            return 'Phone number must have at least 6 characters';
                          } else if (value.contains(' ')) {
                            return 'Email should not contain spaces';
                          } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                              .hasMatch(value)) {
                            return 'Enter a valid email';
                          }

                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildButtons(bookingData, context)
        ],
      ),
    );
  }

  Widget _buildButtons(BookingDataProvider bookingData, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
          ),
          width: 400,
          child: Material(
            elevation: 5,
            shadowColor: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10),
            color: AppColors.appBackground,
            child: OutlinedButton(
              onPressed: bookingData.resetForm,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(
                'cancel'.tr(),
                style: const TextStyle(fontSize: 17),
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
          ),
          width: 400,
          child: ElevatedButton(
            onPressed: () => bookingData.continueBooking(context),
            style: ElevatedButton.styleFrom(
              elevation: 5,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(
              'continue'.tr(),
              style: const TextStyle(fontSize: 17),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      String? Function(String?) validator) {
    return SizedBox(
      width: 400,
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
            )),
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

  Widget _buildCalendarRules(BuildContext context) {
    return Row(
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
    );
  }
}
