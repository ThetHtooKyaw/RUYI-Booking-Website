import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/menu_data_provider.dart';
import 'package:ruyi_booking/utils/colors.dart';
import 'package:ruyi_booking/widgets/extras/custom_buttons.dart';
import 'package:ruyi_booking/widgets/extras/mobile_app_bar.dart';

class MobileViewMenuFavScreen extends StatefulWidget {
  const MobileViewMenuFavScreen({super.key});

  @override
  State<MobileViewMenuFavScreen> createState() =>
      _MobileViewMenuFavScreenState();
}

class _MobileViewMenuFavScreenState extends State<MobileViewMenuFavScreen> {
  @override
  Widget build(BuildContext context) {
    var menuData = Provider.of<MenuDataProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: MobileAppbar(title: 'favorite'.tr()),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: menuData.favItems.isEmpty
            ? cartEmpty(context)
            : ListView.builder(
                padding: const EdgeInsets.only(bottom: 205),
                itemCount: menuData.favItems.length,
                itemBuilder: (context, index) {
                  final itemKey = menuData.favItems.keys.toList()[index];
                  bool isclicked = menuData.isClickedItem(itemKey);
                  final item = menuData.favItems[itemKey];

                  if (item == null) return const SizedBox();

                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      height: (screenWidth * 0.45).clamp(110.0, 150.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: SizedBox(
                              height: (screenWidth * 0.38).clamp(70.0, 130.0),
                              width: (screenWidth * 0.36).clamp(100.0, 160.0),
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
                                (item['selectedType'] != null &&
                                        item['selectedType']
                                            .toString()
                                            .isNotEmpty)
                                    ? Row(
                                        children: [
                                          Image.asset(
                                            'assets/icons/cooking.png',
                                            width: 17,
                                            height: 17,
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            item['selectedType']
                                                .toString()
                                                .tr(),
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      menuData.onFavItemRemove(itemKey);
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: isclicked
                                          ? AppColors.appAccent
                                          : Colors.white,
                                      child: Icon(
                                        Icons.favorite_rounded,
                                        color: isclicked
                                            ? Colors.white
                                            : AppColors.appAccent,
                                      ),
                                    ),
                                  ),
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
        height: 65,
        width: double.infinity,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ButtonUtils.forwardButton(context, 220, 'back'.tr(), () {
                Navigator.pop(context);
              }, 17),
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

  Widget cartEmpty(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 250),
          Text(
            'note3'.tr(),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.appAccent, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'note4'.tr(),
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
