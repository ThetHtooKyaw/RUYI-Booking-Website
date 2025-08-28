import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ruyi_booking/utils/constants.dart';

class CartEmptyTitle extends StatelessWidget {
  const CartEmptyTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 250),
          Text(
            'note3'.tr(),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.appAccent, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'note4'.tr(),
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}