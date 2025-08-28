import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/menu_data_provider.dart';
import 'package:ruyi_booking/screens/menus/view_menu/deskstop_view_menu_screens/desktop_view_menu_second_layer.dart';
import 'package:ruyi_booking/screens/menus/fav_menu/desktop_view_menu_third_layer.dart';
import 'package:ruyi_booking/utils/constants.dart';
import 'package:ruyi_booking/screens/menus/widgets/food_category_bar.dart';
import 'package:ruyi_booking/widgets/cores/desktop_app_bar.dart';

class DesktopViewMenuScreen extends StatefulWidget {
  const DesktopViewMenuScreen({super.key});

  @override
  State<DesktopViewMenuScreen> createState() => _DesktopViewMenuScreenState();
}

class _DesktopViewMenuScreenState extends State<DesktopViewMenuScreen> {
  int selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    var menuData = Provider.of<MenuDataProvider>(context);
    final filteredItems = menuData.getFilteredItems(selectedCategory);
    return Scaffold(
      appBar: DesktopAppBar(
        title: 'menu'.tr(),
        type: DesktopAppBarType.withBtn,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(AppSize.screenPadding,
            AppSize.screenPadding, AppSize.screenPadding, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 350,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'category_title'.tr(),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.appAccent,
                        fontFamily: 'PlayfairDisplay'),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                      child: FoodCategoryBar(
                    selectedCategory: selectedCategory,
                    onCategorySelected: (index) {
                      setState(() {
                        selectedCategory = index;
                      });
                    },
                    type: FoodCategoryBarType.vAxis,
                  )),
                ],
              ),
            ),
            const SizedBox(width: AppSize.screenPadding),
            Expanded(
              child: DesktopViewMenuSecondLayer(
                  filteredItems: filteredItems,
                  selectedCategory: selectedCategory),
            ),
            const SizedBox(width: AppSize.screenPadding),
            menuData.favItems.isNotEmpty
                ? const DesktopViewMenuThirdLayer()
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
