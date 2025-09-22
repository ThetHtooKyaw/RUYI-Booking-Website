import 'package:flutter/material.dart';
import 'package:ruyi_booking/utils/constants.dart';
import 'package:ruyi_booking/widgets/cores/main_logo.dart';

enum DesktopAppBarType { withBtn, withoudBtn }

class DesktopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final DesktopAppBarType type;
  const DesktopAppBar(
      {super.key, required this.title, this.type = DesktopAppBarType.withBtn});

  @override
  Size get preferredSize => const Size.fromHeight(70); // Standard AppBar height

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: 70,
      leadingWidth: 100,
      centerTitle: true,
      leading: type == DesktopAppBarType.withBtn
          ? Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.keyboard_arrow_left_rounded,
                    size: 55,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ),
            )
          : const SizedBox.expand(),
      actions: [
        type == DesktopAppBarType.withBtn
            ? const Padding(
                padding: EdgeInsets.only(right: 40),
                child: Center(
                  child: MainLogo(
                    height: 55,
                    width: 55,
                    isClickable: false,
                  ),
                ),
              )
            : const SizedBox(),
      ],
      title: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.appAccent,
              fontFamily: 'PlayfairDisplay',
            ),
      ),
    );
  }
}
