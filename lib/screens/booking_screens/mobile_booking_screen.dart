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
import 'package:ruyi_booking/widgets/extras/mobile_app_bar.dart';

class MobileBookingScreen extends StatefulWidget {
  const MobileBookingScreen({super.key});

  @override
  State<MobileBookingScreen> createState() => _MobileBookingScreenState();
}

class _MobileBookingScreenState extends State<MobileBookingScreen> {
  @override
  Widget build(BuildContext context) {
    var bookingData = Provider.of<BookingDataProvider>(context);
    var menuData = Provider.of<MenuDataProvider>(context);

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
                  const Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 10),
                    child: CalendarRules(),
                  ),
                  _buildCardName(context, 'time'.tr(), 'assets/icons/time.png'),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: TimePicker(
                      onTimeChanged: bookingData.onTimeChanged,
                      width: double.infinity,
                      currentTime: bookingData.selectedTime,
                    ),
                  ),
                  _buildCardName(
                      context, 'no_guest'.tr(), 'assets/icons/group.png'),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: GuestCounter(
                      onGuestNumberChanged: bookingData.onGuestCounterChanged,
                      width: double.infinity,
                      height: 50,
                    ),
                  ),
                  _buildCardName(
                      context, 'roomType'.tr(), 'assets/icons/table_type.png'),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: RoomPicker(
                      selectedRoomtype: bookingData.selectedRoomtype,
                      onRoomTypeChange: bookingData.onRoomTypeChange,
                      isVipRoomAvailable: bookingData.isVipRoomAvailable,
                      width: MediaQuery.of(context).size.width * 0.95,
                    ),
                  ),
                  _buildCardName(
                      context, 'username'.tr(), 'assets/icons/name.png'),
                  TextFieldUtils.nameTextField(bookingData.nameController,
                      'Enter your full name', double.infinity),
                  _buildCardName(
                      context, 'phNo'.tr(), 'assets/icons/phone.png'),
                  TextFieldUtils.phoneNumberTextField(
                      bookingData.phNoController,
                      'Enter your phone number',
                      double.infinity),
                  _buildCardName(
                      context, 'email'.tr(), 'assets/icons/email.png'),
                  TextFieldUtils.emailTextField(bookingData.emailController,
                      'Enter your email', double.infinity),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        _buildCardName(
                            context, 'pre_order'.tr(), 'assets/icons/cart.png'),
                        const Spacer(),
                        Stack(children: [
                          ButtonUtils.forwardButton(150, 'menu'.tr(), () {
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
                                      menuData.cartedItems.length.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                              color: AppColors.appAccent,
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                        ]),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ButtonUtils.backwardButton(220, 'cancel'.tr(),
                              () => bookingData.resetForm(context), 17),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: ButtonUtils.forwardButton(220, 'continue'.tr(),
                              () => bookingData.continueBooking(context), 17),
                        ),
                      ],
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

  Widget _buildCardName(BuildContext context, String name, String icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Image.asset(
            icon,
            width: 17,
            height: 17,
            color: Theme.of(context).iconTheme.color,
          ),
          const SizedBox(width: 10),
          Text(
            name,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 18,
                  fontFamily: 'PlayfairDisplay',
                  color: AppColors.appAccent,
                ),
          ),
        ],
      ),
    );
  }
}
