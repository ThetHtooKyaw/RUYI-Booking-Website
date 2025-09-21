import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/menu_data_provider.dart';
import 'package:ruyi_booking/utils/constants.dart';
import 'package:ruyi_booking/widgets/cores/custom_network_image.dart';

enum FavMenuCardType { mobileSize, desktopSize }

class FavMenuCard extends StatefulWidget {
  final Map<String, dynamic> menuItem;
  final String itemKey;
  final bool isclicked;
  final FavMenuCardType type;
  const FavMenuCard({
    super.key,
    required this.menuItem,
    required this.itemKey,
    required this.isclicked,
    this.type = FavMenuCardType.mobileSize,
  });

  @override
  State<FavMenuCard> createState() => _FavMenuCardState();
}

class _FavMenuCardState extends State<FavMenuCard> {
  @override
  Widget build(BuildContext context) {
    var menuData = Provider.of<MenuDataProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.all(AppSize.cardPadding),
      height: widget.type == FavMenuCardType.mobileSize
          ? (screenWidth * 0.45).clamp(110.0, 150.0)
          : 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSize.cardBorderRadius),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSize.smallCardBorderRadius),
            child: SizedBox(
              height: widget.type == FavMenuCardType.mobileSize
                  ? (screenWidth * 0.38).clamp(70.0, 130.0)
                  : 130,
              width: widget.type == FavMenuCardType.mobileSize
                  ? (screenWidth * 0.36).clamp(100.0, 160.0)
                  : 160,
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
                (widget.menuItem['selectedType'] != null &&
                        widget.menuItem['selectedType'].toString().isNotEmpty)
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
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      menuData.onFavItemRemove(widget.itemKey);
                    },
                    child: CircleAvatar(
                      backgroundColor:
                          widget.isclicked ? AppColors.appAccent : Colors.white,
                      child: Icon(
                        Icons.favorite_rounded,
                        color: widget.isclicked
                            ? Colors.white
                            : AppColors.appAccent,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
