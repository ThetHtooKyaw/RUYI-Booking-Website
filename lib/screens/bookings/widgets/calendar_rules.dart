import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ruyi_booking/utils/constants.dart';

class CalendarRules extends StatelessWidget {
  const CalendarRules({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCheckBox(
          context,
          Colors.white,
          Colors.black,
          'available'.tr(),
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
        _buildCheckBox(
          context,
          AppColors.appAccent,
          Colors.black,
          'selected'.tr(),
        ),
      ],
    );
  }

  Widget _buildCheckBox(
    BuildContext context,
    Color color,
    Color borderColor,
    String text,
  ) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            border: Border.all(
              color: borderColor,
              width: 0.5,
            ),
            color: color,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
