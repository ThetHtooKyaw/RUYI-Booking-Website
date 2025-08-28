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
import 'package:ruyi_booking/widgets/cores/mobile_app_bar.dart';

enum MobileAddToCartScreenType { userSite, adminSite }

class MobileAddToCartScreen extends StatefulWidget {
  final MobileAddToCartScreenType type;
  final Map<String, dynamic>? bookingData;
  const MobileAddToCartScreen({
    super.key,
    this.type = MobileAddToCartScreenType.userSite,
    this.bookingData,
  });

  @override
  State<MobileAddToCartScreen> createState() => _MobileAddToCartScreenState();
}

class _MobileAddToCartScreenState extends State<MobileAddToCartScreen> {
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

    return Scaffold(
      appBar: MobileAppbar(
        title: 'cart_title'.tr(),
        shadow: BoxShadow(
          color: Colors.black.withOpacity(_shadowOpacity),
          blurRadius: 6,
          spreadRadius: 0.6,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSize.screenPadding,
          0,
          AppSize.screenPadding,
          AppSize.screenPadding,
        ),
        child: menuData.cartedItems.isEmpty
            ? const CartEmptyTitle()
            : Stack(
                children: [
                  ListView.separated(
                    controller: _scrollController,
                    padding: EdgeInsets.only(
                        top: AppSize.screenPadding,
                        bottom:
                            widget.type == MobileAddToCartScreenType.userSite
                                ? 195
                                : 165),
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSize.listViewMargin),
                    itemCount: widget.type == MobileAddToCartScreenType.userSite
                        ? menuData.cartedItems.length
                        : widget.bookingData!['menu_list'].length,
                    itemBuilder: (context, index) {
                      final itemKey =
                          widget.type == MobileAddToCartScreenType.userSite
                              ? menuData.cartedItems.keys.toList()[index]
                              : widget.bookingData!['menu_list'].keys
                                  .toList()[index];
                      final item =
                          widget.type == MobileAddToCartScreenType.userSite
                              ? menuData.cartedItems[itemKey]
                              : widget.bookingData!['menu_list'][itemKey];

                      if (item == null) return const SizedBox();

                      return CartMenuCard(menuItem: item, itemKey: itemKey);
                    },
                  ),
                  ListViewShadow(shadowOpacity: _shadowOpacity),
                ],
              ),
      ),
      bottomSheet: widget.type == MobileAddToCartScreenType.userSite
          ? CartBottomSheet(
              cartedItems: menuData.cartedItems,
              button: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ButtonUtils.backwardButton(
                      context: context,
                      width: 220,
                      label: 'back'.tr(),
                      fontSize: 17,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ButtonUtils.forwardButton(
                      context: context,
                      width: 220,
                      label: 'confirm'.tr(),
                      fontSize: 17,
                      onPressed: () {
                        int count = 0;
                        Navigator.popUntil(context, (route) => count++ == 2);
                      },
                    ),
                  )
                ],
              ),
            )
          : CartBottomSheet(
              cartedItems: widget.bookingData!['menu_list'],
              button: Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                  )
                ],
              ),
              type: CartBottomSheetType.adminSite,
            ),
    );
  }
}
