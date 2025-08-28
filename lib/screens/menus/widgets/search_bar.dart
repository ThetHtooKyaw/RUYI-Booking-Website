import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/menu_data_provider.dart';
import 'package:ruyi_booking/screens/menus/fav_menu/fav_menu_screen.dart';
import 'package:ruyi_booking/utils/constants.dart';

enum CustomSearchBarType { constantIcon, dynamicIcon }

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSearch;
  final CustomSearchBarType type;
  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
    this.type = CustomSearchBarType.constantIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuDataProvider>(
      builder: (context, menuData, _) {
        return Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: controller,
                onChanged: onSearch,
                decoration: InputDecoration(
                  hintText: 'search'.tr(),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            type == CustomSearchBarType.constantIcon
                ? _buildIconBox(
                    context: context,
                    menuData: menuData,
                    data: menuData.favItems,
                    icon: Icon(
                      Icons.favorite_rounded,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const FavMenuScreen();
                      }));
                    },
                  )
                : menuData.isClicked
                    ? _buildIconBox(
                        context: context,
                        menuData: menuData,
                        data: menuData.cartedItems,
                        icon: Image.asset(
                          'assets/icons/cart.png',
                          height: 23,
                          width: 24,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        onTap: () => menuData.isClickedIcon(),
                      )
                    : _buildIconBox(
                        context: context,
                        menuData: menuData,
                        data: menuData.favItems,
                        icon: Icon(
                          Icons.favorite_rounded,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        onTap: () => menuData.isClickedIcon(),
                      )
          ],
        );
      },
    );
  }

  Widget _buildIconBox({
    required BuildContext context,
    required MenuDataProvider menuData,
    required Map<String, Map<String, dynamic>> data,
    required Widget icon,
    required VoidCallback onTap,
  }) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(AppSize.cardPadding - 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(AppSize.smallCardBorderRadius),
            ),
            child: icon,
          ),
        ),
        data.isNotEmpty
            ? Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 8,
                  backgroundColor: AppColors.appAccent,
                  child: Text(
                    menuData.favItems.length.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.white),
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
