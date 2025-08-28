import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/menu_data_provider.dart';
import 'package:ruyi_booking/screens/menus/widgets/cart_empty_title.dart';
import 'package:ruyi_booking/screens/menus/fav_menu/widgets/fav_menu_card.dart';
import 'package:ruyi_booking/utils/constants.dart';
import 'package:ruyi_booking/widgets/extras/custom_buttons.dart';
import 'package:ruyi_booking/widgets/cores/mobile_app_bar.dart';

class MobileFavMenuScreen extends StatefulWidget {
  const MobileFavMenuScreen({super.key});

  @override
  State<MobileFavMenuScreen> createState() => _MobileFavMenuScreenState();
}

class _MobileFavMenuScreenState extends State<MobileFavMenuScreen> {
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
        title: 'favorite'.tr(),
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
        child: menuData.favItems.isEmpty
            ? const CartEmptyTitle()
            : ListView.separated(
                controller: _scrollController,
                padding: const EdgeInsets.only(
                    top: AppSize.screenPadding, bottom: 65),
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSize.listViewMargin),
                itemCount: menuData.favItems.length,
                itemBuilder: (context, index) {
                  final itemKey = menuData.favItems.keys.toList()[index];
                  bool isclicked = menuData.isClickedItem(itemKey);
                  final item = menuData.favItems[itemKey];

                  if (item == null) return const SizedBox();

                  return FavMenuCard(
                      menuItem: item, itemKey: itemKey, isclicked: isclicked);
                },
              ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSize.screenPadding,
            vertical: AppSize.screenPadding - 4),
        height: 65,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSize.cardBorderRadius)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, -3),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ButtonUtils.forwardButton(
                context: context,
                width: 220,
                label: 'back'.tr(),
                fontSize: 17,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
