import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/menu_data_provider.dart';
import 'package:ruyi_booking/screens/menus/widgets/item_counter.dart';
import 'package:ruyi_booking/screens/menus/widgets/small_button.dart';
import 'package:ruyi_booking/screens/menus/widgets/type_section.dart';
import 'package:ruyi_booking/utils/constants.dart';

enum MenuCardType { mobileSize, desktopSize }

class MenuCard extends StatefulWidget {
  final Map<String, dynamic> menuItem;
  final String uniqueKey;
  final MenuCardType type;
  const MenuCard({
    super.key,
    required this.menuItem,
    required this.uniqueKey,
    this.type = MenuCardType.mobileSize,
  });

  @override
  State<MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> {
  @override
  Widget build(BuildContext context) {
    var menuData = Provider.of<MenuDataProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.all(AppSize.cardPadding),
      height: widget.type == MenuCardType.mobileSize
          ? (screenWidth * 0.45).clamp(130.0, 178.0)
          : 175,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSize.cardBorderRadius),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSize.smallCardBorderRadius),
            child: SizedBox(
              height: widget.type == MenuCardType.mobileSize
                  ? (screenWidth * 0.38).clamp(100.0, 160.0)
                  : 160,
              width: widget.type == MenuCardType.mobileSize
                  ? (screenWidth * 0.36).clamp(110.0, 170.0)
                  : 200,
              child: Image.asset(
                widget.menuItem['image'],
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: screenWidth < 430 ? 10 : 15),
          _buildFoodInfo(context, menuData, widget.menuItem, widget.uniqueKey),
        ],
      ),
    );
  }

  Widget _buildFoodInfo(BuildContext context, MenuDataProvider menuData,
      Map<String, dynamic> item, String uniqueKey) {
    int qty = menuData.itemQty[uniqueKey] ?? 0;
    final options = item['options'] as Map<String, dynamic>? ?? {};

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item['name'].toString().tr(),
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.appAccent,
                ),
          ),
          const SizedBox(height: 5),
          TypeSection(item: item, options: options),
          const SizedBox(height: 5),
          Row(
            children: [
              Image.asset(
                'assets/icons/price.png',
                width: 17,
                height: 17,
                color: Theme.of(context).iconTheme.color,
              ),
              const SizedBox(width: 10),
              Text(
                menuData.onGetPrice(item),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ItemCounter(
                quantity: qty,
                onQuantityChanged: (newQty) =>
                    menuData.onQuantityChanged(uniqueKey, newQty),
              ),
              SmallButton(
                label: 'cart'.tr(),
                onPressed: () {
                  if (qty == 0) {
                    qty = 1;
                    menuData.onQuantityChanged(uniqueKey, qty);
                  }
                  menuData.addToCart(
                    uniqueKey,
                    item,
                    menuData.priceKey(item),
                    menuData.typeKey(item),
                    qty,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
