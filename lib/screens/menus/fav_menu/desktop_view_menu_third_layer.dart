import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/menu_data_provider.dart';
import 'package:ruyi_booking/screens/menus/widgets/cart_empty_title.dart';
import 'package:ruyi_booking/screens/menus/fav_menu/widgets/fav_menu_card.dart';
import 'package:ruyi_booking/utils/constants.dart';
import 'package:ruyi_booking/widgets/cores/list_view_shadow.dart';

class DesktopViewMenuThirdLayer extends StatefulWidget {
  const DesktopViewMenuThirdLayer({super.key});

  @override
  State<DesktopViewMenuThirdLayer> createState() =>
      _DesktopViewMenuThirdLayerState();
}

class _DesktopViewMenuThirdLayerState extends State<DesktopViewMenuThirdLayer> {
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
        Text(
          'favorite'.tr(),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.appAccent, fontFamily: 'PlayfairDisplay'),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: menuData.favItems.isEmpty
              ? const CartEmptyTitle()
              : Stack(
                  children: [
                    ListView.separated(
                      controller: _scrollController,
                      padding: const EdgeInsets.only(bottom: 20),
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppSize.listViewMargin),
                      itemCount: menuData.favItems.length,
                      itemBuilder: (context, index) {
                        final itemKey =
                            menuData.favItems.keys.toList()[index];
                        bool isclicked = menuData.isClickedItem(itemKey);
                        final item = menuData.favItems[itemKey];
    
                        if (item == null) return const SizedBox();
    
                        return FavMenuCard(
                            menuItem: item,
                            itemKey: itemKey,
                            isclicked: isclicked);
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
