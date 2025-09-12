import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../providers/menu_data_provider.dart';
import '../../../../../utils/constants.dart';

class EditPriceSection extends StatelessWidget {
  final Map<String, dynamic> itemDetail;
  const EditPriceSection({super.key, required this.itemDetail});

  @override
  Widget build(BuildContext context) {
    final menuData = Provider.of<MenuDataProvider>(context);
    final bool onShowPriceString = menuData.onShowPriceString(itemDetail);

    return Row(
      children: [
        Text(
          "Menu Price:",
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(width: 10),
        onShowPriceString
            ? Text(
                menuData.priceEnController.text,
                style: Theme.of(context).textTheme.titleSmall,
              )
            : Expanded(
                child: TextField(
                  controller: menuData.priceController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    suffixIcon: menuData.isMenuLangLoading
                        ? const Padding(
                            padding: EdgeInsets.all(10),
                            child: SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.appAccent,
                              ),
                            ),
                          )
                        : null,
                  ),
                ),
              ),
      ],
    );
  }
}
