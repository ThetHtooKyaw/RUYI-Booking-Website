import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/classes/category.dart';
import 'package:ruyi_booking/providers/menu_data_provider.dart';
import 'package:ruyi_booking/screens/menu_screens/mobile_menu_screen/mobile_add_to_cart_screen.dart';
import 'package:ruyi_booking/screens/view_menu_screens/mobile_menu_view/mobile_view_menu_fav_screen.dart';
import 'package:ruyi_booking/utils/colors.dart';
import 'package:ruyi_booking/widgets/cores/item_counter.dart';
import 'package:ruyi_booking/widgets/cores/menu_type_picker.dart';
import 'package:ruyi_booking/widgets/extras/custom_buttons.dart';
import 'package:ruyi_booking/widgets/extras/mobile_app_bar.dart';

class MobileMenuScreen extends StatefulWidget {
  const MobileMenuScreen({super.key});

  @override
  State<MobileMenuScreen> createState() => _MobileMenuScreenState();
}

class _MobileMenuScreenState extends State<MobileMenuScreen> {
  int selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    var menuData = Provider.of<MenuDataProvider>(context);
    final filteredItems = menuData.getFilteredItems(selectedCategory);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: MobileAppbar(title: 'menu'.tr()),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              child: Column(
                children: [
                  searchBar(menuData.searchController),
                  foodCategoryTabs(),
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
                  : ListView.separated(
                      separatorBuilder: (context, index) => const Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.appAccent,
                      ),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final items = filteredItems[index];
                        final options =
                            (items['options'] as Map<String, dynamic>?) ?? {};
                        String type = options.isNotEmpty
                            ? options.values.first['type'] ?? 'N/A'
                            : 'N/A';
                        String uniqueKey = '${items['id']}-$type';
                        menuData.itemQty.putIfAbsent(uniqueKey, () => 0);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (index == 0)
                              Text(
                                categories[selectedCategory].name.tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                        color: AppColors.appAccent,
                                        fontSize: 25,
                                        fontFamily: 'PlayfairDisplay'),
                              ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              height: (screenWidth * 0.45).clamp(130.0, 178.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: SizedBox(
                                      height: (screenWidth * 0.38)
                                          .clamp(100.0, 160.0),
                                      width: (screenWidth * 0.36)
                                          .clamp(110.0, 170.0),
                                      child: Image.asset(
                                        items['image'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: screenWidth < 430 ? 10 : 15),
                                  foodInfo(context, menuData, items, uniqueKey,
                                      type),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            )
          ],
        ),
      ),
      bottomSheet: menuData.cartedItems.isNotEmpty
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              height: 65,
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(10))),
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  ButtonUtils.forwardButton(
                      context, double.infinity, 'view_cart'.tr(), () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const MobileAddToCartScreen();
                    }));
                  }, screenWidth < 430 ? 12.0 : 14.0),
                  Positioned(
                    right: 5,
                    child: Container(
                      height: screenWidth < 430 ? 30.0 : 32.0,
                      width: screenWidth < 430 ? 30.0 : 35.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
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

  Widget foodInfo(BuildContext context, MenuDataProvider menuData,
      Map<String, dynamic> item, String uniqueKey, String type) {
    int qty = menuData.itemQty[uniqueKey] ?? 0;
    final screenWidth = MediaQuery.of(context).size.width;
    final options = item['options'] as Map<String, dynamic>? ?? {};

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item['name'].toString().tr(),
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.appAccent,
                ),
          ),
          const SizedBox(height: 5),
          options.length > 1
              ? Row(
                  children: [
                    Image.asset(
                      'assets/icons/cooking.png',
                      width: 20,
                      height: 20,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    const SizedBox(width: 8),
                    MenuTypePicker(
                      itemId: item['id'],
                      itemOptions: options,
                      key: ObjectKey(item['id']),
                    ),
                  ],
                )
              : (options.values.first['type'] != null && options.length == 1)
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
                          options.values.first['type']?.toString().tr() ??
                              'N/A',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    )
                  : item['id'] == '22'
                      ? Row(
                          children: [
                            Image.asset(
                              'assets/icons/detail.png',
                              width: 17,
                              height: 17,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              item['detail']?.toString().tr() ?? 'N/A',
                              style: Theme.of(context).textTheme.bodyMedium,
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
                menuData.onGetPrice(item),
                style: Theme.of(context).textTheme.bodyMedium,
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
              ElevatedButton(
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
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: (screenWidth * 0.04).clamp(6.0, 20.0),
                    horizontal: (screenWidth * 0.02).clamp(4.0, 10.0),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                ),
                child: Text(
                  'cart'.tr(),
                  style: TextStyle(
                      fontSize:
                          MediaQuery.of(context).size.width < 430 ? 12 : 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget searchBar(controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Consumer<MenuDataProvider>(
        builder: (context, menuData, _) {
          return Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: controller,
                  onChanged: (value) => menuData.setSearchQuery(value),
                  decoration: InputDecoration(
                    hintText: 'search'.tr(),
                    prefixIcon: Icon(Icons.search,
                        color: Theme.of(context).iconTheme.color),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const MobileViewMenuFavScreen();
                      }));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Icon(
                        Icons.favorite_rounded,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                  ),
                  menuData.favItems.isNotEmpty
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
              ),
            ],
          );
        },
      ),
    );
  }

  Widget foodCategoryTabs() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = selectedCategory == index;
          final category = categories[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: GestureDetector(
              onTap: () => setState(() => selectedCategory = index),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.appAccent : Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      category.icon,
                      width: 17,
                      height: 17,
                      color: isSelected ? Colors.white : AppColors.appAccent,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      category.name.tr(),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
