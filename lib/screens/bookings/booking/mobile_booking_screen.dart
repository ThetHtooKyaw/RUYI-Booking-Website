import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/booking_data_provider.dart';
import 'package:ruyi_booking/providers/menu_data_provider.dart';
import 'package:ruyi_booking/screens/bookings/booking/widgets/booking_title.dart';
import 'package:ruyi_booking/screens/menus/menu/menu_screen.dart';
import 'package:ruyi_booking/utils/constants.dart';
import 'package:ruyi_booking/screens/bookings/widgets/calendar.dart';
import 'package:ruyi_booking/screens/bookings/widgets/guest_counter.dart';
import 'package:ruyi_booking/screens/bookings/widgets/room_picker.dart';
import 'package:ruyi_booking/screens/bookings/widgets/time_picker.dart';
import 'package:ruyi_booking/screens/bookings/widgets/calendar_rules.dart';
import 'package:ruyi_booking/widgets/extras/custom_buttons.dart';
import 'package:ruyi_booking/widgets/extras/custom_textfields.dart';
import 'package:ruyi_booking/widgets/cores/mobile_app_bar.dart';

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
      appBar: MobileAppbar(title: 'booking'.tr()),
      body: Form(
        key: bookingData.formKey,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSize.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  BookingTitle(
                      label: 'date'.tr(), icon: 'assets/icons/calendar.png'),
                  const SizedBox(height: 10),
                  Calendar(
                      selectedDate: bookingData.selectedDate,
                      onDateChanged: bookingData.onSelectedDate),
                  if (bookingData.dateErrorText != null)
                    Padding(
                      padding: const EdgeInsets.all(AppSize.screenPadding),
                      child: Text(
                        bookingData.dateErrorText!,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: AppColors.appAccent),
                      ),
                    ),
                  const SizedBox(height: 20),
                  const CalendarRules(),
                  const SizedBox(height: 26),
                  BookingTitle(
                      label: 'time'.tr(), icon: 'assets/icons/time.png'),
                  const SizedBox(height: 10),
                  TimePicker(
                    onTimeChanged: bookingData.onTimeChanged,
                    width: double.infinity,
                    currentTime: bookingData.selectedTime,
                  ),
                  const SizedBox(height: 26),
                  BookingTitle(
                      label: 'no_guest'.tr(), icon: 'assets/icons/group.png'),
                  const SizedBox(height: 10),
                  GuestCounter(
                    onGuestNumberChanged: bookingData.onGuestCounterChanged,
                    width: double.infinity,
                    height: 50,
                  ),
                  const SizedBox(height: 26),
                  BookingTitle(
                      label: 'roomType'.tr(),
                      icon: 'assets/icons/table_type.png'),
                  const SizedBox(height: 10),
                  RoomPicker(
                    selectedRoomtype: bookingData.selectedRoomtype,
                    onRoomTypeChange: bookingData.onRoomTypeChange,
                    isVipRoomAvailable: bookingData.isVipRoomAvailable,
                    isVipBigRoomAvailable: bookingData.isVipBigRoomAvailable,
                    isTableNoAvailable: bookingData.isTableNoAvailable,
                    width: MediaQuery.of(context).size.width * 0.95,
                  ),
                  const SizedBox(height: 26),
                  BookingTitle(
                      label: 'username'.tr(), icon: 'assets/icons/name.png'),
                  const SizedBox(height: 10),
                  TextFieldUtils.nameTextField(bookingData.nameController,
                      'Enter your full name', double.infinity),
                  const SizedBox(height: 10),
                  BookingTitle(
                      label: 'phNo'.tr(), icon: 'assets/icons/phone.png'),
                  const SizedBox(height: 10),
                  TextFieldUtils.phoneNumberTextField(
                      bookingData.phNoController,
                      'Enter your phone number',
                      double.infinity),
                  const SizedBox(height: 10),
                  BookingTitle(
                      label: 'email'.tr(), icon: 'assets/icons/email.png'),
                  const SizedBox(height: 10),
                  TextFieldUtils.emailTextField(bookingData.emailController,
                      'Enter your email', double.infinity),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      BookingTitle(
                          label: 'pre_order'.tr(),
                          icon: 'assets/icons/cart.png'),
                      const Spacer(),
                      Stack(children: [
                        ButtonUtils.forwardButton(
                          context: context,
                          width: 150,
                          label: 'menu'.tr(),
                          fontSize: 17,
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const MenuScreen();
                            }));
                          },
                        ),
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
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ButtonUtils.backwardButton(
                          context: context,
                          width: 220,
                          label: 'cancel'.tr(),
                          fontSize: 17,
                          onPressed: () => bookingData.resetForm(
                              context, menuData.cartedItems),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ButtonUtils.forwardButton(
                          context: context,
                          width: 220,
                          label: 'continue'.tr(),
                          fontSize: 17,
                          onPressed: () => bookingData.continueBooking(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
