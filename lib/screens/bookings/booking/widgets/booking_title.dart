import 'package:flutter/material.dart';
import 'package:ruyi_booking/utils/constants.dart';

enum BookingTitleType { mobileSize, desktopSize }

class BookingTitle extends StatelessWidget {
  final String label;
  final String icon;
  final BookingTitleType type;
  const BookingTitle(
      {super.key,
      required this.label,
      required this.icon,
      this.type = BookingTitleType.mobileSize});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          icon,
          width: type == BookingTitleType.mobileSize ? 17 : 22,
          height: type == BookingTitleType.mobileSize ? 17 : 22,
          color: Theme.of(context).iconTheme.color,
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontFamily: 'PlayfairDisplay',
                color: AppColors.appAccent,
              ),
        ),
      ],
    );
  }
}
