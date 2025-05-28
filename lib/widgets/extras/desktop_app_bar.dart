import 'package:flutter/material.dart';
import 'package:ruyi_booking/utils/colors.dart';
import 'package:ruyi_booking/widgets/cores/main_logo.dart';

class DesktopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isClickable;
  const DesktopAppBar(
      {super.key, required this.title, required this.isClickable});

  @override
  Size get preferredSize => const Size.fromHeight(85);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: 85,
      leadingWidth: 200,
      leading: Padding(
        padding: const EdgeInsets.only(left: 40),
        child: Center(
          child: MainLogo(
            height: 55,
            width: 55,
            isClickable: isClickable,
          ),
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 30,
              color: AppColors.appAccent,
              fontFamily: 'PlayfairDisplay',
            ),
      ),
    );
  }
}
