import 'package:flutter/material.dart';
import 'package:ruyi_booking/utils/colors.dart';
import 'package:ruyi_booking/widgets/cores/main_logo.dart';

class MobileAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isClickable;
  const MobileAppbar(
      {super.key, required this.title, required this.isClickable});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      toolbarHeight: 60,
      leadingWidth: 80,
      backgroundColor: Colors.white,
      leading: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Center(
            child: MainLogo(height: 45, width: 45, isClickable: isClickable)),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 20,
              color: AppColors.appAccent,
              fontFamily: 'PlayfairDisplay',
            ),
      ),
    );
  }
}
