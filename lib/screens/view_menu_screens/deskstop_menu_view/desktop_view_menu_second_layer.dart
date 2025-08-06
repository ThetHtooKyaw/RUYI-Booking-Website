import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/classes/category.dart';
import 'package:ruyi_booking/providers/menu_data_provider.dart';
import 'package:ruyi_booking/utils/colors.dart';
import 'package:ruyi_booking/widgets/cores/menu_type_picker.dart';

class DesktopViewMenuSecondLayer extends StatefulWidget {
  final int selectedCategory;
  final List<Map<String, dynamic>> filteredItems;
  const DesktopViewMenuSecondLayer(
      {super.key, required this.filteredItems, required this.selectedCategory});

  @override
  State<DesktopViewMenuSecondLayer> createState() =>
      _DesktopViewMenuSecondLayerState();
}

class _DesktopViewMenuSecondLayerState
    extends State<DesktopViewMenuSecondLayer> {
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
                      separatorBuilder: (context, index) => const Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.appAccent,
                      ),
                      itemCount: widget.filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = widget.filteredItems[index];
                        String type = menuData.itemType[item['id']] ??
                            (item['type'] is Map
                                ? item['type'].isEmpty
                                    ? ''
                                    : item['type']['0']
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
    bool isclicked = menuData.isClickedItem(uniqueKey);

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
                      itemId: item['id'],
                      itemType: item['type'],
                      key: ObjectKey(item['id']),
                    ),
                  ],
                )
              : (item['type'].length == 1)
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
                          item['type'].values.first?.toString().tr() ?? '',
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
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                menuData.onFavItemAdd(
                  uniqueKey,
                  item,
                  menuData.priceKey(item),
                  menuData.typeKey(item),
                );
              },
              child: CircleAvatar(
                backgroundColor: isclicked ? AppColors.appAccent : Colors.white,
                child: Icon(
                  Icons.favorite_rounded,
                  color: isclicked ? Colors.white : AppColors.appAccent,
                ),
              ),
            ),
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
                  Container(
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
}
