import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/classes/category.dart';
import 'package:ruyi_booking/providers/menu_data_provider.dart';
import 'package:ruyi_booking/screens/menus/add_to_cart/add_to_cart_screen.dart';
import 'package:ruyi_booking/screens/menus/menu/widgets/menu_card.dart';

import 'package:ruyi_booking/utils/constants.dart';
import 'package:ruyi_booking/screens/menus/widgets/food_category_bar.dart';
import 'package:ruyi_booking/screens/menus/widgets/search_bar.dart';
import 'package:ruyi_booking/widgets/cores/list_view_shadow.dart';
import 'package:ruyi_booking/widgets/extras/custom_buttons.dart';
import 'package:ruyi_booking/widgets/cores/mobile_app_bar.dart';

class MobileMenuScreen extends StatefulWidget {
  const MobileMenuScreen({super.key});

  @override
  State<MobileMenuScreen> createState() => _MobileMenuScreenState();
}

class _MobileMenuScreenState extends State<MobileMenuScreen> {
  final ScrollController _scrollController = ScrollController();
  int selectedCategory = 0;
  double _shadowOpacity = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final offSet = _scrollController.offset;
      setState(() {
        _shadowOpacity = (offSet / 50).clamp(0.0, 0.3);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var menuData = Provider.of<MenuDataProvider>(context);
    final filteredItems = menuData.getFilteredItems(selectedCategory);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: MobileAppbar(title: 'menu'.tr()),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(AppSize.screenPadding,
            AppSize.screenPadding, AppSize.screenPadding, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              child: Column(
                children: [
                  CustomSearchBar(
                      controller: menuData.searchController,
                      onSearch: (value) => menuData.setSearchQuery(value)),
                  const SizedBox(height: 10),
                  FoodCategoryBar(
                    selectedCategory: selectedCategory,
                    onCategorySelected: (index) {
                      setState(() {
                        selectedCategory = index;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: filteredItems.isEmpty
                  ? Center(
                      child: Text(
                        'note1'.tr(),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.appAccent,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : Stack(
                      children: [
                        ListView.separated(
                          controller: _scrollController,
                          padding: const EdgeInsets.only(bottom: 20),
                          separatorBuilder: (_, __) => const SizedBox(
                              height: AppSize.listViewMargin - 6),
                          itemCount: filteredItems.length,
                          itemBuilder: (context, index) {
                            final items = filteredItems[index];
                            String selectedType =
                                menuData.typeKey(items) ?? 'N/A';
                            String uniqueKey = '${items['id']}-$selectedType';
                            menuData.itemQty.putIfAbsent(uniqueKey, () => 0);

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (index == 0)
                                  Text(
                                    categories[selectedCategory].name.tr(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                            color: AppColors.appAccent,
                                            fontFamily: 'PlayfairDisplay'),
                                  ),
                                const SizedBox(height: 10),
                                MenuCard(menuItem: items, uniqueKey: uniqueKey),
                              ],
                            );
                          },
                        ),
                        ListViewShadow(shadowOpacity: _shadowOpacity),
                      ],
                    ),
            )
          ],
        ),
      ),
      bottomSheet: menuData.cartedItems.isNotEmpty
          ? Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSize.screenPadding,
                  vertical: AppSize.screenPadding - 4),
              height: 65,
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
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  ButtonUtils.forwardButton(
                    context: context,
                    width: double.infinity,
                    label: 'view_cart'.tr(),
                    fontSize: screenWidth < 430 ? 12.0 : 14.0,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const AddToCartScreen();
                      }));
                    },
                  ),
                  Positioned(
                    right: 5,
                    child: Container(
                      height: screenWidth < 430 ? 28.0 : 30.0,
                      width: screenWidth < 430 ? 30.0 : 32.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                            AppSize.smallCardBorderRadius),
                      ),
                      child: Center(
                        child: Text(
                          menuData.cartedItems.length.toString(),
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.appAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
