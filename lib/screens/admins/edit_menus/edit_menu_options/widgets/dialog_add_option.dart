import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/menu_data_provider.dart';
import 'package:ruyi_booking/screens/admins/edit_menus/edit_menu_options/widgets/edit_text_form_field.dart';
import '../../../../../utils/constants.dart';
import '../../../../menus/widgets/small_button.dart';

enum BuildAddOptionType { mobileScreen, desktopScreen }

Future<dynamic> buildAddOption({
  required BuildContext context,
  required String menuName,
  required Map<String, dynamic> currentMethods,
  type = BuildAddOptionType.mobileScreen,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return Consumer<MenuDataProvider>(
        builder: (context, menuData, _) =>
            StreamBuilder<List<Map<String, dynamic>>>(
          stream: menuData.fetchMenuMethodsStream(),
          builder: (context, snapshot) {
            final isInitialLoading =
                snapshot.connectionState == ConnectionState.waiting;
            final menuMethods = snapshot.data ?? [];
            final newMethods = menuMethods.where((method) {
              final methodName = method['id'].toString().tr();
              return !currentMethods.values.any(
                  (method) => methodName == method['type'].toString().tr());
            }).toList();

            return Dialog(
              backgroundColor: AppColors.appBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.cardBorderRadius),
              ),
              child: SizedBox(
                width: type == BuildAddOptionType.mobileScreen
                    ? MediaQuery.of(context).size.width * 0.90
                    : MediaQuery.of(context).size.width * 0.40,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(AppSize.cardPadding),
                      child: ListView.separated(
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppSize.listViewMargin),
                        itemCount: newMethods.length,
                        itemBuilder: (context, index) {
                          final menuMethod = newMethods[index];
                          final methodName = menuMethod['id'].toString().tr();
                          final isClicked = menuData.clickedIndex == index;

                          return GestureDetector(
                            onTap: () => menuData.setClickedIndex(index),
                            child: Container(
                              padding:
                                  const EdgeInsets.all(AppSize.cardPadding),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                    AppSize.cardBorderRadius),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Method Key:  ',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge
                                                      ?.copyWith(
                                                        color:
                                                            AppColors.appAccent,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    menuMethod['id'],
                                                    maxLines: 2,
                                                    softWrap: false,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Text(
                                                  'Method Name:  ',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge
                                                      ?.copyWith(
                                                        color:
                                                            AppColors.appAccent,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    methodName,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    softWrap: false,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SmallIconButton(
                                        icon: const Icon(Icons.remove,
                                            size: 25, color: Colors.white),
                                        onPressed: () =>
                                            menuData.removeMenuMethod(
                                          context,
                                          menuName,
                                          menuMethod['id'],
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (isClicked) const SizedBox(height: 10),
                                  if (isClicked)
                                    Form(
                                      key: menuData.addMethodKey,
                                      child: Row(
                                        children: [
                                          Text(
                                            'Add Price:  ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  color: AppColors.appAccent,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          Expanded(
                                            child: EditTextFormField(
                                              controller:
                                                  menuData.addPriceController,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Price is required';
                                                }

                                                return null;
                                              },
                                              hintText: 'Enter method price',
                                              bgColor: AppColors.appCardFg,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          SmallButton(
                                            label: 'Add',
                                            onPressed: () =>
                                                menuData.addMenuOption(
                                              context,
                                              menuName,
                                              menuMethod['id'],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  else
                                    const SizedBox(),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    if (menuData.isDialogLoading || isInitialLoading)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black.withOpacity(0.3),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
