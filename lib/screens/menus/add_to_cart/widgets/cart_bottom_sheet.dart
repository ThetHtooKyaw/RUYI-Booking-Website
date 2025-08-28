import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/menu_data_provider.dart';
import 'package:ruyi_booking/utils/constants.dart';

enum CartBottomSheetType { userSite, adminSite }

class CartBottomSheet extends StatelessWidget {
  final dynamic cartedItems;
  final Widget button;

  final CartBottomSheetType type;
  const CartBottomSheet({
    super.key,
    required this.cartedItems,
    required this.button,
    this.type = CartBottomSheetType.userSite,
  });

  @override
  Widget build(BuildContext context) {
    var menuData = Provider.of<MenuDataProvider>(context);

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSize.screenPadding,
          vertical: AppSize.screenPadding - 4),
      height: type == CartBottomSheetType.userSite ? 195 : 155,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppSize.cardBorderRadius)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, -3),
          )
        ],
      ),
      child: Column(
        children: [
          type == CartBottomSheetType.userSite
              ? Text(
                  'note2'.tr(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.appAccent),
                )
              : const SizedBox(),
          const SizedBox(height: 10),
          _buildPriceText(context, 'assets/icons/quantity.png', 'quantity'.tr(),
              cartedItems.length.toString()),
          // priceText(context, 'Discount', ''),
          const Divider(thickness: 2),
          _buildPriceText(context, 'assets/icons/price.png', 'price'.tr(),
              menuData.calculateTotalPrice(cartedItems)),
          const Spacer(),
          button,
        ],
      ),
    );
  }

  Widget _buildPriceText(
      BuildContext context, String icon, String text, String price) {
    return Row(
      children: [
        Image.asset(
          icon,
          width: 17,
          height: 17,
          color: Theme.of(context).iconTheme.color,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const Spacer(),
        Text(
          price,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
