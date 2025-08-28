import 'package:flutter/material.dart';

class BookingSummaryTitle extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  const BookingSummaryTitle({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Image.asset(
            icon,
            height: 17,
            width: 17,
            color: Theme.of(context).iconTheme.color,
          ),
          title: Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          trailing: Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}
