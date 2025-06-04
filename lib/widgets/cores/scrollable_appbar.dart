import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ruyi_booking/screens/admin_screens/admin_auth_screens/admin_auth_screen.dart';
import 'package:ruyi_booking/services/booking_service.dart';
import 'package:ruyi_booking/utils/colors.dart';
import 'package:ruyi_booking/widgets/cores/main_logo.dart';

class ScrollableAppbar extends StatelessWidget {
  BookingService bookingService = BookingService();
  final VoidCallback onPressed;
  ScrollableAppbar({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: false,
      pinned: true,
      toolbarHeight: 90,
      leadingWidth: 200,
      backgroundColor: Colors.white,
      elevation: 4,
      leading: Padding(
        padding: const EdgeInsets.only(left: 40),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Center(
                child: MainLogo(height: 55, width: 55),
              ),
            ),
            Container(
              height: 70,
              width: 2,
              color: AppColors.appAccent,
            ),
          ],
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {},
            child: Text(
              'about'.tr(),
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: AppColors.appAccent),
            ),
          ),
          const SizedBox(width: 50),
          InkWell(
            onTap: () {},
            child: Text(
              'FAQ'.tr(),
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: AppColors.appAccent),
            ),
          ),
          const SizedBox(width: 50),
          InkWell(
            onTap: () {
              bookingService.fetchBookingList();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return const AdminAuthScreen();
              }));
            },
            child: Text(
              'admin'.tr(),
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: AppColors.appAccent),
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 25),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
            ),
            child: const Text(
              'BOOK NOW',
            ),
          ),
        )
      ],
    );
  }
}
