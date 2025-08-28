import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ruyi_booking/screens/menus/widgets/menu_type_picker.dart';

class TypeSection extends StatelessWidget {
  final Map<String, dynamic> item;
  final Map<String, dynamic> options;
  const TypeSection({
    super.key,
    required this.item,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    if (options.length > 1) {
      return Row(
        children: [
          Image.asset(
            'assets/icons/cooking.png',
            width: 20,
            height: 20,
            color: Theme.of(context).iconTheme.color,
          ),
          const SizedBox(width: 8),
          MenuTypePicker(
            itemId: item['id'],
            itemOptions: options,
            key: ObjectKey(item['id']),
          ),
        ],
      );
    }

    if (options.isNotEmpty && options.values.first['type'] != null) {
      return Row(
        children: [
          Image.asset(
            'assets/icons/cooking.png',
            width: 17,
            height: 17,
            color: Theme.of(context).iconTheme.color,
          ),
          const SizedBox(width: 8),
          Text(
            options.values.first['type']?.toString().tr() ?? 'N/A',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      );
    }

    if (item['id'] == '22') {
      return Row(
        children: [
          Image.asset(
            'assets/icons/detail.png',
            width: 17,
            height: 17,
            color: Theme.of(context).iconTheme.color,
          ),
          const SizedBox(width: 8),
          Text(
            item['detail']?.toString().tr() ?? 'N/A',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      );
    }

    return const SizedBox();
  }
}
