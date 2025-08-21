import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/classes/category.dart';
import 'package:ruyi_booking/providers/menu_data_provider.dart';
import 'package:ruyi_booking/screens/view_menu_screens/mobile_menu_view/mobile_view_menu_fav_screen.dart';
import 'package:ruyi_booking/utils/colors.dart';

import 'package:ruyi_booking/widgets/cores/type_section.dart';
import 'package:ruyi_booking/widgets/extras/mobile_app_bar.dart';

class MobileViewMenuScreen extends StatefulWidget {
  const MobileViewMenuScreen({super.key});

  @override
  State<MobileViewMenuScreen> createState() => _MobileViewMenuScreenState();
}

class _MobileViewMenuScreenState extends State<MobileViewMenuScreen> {
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
                        String selectedType = menuData.typeKey(items) ?? 'N/A';
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                  const SizedBox(width: 15),
                                  foodInfo(context, menuData, items, uniqueKey),
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
    );
  }

  Widget foodInfo(
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
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                style: Theme.of(context).textTheme.bodyMedium,
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
