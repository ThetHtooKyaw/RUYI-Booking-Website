import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/classes/category.dart';
import 'package:ruyi_booking/providers/menu_data_provider.dart';
import 'package:ruyi_booking/screens/menus/menu/widgets/menu_card.dart';
import 'package:ruyi_booking/utils/constants.dart';
import 'package:ruyi_booking/screens/menus/widgets/search_bar.dart';
import 'package:ruyi_booking/widgets/cores/list_view_shadow.dart';

class DesktopMenuSecondLayer extends StatefulWidget {
  final int selectedCategory;
  final List<Map<String, dynamic>> filteredItems;
  const DesktopMenuSecondLayer(
      {super.key, required this.filteredItems, required this.selectedCategory});

  @override
  State<DesktopMenuSecondLayer> createState() => _DesktopMenuSecondLayerState();
}

class _DesktopMenuSecondLayerState extends State<DesktopMenuSecondLayer> {
  final ScrollController _scrollController = ScrollController();
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

    return Column(
      children: [
        CustomSearchBar(
          controller: menuData.searchController,
          onSearch: (value) => menuData.setSearchQuery(value),
          type: CustomSearchBarType.dynamicIcon,
        ),
        const SizedBox(height: 10),
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
              : Stack(
                  children: [
                    ListView.separated(
                      controller: _scrollController,
                      padding: const EdgeInsets.only(bottom: 20),
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppSize.listViewMargin - 6),
                      itemCount: widget.filteredItems.length,
                      itemBuilder: (context, index) {
                        final items = widget.filteredItems[index];
                        String selectedType = menuData.typeKey(items) ?? 'N/A';
                        String uniqueKey = '${items['id']}-$selectedType';
                        menuData.itemQty.putIfAbsent(uniqueKey, () => 0);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (index == 0)
                              Text(
                                categories[widget.selectedCategory].name.tr(),
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
        ),
      ],
    );
  }
}
