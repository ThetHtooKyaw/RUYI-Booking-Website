import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/menu_data_provider.dart';
import 'package:ruyi_booking/screens/menus/widgets/food_category_bar.dart';
import 'package:ruyi_booking/utils/constants.dart';
import '../edit_menu_detail/edit_menu_detail_screen.dart';

class DesktopEditMenuListScreen extends StatefulWidget {
  const DesktopEditMenuListScreen({super.key});

  @override
  State<DesktopEditMenuListScreen> createState() =>
      _DesktopEditMenuListScreenState();
}

class _DesktopEditMenuListScreenState extends State<DesktopEditMenuListScreen> {
  int selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    var menuData = Provider.of<MenuDataProvider>(context);
    final filteredItems = menuData.getFilteredItems(selectedCategory);

    return Scaffold(
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
              child: filteredItems.isEmpty
                  ? Center(
                      child: Text(
                        'note1'.tr(),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.appAccent,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: AppSize.listViewMargin + 6,
                        mainAxisSpacing: AppSize.listViewMargin + 6,
                      ),
                      shrinkWrap: true,
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return EditMenuDetailScreen(
                                itemDetail: item,
                              );
                            }));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                  AppSize.cardBorderRadius),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      AppSize.cardBorderRadius),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 160,
                                    child: Hero(
                                      tag: 'hero-image-${item['image']}',
                                      child: Image.asset(
                                        item['image'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: AppSize.cardPadding),
                                  child: Text(
                                    item['name'].toString().tr(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.appAccent,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
