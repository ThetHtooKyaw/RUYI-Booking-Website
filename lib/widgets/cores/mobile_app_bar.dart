import 'package:flutter/material.dart';
import 'package:ruyi_booking/utils/constants.dart';
import 'package:ruyi_booking/widgets/cores/main_logo.dart';

enum MobileAppBarType { withBtn, withoudBtn }

class MobileAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final BoxShadow shadow;
  final MobileAppBarType type;
  const MobileAppbar({
    super.key,
    required this.title,
    this.shadow = const BoxShadow(),
    this.type = MobileAppBarType.withBtn,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          shadow
        ],
      ),
      child: AppBar(
        centerTitle: true,
        toolbarHeight: 60,
        leadingWidth: 70,
        backgroundColor: Colors.white,
        elevation: 0,
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
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
      ),
    );
  }
}
