import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/menu_data_provider.dart';
import 'package:ruyi_booking/utils/colors.dart';
import 'package:ruyi_booking/widgets/cores/item_counter.dart';
import 'package:ruyi_booking/widgets/extras/custom_buttons.dart';
import 'package:ruyi_booking/widgets/extras/mobile_app_bar.dart';

class MobileAdminMenuListScreen extends StatefulWidget {
  final Map<String, dynamic> bookingData;
  const MobileAdminMenuListScreen({super.key, required this.bookingData});

  @override
  State<MobileAdminMenuListScreen> createState() =>
      _MobileAdminMenuListScreenState();
}

class _MobileAdminMenuListScreenState extends State<MobileAdminMenuListScreen> {
  @override
  Widget build(BuildContext context) {
    final bookingData = widget.bookingData;
    var menuData = Provider.of<MenuDataProvider>(context);

    return Scaffold(
      appBar: MobileAppbar(title: 'cart_title'.tr()),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView.builder(
          padding: const EdgeInsets.only(bottom: 160),
          itemCount: bookingData['menu_list'].length,
          itemBuilder: (context, index) {
            final itemKey = bookingData['menu_list'].keys.toList()[index];
            final item = bookingData['menu_list'][itemKey];

            if (item == null) return const SizedBox();

            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: SizedBox(
                        height: 130,
                        width: 160,
                        child: Image.asset(
                          item['itemImage'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['itemName'].toString().tr(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.appAccent,
                                ),
                          ),
                          const SizedBox(height: 5),
                          item['selectedType'] != null &&
                                  item['selectedType'].toString().isNotEmpty
                              ? Row(
                                  children: [
                                    Image.asset(
                                      'assets/icons/cooking.png',
                                      width: 17,
                                      height: 17,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      item['selectedType'].toString().tr(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ],
                                )
                              : const SizedBox(),
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
                                menuData.onGetCartPrice(item),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ItemCounter(
                                quantity: item['quantity'],
                                onQuantityChanged: (newQty) {
                                  menuData.updateCartItemQty(
                                      bookingData, itemKey, newQty);
                                },
                                onZeroQuantityReached: () => menuData
                                    .removeCartItem(bookingData, itemKey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        height: 155,
        width: double.infinity,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
        child: Column(
          children: [
            const SizedBox(height: 10),
            priceText(context, 'assets/icons/quantity.png', 'quantity'.tr(),
                bookingData['menu_list'].length.toString()),
            // priceText(context, 'Discount', ''),
            const Divider(thickness: 2),
            priceText(context, 'assets/icons/price.png', 'price'.tr(),
                menuData.calculateTotalPrice(bookingData['menu_list'])),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ButtonUtils.forwardButton(220, 'confirm'.tr(), () {
                    Navigator.pop(context);
                  }, 17),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget priceText(
      BuildContext context, String icon, String text, String price) {
    return Row(
      children: [
        Image.asset(
          icon,
          width: 17,
          height: 17,
          color: Theme.of(context).iconTheme.color,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const Spacer(),
        Text(
          price,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
