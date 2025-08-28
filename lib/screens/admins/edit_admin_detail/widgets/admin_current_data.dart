import 'package:flutter/material.dart';

class AdminCurrentData extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const AdminCurrentData({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        InkWell(
          onTap: onTap,
          child: Icon(
            Icons.edit_rounded,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
      ],
    );
  }
}
