import 'package:flutter/material.dart';
import '../../../../../utils/constants.dart';

class OptionText extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  const OptionText({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
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
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.appAccent,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Flexible(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
