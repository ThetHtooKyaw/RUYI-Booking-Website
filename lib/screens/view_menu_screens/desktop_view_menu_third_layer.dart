import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/menu_data_provider.dart';
import 'package:ruyi_booking/utils/colors.dart';
import 'package:ruyi_booking/utils/menu_data.dart';

class DesktopViewMenuThirdLayer extends StatefulWidget {
  const DesktopViewMenuThirdLayer({super.key});

  @override
  State<DesktopViewMenuThirdLayer> createState() =>
      _DesktopViewMenuThirdLayerState();
}

class _DesktopViewMenuThirdLayerState extends State<DesktopViewMenuThirdLayer> {
  @override
  Widget build(BuildContext context) {
    var menuData = Provider.of<MenuDataProvider>(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: 450,
      height: double.infinity,
      child: Column(
        children: [
          Text(
            'favorite'.tr(),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.appAccent,
                fontSize: 25,
                fontFamily: 'PlayfairDisplay'),
          ),
          const SizedBox(height: 10),
          menuData.favItems.isEmpty
              ? cartEmpty(context)
              : SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 1),
                    itemCount: menuData.favItems.length,
                    itemBuilder: (context, index) {
                      final itemKey = menuData.favItems.keys.toList()[index];
                      bool isclicked = menuData.isClickedItem(itemKey);
                      final item = menuData.favItems[itemKey];
                      final itemDetail = menuItems.firstWhere(
                          (value) => value['id'] == item?['selectedItemId']);

                      if (item == null) return const SizedBox();

                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
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
                                    itemDetail['image'],
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
                                      itemDetail['name'].toString().tr(),
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
                                            item['selectedType']
                                                .toString()
                                                .isNotEmpty
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
                                          color:
                                              Theme.of(context).iconTheme.color,
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
                                          menuData.onFavItemAdd(
                                              itemKey,
                                              item,
                                              menuData.priceKey(item),
                                              menuData.typeKey(item));
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
        ],
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
          color: AppColors.appAccent,
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
