import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ruyi_booking/screens/admins/edit_menus/edit_booked_menu/edit_booked_menu_screen.dart';
import 'package:ruyi_booking/utils/constants.dart';

class MenuButton extends StatelessWidget {
  final Map<String, dynamic> bookingData;
  const MenuButton({super.key, required this.bookingData});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Image.asset(
        'assets/icons/cart.png',
        height: 17,
        width: 17,
        color: Theme.of(context).iconTheme.color,
      ),
      title: Text(
        'pre_order'.tr(),
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      trailing: Stack(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return EditBookedMenuScreen(bookingData: bookingData);
              }));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.appAccent,
                borderRadius: BorderRadius.circular(AppSize.cardBorderRadius),
              ),
              child: Text(
                'menu'.tr(),
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: AppColors.appBackground),
              ),
            ),
          ),
          bookingData['menu_list'].isNotEmpty
              ? Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.white,
                    child: Text(
                      bookingData['menu_list'].length.toString(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.appAccent,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
