import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/classes/category.dart';
import 'package:ruyi_booking/providers/menu_data_provider.dart';
import 'package:ruyi_booking/screens/menu_screens/desktop_menu_screen/desktop_menu_second_layer.dart';
import 'package:ruyi_booking/screens/menu_screens/desktop_menu_screen/desktop_menu_third_layer.dart';
import 'package:ruyi_booking/screens/view_menu_screens/deskstop_menu_view/desktop_view_menu_third_layer.dart';
import 'package:ruyi_booking/utils/colors.dart';
import 'package:ruyi_booking/widgets/cores/main_logo.dart';

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
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 85,
        leadingWidth: 200,
        leading: Padding(
          padding: const EdgeInsets.only(left: 40),
          child: Center(
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.keyboard_arrow_left_rounded,
                    size: 55,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
                const SizedBox(width: 20),
                const MainLogo(
                  height: 55,
                  width: 55,
                  isClickable: false,
                ),
              ],
            ),
          ),
        ),
        title: Text(
          'menu'.tr(),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 30,
                color: AppColors.appAccent,
                fontFamily: 'PlayfairDisplay',
              ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10, left: 10),
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
                    'category'.tr(),
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
            DesktopMenuSecondLayer(
              filteredItems: filteredItems,
              selectedCategory: selectedCategory,
            ),
            menuData.isClicked
                ? menuData.favItems.isNotEmpty
                    ? const DesktopViewMenuThirdLayer()
                    : const SizedBox()
                : menuData.cartedItems.isNotEmpty
                    ? const DesktopMenuThirdLayer()
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
