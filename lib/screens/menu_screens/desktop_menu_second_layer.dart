import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/classes/category.dart';
import 'package:ruyi_booking/providers/menu_data_provider.dart';
import 'package:ruyi_booking/utils/colors.dart';
import 'package:ruyi_booking/widgets/cores/item_counter.dart';
import 'package:ruyi_booking/widgets/cores/menu_type_picker.dart';

class DesktopMenuSecondLayer extends StatefulWidget {
  final int selectedCategory;
  final List<Map<String, dynamic>> filteredItems;
  const DesktopMenuSecondLayer(
      {super.key, required this.filteredItems, required this.selectedCategory});

  @override
  State<DesktopMenuSecondLayer> createState() => _DesktopMenuSecondLayerState();
}

class _DesktopMenuSecondLayerState extends State<DesktopMenuSecondLayer> {
  @override
  Widget build(BuildContext context) {
    var menuData = Provider.of<MenuDataProvider>(context);
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SizedBox(child: searchBar(menuData.searchController)),
            Expanded(
              child: widget.filteredItems.isEmpty
                  ? Center(
                      child: Text(
                        'note1'.tr(),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.appAccent,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                        height: 1,
                        thickness: 1,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      itemCount: widget.filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = widget.filteredItems[index];
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
                                categories[widget.selectedCategory].name.tr(),
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
                      color: Theme.of(context).iconTheme.color,
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
                          color: Theme.of(context).iconTheme.color,
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
}
