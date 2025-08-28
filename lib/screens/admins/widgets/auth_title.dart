import 'package:flutter/material.dart';

enum AdminTitleType { mobileSize, desktopSize }

class AdminTitle extends StatelessWidget {
  final String title;
  final AdminTitleType type;
  const AdminTitle({
    super.key,
    required this.title,
    this.type = AdminTitleType.mobileSize,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: type == AdminTitleType.mobileSize
          ? Theme.of(context).textTheme.titleSmall
          : Theme.of(context).textTheme.titleMedium,
    );
  }
}
