import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ruyi_booking/screens/menus/add_to_cart/widgets/cart_bottom_sheet.dart';
import 'package:ruyi_booking/screens/menus/add_to_cart/widgets/cart_menu_card.dart';
import 'package:ruyi_booking/utils/constants.dart';
import 'package:ruyi_booking/widgets/cores/list_view_shadow.dart';
import 'package:ruyi_booking/widgets/extras/custom_buttons.dart';
import 'package:ruyi_booking/widgets/cores/desktop_app_bar.dart';

class DesktopEditBookedMenuScreen extends StatefulWidget {
  final Map<String, dynamic> bookingData;
  const DesktopEditBookedMenuScreen({super.key, required this.bookingData});

  @override
  State<DesktopEditBookedMenuScreen> createState() =>
      _DesktopEditBookedMenuScreenState();
}

class _DesktopEditBookedMenuScreenState
    extends State<DesktopEditBookedMenuScreen> {
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
    final bookingData = widget.bookingData;

    return Scaffold(
      appBar: DesktopAppBar(title: 'cart_title'.tr()),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.40,
          child: Stack(
            children: [
              ListView.separated(
                controller: _scrollController,
                padding: const EdgeInsets.only(
                    top: AppSize.screenPadding, bottom: 165),
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSize.listViewMargin),
                itemCount: bookingData['menu_list'].length,
                itemBuilder: (context, index) {
                  final itemKey = bookingData['menu_list'].keys.toList()[index];
                  final item = bookingData['menu_list'][itemKey];

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
      ),
      bottomSheet: CartBottomSheet(
        cartedItems: bookingData['menu_list'],
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
