import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/menu_data_provider.dart';
import 'package:ruyi_booking/screens/menus/widgets/item_counter.dart';
import 'package:ruyi_booking/utils/constants.dart';

import '../../../../widgets/cores/custom_network_image.dart';

enum CartMenuCardType { mobileSize, desktopSize }

class CartMenuCard extends StatefulWidget {
  final Map<String, dynamic> menuItem;
  final String itemKey;
  final CartMenuCardType type;
  const CartMenuCard({
    super.key,
    required this.menuItem,
    required this.itemKey,
    this.type = CartMenuCardType.mobileSize,
  });

  @override
  State<CartMenuCard> createState() => _CartMenuCardState();
}

class _CartMenuCardState extends State<CartMenuCard> {
  @override
  Widget build(BuildContext context) {
    var menuData = Provider.of<MenuDataProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.all(AppSize.cardPadding),
      height: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSize.cardBorderRadius),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSize.smallCardBorderRadius),
            child: SizedBox(
              height: widget.type == CartMenuCardType.mobileSize
                  ? screenWidth <= 414
                      ? 150
                      : 160
                  : 160,
              width: 150,
              child:
                  CustomNetworkImage(imagePath: widget.menuItem['itemImage']),
            ),
          ),
          SizedBox(width: screenWidth < 430 ? 10 : 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.menuItem['itemName'].toString().tr(),
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.appAccent,
                      ),
                ),
                const SizedBox(height: 5),
                widget.menuItem['selectedType'] != null &&
                        widget.menuItem['selectedType'].toString().isNotEmpty
                    ? Row(
                        children: [
                          Image.asset(
                            'assets/icons/cooking.png',
                            width: 17,
                            height: 17,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.menuItem['selectedType'].toString().tr(),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      )
                    : const SizedBox(),
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
                      menuData.onGetCartPrice(widget.menuItem),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ItemCounter(
                      quantity: widget.menuItem['quantity'],
                      onQuantityChanged: (newQty) {
                        menuData.onCartItemQuantityChanged(
                            widget.itemKey, newQty);
                      },
                      onZeroQuantityReached: () =>
                          menuData.removeFromCart(widget.itemKey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
