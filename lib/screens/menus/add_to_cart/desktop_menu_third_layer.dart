import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/menu_data_provider.dart';
import 'package:ruyi_booking/screens/menus/add_to_cart/widgets/cart_bottom_sheet.dart';
import 'package:ruyi_booking/screens/menus/widgets/cart_empty_title.dart';
import 'package:ruyi_booking/screens/menus/add_to_cart/widgets/cart_menu_card.dart';
import 'package:ruyi_booking/utils/constants.dart';
import 'package:ruyi_booking/widgets/cores/list_view_shadow.dart';
import 'package:ruyi_booking/widgets/extras/custom_buttons.dart';

class DesktopMenuThirdLayer extends StatefulWidget {
  const DesktopMenuThirdLayer({super.key});

  @override
  State<DesktopMenuThirdLayer> createState() => _DesktopMenuThirdLayerState();
}

class _DesktopMenuThirdLayerState extends State<DesktopMenuThirdLayer> {
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

    return SizedBox(
      width: 450,
      child: Column(
        children: [
          Text(
            'cart'.tr(),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.appAccent, fontFamily: 'PlayfairDisplay'),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: menuData.cartedItems.isEmpty
                ? const CartEmptyTitle()
                : Stack(
                    children: [
                      ListView.separated(
                        controller: _scrollController,
                        padding: const EdgeInsets.only(bottom: 20),
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppSize.listViewMargin),
                        itemCount: menuData.cartedItems.length,
                        itemBuilder: (context, index) {
                          final itemKey =
                              menuData.cartedItems.keys.toList()[index];
                          final item = menuData.cartedItems[itemKey];

                          if (item == null) return const SizedBox();

                          return CartMenuCard(
                            menuItem: item,
                            itemKey: itemKey,
                            type: CartMenuCardType.desktopSize,
                          );
                        },
                      ),
                      ListViewShadow(shadowOpacity: _shadowOpacity),
                    ],
                  ),
          ),
          menuData.cartedItems.isNotEmpty
              ? CartBottomSheet(
                  cartedItems: menuData.cartedItems,
                  button: Row(
                    children: [
                      Expanded(
                        child: ButtonUtils.forwardButton(
                          context: context,
                          width: 220,
                          label: 'confirm'.tr(),
                          fontSize: 17,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
