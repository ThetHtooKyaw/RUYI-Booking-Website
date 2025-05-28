import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/classes/category.dart';
import 'package:ruyi_booking/providers/menu_data_provider.dart';
import 'package:ruyi_booking/utils/colors.dart';
import 'package:ruyi_booking/utils/menu_data.dart';
import 'package:ruyi_booking/widgets/cores/item_counter.dart';
import 'package:ruyi_booking/widgets/cores/menu_type_picker.dart';
import 'package:ruyi_booking/widgets/extras/custom_buttons.dart';
import 'package:ruyi_booking/widgets/extras/desktop_app_bar.dart';

class DesktopMenuScreen extends StatefulWidget {
  const DesktopMenuScreen({super.key});

  @override
  State<DesktopMenuScreen> createState() => _DesktopMenuScreenState();
}

class _DesktopMenuScreenState extends State<DesktopMenuScreen> {
  int selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    var menuData = Provider.of<MenuDataProvider>(context);
    final filteredItems = menuData.getFilteredItems(selectedCategory);
    return Scaffold(
      appBar: DesktopAppBar(title: 'menu'.tr(), isClickable: true),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: 300,
              height: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Category',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.appAccent,
                        fontSize: 25,
                        fontFamily: 'PlayfairDisplay'),
                  ),
                  const SizedBox(height: 10),
                  Expanded(child: foodCategoryTabs()),
                ],
              ),
            ),
            secondLayer(menuData, filteredItems, context),
            thirdLayer(menuData, context),
          ],
        ),
      ),
    );
  }

  Widget secondLayer(MenuDataProvider menuData,
      List<Map<String, dynamic>> filteredItems, BuildContext context) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SizedBox(child: searchBar(menuData.searchController)),
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
                        final item = filteredItems[index];
                        String type = menuData.itemType[item['id']] ??
                            (item['type'] is Map
                                ? item['type']['0']
                                : item['type'] ?? '');
                        String uniqueKey = '${item['id']}-$type';
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
                              height: 175,
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: SizedBox(
                                      height: 160,
                                      width: 200,
                                      child: Image.asset(
                                        item['image'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  foodInfo(
                                      context, menuData, item, uniqueKey, type),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget thirdLayer(MenuDataProvider menuData, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: 450,
      height: double.infinity,
      child: Column(
        children: [
          Text(
            'cart'.tr(),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.appAccent,
                fontSize: 25,
                fontFamily: 'PlayfairDisplay'),
          ),
          const SizedBox(height: 10),
          menuData.cartedItems.isEmpty
              ? cartEmpty(context)
              : SizedBox(
                  height: MediaQuery.of(context).size.height * 0.53,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 1),
                    itemCount: menuData.cartedItems.length,
                    itemBuilder: (context, index) {
                      final itemKey = menuData.cartedItems.keys.toList()[index];
                      final item = menuData.cartedItems[itemKey];
                      final itemDetail = menuItems.firstWhere(
                          (value) => value['id'] == item?['selectedItemId']);

                      if (item == null) return const SizedBox();

                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: SizedBox(
                                  height: 130,
                                  width: 160,
                                  child: Image.asset(
                                    itemDetail['image'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      itemDetail['name'].toString().tr(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.appAccent,
                                          ),
                                    ),
                                    const SizedBox(height: 5),
                                    item['selectedType'] != null &&
                                            item['selectedType']
                                                .toString()
                                                .isNotEmpty
                                        ? Row(
                                            children: [
                                              Image.asset(
                                                'assets/icons/cooking.png',
                                                width: 17,
                                                height: 17,
                                                color: AppColors.appAccent,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                item['selectedType']
                                                    .toString()
                                                    .tr(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
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
                                          color: AppColors.appAccent,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          menuData.onGetCartPrice(item),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ItemCounter(
                                          quantity: item['quantity'],
                                          onQuantityChanged: (newQty) {
                                            menuData.onCartItemQuantityChanged(
                                                itemKey, newQty);
                                          },
                                          onZeroQuantityReached: () =>
                                              menuData.removeFromCart(itemKey),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
          const Spacer(),
          menuData.cartedItems.isNotEmpty
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  height: 195,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10))),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          'note2'.tr(),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppColors.appAccent),
                        ),
                      ),
                      const SizedBox(height: 5),
                      priceText(
                          context,
                          'assets/icons/quantity.png',
                          'quantity'.tr(),
                          menuData.cartedItems.length.toString()),
                      // priceText(context, 'Discount', ''),
                      const Divider(thickness: 2),
                      priceText(context, 'assets/icons/price.png', 'price'.tr(),
                          menuData.calculateTotalPrice()),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                              child: ButtonUtils.forwardButton(
                                  220, 'confirm'.tr(), () {})),
                        ],
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget foodInfo(BuildContext context, MenuDataProvider menuData,
      Map<String, dynamic> item, String uniqueKey, String type) {
    int qty = menuData.itemQty[uniqueKey] ?? 0;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item['name'].toString().tr(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.appAccent,
                ),
          ),
          const SizedBox(height: 5),
          menuData.onShowPicker(item)
              ? Row(
                  children: [
                    Image.asset(
                      'assets/icons/cooking.png',
                      width: 20,
                      height: 20,
                      color: AppColors.appAccent,
                    ),
                    const SizedBox(width: 8),
                    MenuTypePicker(
                      itemID: item['id'],
                      key: ObjectKey(item['id']),
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
                          color: AppColors.appAccent,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          item['detail']?.toString().tr() ?? '',
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
                color: AppColors.appAccent,
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
                  menuData.addToCart(uniqueKey, item, menuData.priceKey(item),
                      menuData.typeKey(item), qty);
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                ),
                child: Text(
                  'cart'.tr(),
                  style: const TextStyle(fontSize: 14),
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
          return TextField(
            controller: controller,
            onChanged: (value) => menuData.setSearchQuery(value),
            decoration: InputDecoration(
              hintText: 'search'.tr(),
              prefixIcon: const Icon(Icons.search, color: AppColors.appAccent),
            ),
          );
        },
      ),
    );
  }

  Widget foodCategoryTabs() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = selectedCategory == index;
          final category = categories[index];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: GestureDetector(
              onTap: () => setState(() => selectedCategory = index),
              child: Container(
                padding: const EdgeInsets.all(10),
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
                    const SizedBox(width: 15),
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

  Widget priceText(
      BuildContext context, String icon, String text, String price) {
    return Row(
      children: [
        Image.asset(
          icon,
          width: 17,
          height: 17,
          color: AppColors.appAccent,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const Spacer(),
        Text(
          price,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget cartEmpty(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 250),
          Text(
            'note3'.tr(),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.appAccent, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'note4'.tr(),
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
