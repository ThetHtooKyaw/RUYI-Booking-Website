import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ruyi_booking/utils/colors.dart';
import 'package:ruyi_booking/widgets/extras/custom_checkbox.dart';

class CalendarRules extends StatelessWidget {
  const CalendarRules({super.key});

  @override
  Widget build(BuildContext context) {
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
