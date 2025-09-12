import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/menu_data_provider.dart';
import 'package:ruyi_booking/screens/menus/widgets/small_button.dart';
import 'package:ruyi_booking/utils/constants.dart';

enum BuildAddMethodType { mobileScreen, desktopScreen }

Future<dynamic> buildAddMethod({
  required BuildContext context,
  required String menuName,
  type = BuildAddMethodType.mobileScreen,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return Consumer<MenuDataProvider>(builder: (context, menuData, _) {
        return StreamBuilder(
            stream: menuData.fetchMenuMethodsStream(),
            builder: (context, snapshot) {
              final isInitialLoading =
                  snapshot.connectionState == ConnectionState.waiting;
              final menuMethods = snapshot.data ?? [];

              return Dialog(
                backgroundColor: AppColors.appBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSize.cardBorderRadius),
                ),
                child: SizedBox(
                  width: type == BuildAddMethodType.mobileScreen
                      ? MediaQuery.of(context).size.width * 0.90
                      : MediaQuery.of(context).size.width * 0.40,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(AppSize.cardPadding),
                        child: ListView.separated(
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: AppSize.listViewMargin),
                          itemCount: menuMethods.length,
                          itemBuilder: (context, index) {
                            final menuMethod = menuMethods[index];
                            final methodName = menuMethod['id'].toString().tr();

                            return Container(
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
                                      SmallButton(
                                        label: 'Add Method',
                                        onPressed: () => menuData.addMenuMethod(
                                          context,
                                          menuName,
                                          menuMethod['id'],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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
            });
      });
    },
  );
}
