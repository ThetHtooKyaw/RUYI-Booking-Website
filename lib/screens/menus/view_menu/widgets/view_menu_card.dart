import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/menu_data_provider.dart';
import 'package:ruyi_booking/screens/menus/widgets/type_section.dart';
import 'package:ruyi_booking/utils/constants.dart';
import 'package:ruyi_booking/widgets/cores/custom_network_image.dart';

enum ViewMenuCardType { mobileSize, desktopSize }

class ViewMenuCard extends StatefulWidget {
  final Map<String, dynamic> menuItem;
  final String uniqueKey;
  final ViewMenuCardType type;
  const ViewMenuCard({
    super.key,
    required this.menuItem,
    required this.uniqueKey,
    this.type = ViewMenuCardType.mobileSize,
  });

  @override
  State<ViewMenuCard> createState() => _ViewMenuCardState();
}

class _ViewMenuCardState extends State<ViewMenuCard> {
  @override
  Widget build(BuildContext context) {
    var menuData = Provider.of<MenuDataProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.all(AppSize.cardPadding),
      height: widget.type == ViewMenuCardType.mobileSize
          ? (screenWidth * 0.45).clamp(130.0, 178.0)
          : 175,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSize.cardBorderRadius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSize.smallCardBorderRadius),
            child: SizedBox(
              height: widget.type == ViewMenuCardType.mobileSize
                  ? (screenWidth * 0.38).clamp(100.0, 160.0)
                  : 160,
              width: widget.type == ViewMenuCardType.mobileSize
                  ? (screenWidth * 0.36).clamp(110.0, 170.0)
                  : 200,
              child: CustomNetworkImage(imagePath: widget.menuItem['image']),
            ),
          ),
          const SizedBox(width: 15),
          _buildFoodInfo(context, menuData, widget.menuItem, widget.uniqueKey),
        ],
      ),
    );
  }

  Widget _buildFoodInfo(
    BuildContext context,
    MenuDataProvider menuData,
    Map<String, dynamic> item,
    String uniqueKey,
  ) {
    bool isclicked = menuData.isClickedItem(uniqueKey);
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
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                menuData.onFavItemAdd(uniqueKey, item, menuData.priceKey(item),
                    menuData.typeKey(item));
              },
              child: CircleAvatar(
                backgroundColor:
                    isclicked ? AppColors.appAccent : AppColors.appBackground,
                child: Icon(
                  Icons.favorite_rounded,
                  color:
                      isclicked ? AppColors.appBackground : AppColors.appAccent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
