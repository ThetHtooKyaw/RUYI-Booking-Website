import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/booking_data_provider.dart';
import 'package:ruyi_booking/providers/menu_data_provider.dart';
import 'package:ruyi_booking/screens/menu_screens/menu_screen.dart';
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
    var menuData = Provider.of<MenuDataProvider>(context);

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
                    _buildCardName(
                        context, 'date'.tr(), 'assets/icons/calendar.png'),
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
                      _buildCardName(
                          context, 'time'.tr(), 'assets/icons/time.png'),
                      TimePicker(
                        onTimeChanged: bookingData.onTimeChanged,
                        width: 400,
                        currentTime: bookingData.selectedTime,
                      ),
                      _buildCardName(
                          context, 'no_guest'.tr(), 'assets/icons/group.png'),
                      GuestCounter(
                        onGuestNumberChanged: bookingData.onGuestCounterChanged,
                        width: 400,
                        height: 70,
                      ),
                      _buildCardName(context, 'roomType'.tr(),
                          'assets/icons/table_type.png'),
                      RoomPicker(
                        selectedRoomtype: bookingData.selectedRoomtype,
                        onRoomTypeChange: bookingData.onRoomTypeChange,
                        isVipRoomAvailable: bookingData.isVipRoomAvailable,
                        width: 400,
                      ),
                      _buildCardName(
                          context, 'username'.tr(), 'assets/icons/name.png'),
                      TextFieldUtils.nameTextField(bookingData.nameController,
                          'Enter your full name', 400),
                      _buildCardName(
                          context, 'phNo'.tr(), 'assets/icons/phone.png'),
                      TextFieldUtils.phoneNumberTextField(
                          bookingData.phNoController,
                          'Enter your phone number',
                          400),
                      _buildCardName(
                          context, 'email'.tr(), 'assets/icons/email.png'),
                      TextFieldUtils.emailTextField(
                          bookingData.emailController, 'Enter your email', 400),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: SizedBox(
                          width: 400,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildCardName(context, 'pre_order'.tr(),
                                  'assets/icons/cart.png'),
                              Stack(
                                children: [
                                  ButtonUtils.forwardButton(150, 'menu'.tr(),
                                      () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return const MenuScreen();
                                    }));
                                  }, 17),
                                  menuData.cartedItems.isNotEmpty
                                      ? Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: CircleAvatar(
                                            radius: 8,
                                            backgroundColor: Colors.white,
                                            child: Text(
                                              menuData.cartedItems.length
                                                  .toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                      color:
                                                          AppColors.appAccent,
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonUtils.backwardButton(400, 'cancel'.tr(),
                    () => bookingData.resetForm(context), 17),
                const SizedBox(width: 20),
                ButtonUtils.forwardButton(400, 'continue'.tr(),
                    () => bookingData.continueBooking(context), 17),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardName(BuildContext context, String name, String icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Image.asset(
            icon,
            width: 22,
            height: 22,
            color: Theme.of(context).iconTheme.color,
          ),
          const SizedBox(width: 10),
          Text(
            name,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 22,
                  fontFamily: 'PlayfairDisplay',
                  color: AppColors.appAccent,
                ),
          ),
        ],
      ),
    );
  }
}
