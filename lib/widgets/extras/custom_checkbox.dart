import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final Color color;
  final Color borderColor;
  final String text;
  final Widget? child;

  const CustomCheckbox({
    super.key,
    required this.color,
    required this.borderColor,
    required this.text,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
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
          child: child,
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
