import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/classes/category.dart';
import 'package:ruyi_booking/providers/menu_data_provider.dart';
import 'package:ruyi_booking/screens/view_menu_screens/desktop_view_menu_second_layer.dart';
import 'package:ruyi_booking/screens/view_menu_screens/desktop_view_menu_third_layer.dart';
import 'package:ruyi_booking/utils/colors.dart';
import 'package:ruyi_booking/widgets/extras/desktop_app_bar.dart';

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
      appBar: DesktopAppBar(title: 'menu'.tr(), isClickable: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: 350,
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
            DesktopViewMenuSecondLayer(
                filteredItems: filteredItems,
                selectedCategory: selectedCategory),
            menuData.favItems.isNotEmpty
                ? const DesktopViewMenuThirdLayer()
                : const SizedBox(),
          ],
        ),
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
}
