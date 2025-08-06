import 'package:flutter/material.dart';
import 'package:ruyi_booking/utils/colors.dart';
import 'package:ruyi_booking/widgets/cores/main_logo.dart';

enum MobileAppBarType { withBtn, withoudBtn }

class MobileAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final MobileAppBarType type;
  const MobileAppbar({
    super.key,
    required this.title,
    this.type = MobileAppBarType.withBtn,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      toolbarHeight: 60,
      leadingWidth: 70,
      backgroundColor: Colors.white,
      leading: type == MobileAppBarType.withBtn
          ? GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.keyboard_arrow_left_rounded,
                size: 40,
                color: Theme.of(context).iconTheme.color,
              ),
            )
          : const SizedBox(),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 20,
              color: AppColors.appAccent,
              fontFamily: 'PlayfairDisplay',
            ),
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Center(
              child: MainLogo(height: 45, width: 45, isClickable: false)),
        ),
      ],
    );
  }
}
