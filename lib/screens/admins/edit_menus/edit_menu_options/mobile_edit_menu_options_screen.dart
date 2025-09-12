import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/menu_data_provider.dart';
import 'package:ruyi_booking/screens/admins/edit_menus/edit_menu_options/widgets/dialog_add_option.dart';
import 'package:ruyi_booking/screens/admins/edit_menus/edit_menu_options/widgets/dialog_create_option.dart';
import 'package:ruyi_booking/screens/admins/edit_menus/edit_menu_options/widgets/option_text.dart';
import 'package:ruyi_booking/utils/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ruyi_booking/widgets/extras/custom_buttons.dart';
import '../../../../widgets/cores/mobile_app_bar.dart';
import '../../../menus/widgets/small_button.dart';

class MobileEditMenuOptionsScreen extends StatefulWidget {
  final String menuName;
  final Map<String, dynamic> menuOption;
  const MobileEditMenuOptionsScreen({
    super.key,
    required this.menuName,
    required this.menuOption,
  });

  @override
  State<MobileEditMenuOptionsScreen> createState() =>
      _MobileEditMenuOptionsScreenState();
}

class _MobileEditMenuOptionsScreenState
    extends State<MobileEditMenuOptionsScreen> {
  late final MenuDataProvider menuDataProvider;

  @override
  void initState() {
    super.initState();
    menuDataProvider = Provider.of<MenuDataProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MobileAppbar(title: widget.menuName.tr()),
      body: StreamBuilder<Map<String, dynamic>>(
        stream: menuDataProvider.fetchMenuOption(widget.menuName),
        builder: (context, snapshot) {
          final isInitialLoading =
              snapshot.connectionState == ConnectionState.waiting;

          final options = snapshot.data ?? {};

          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSize.screenPadding),
                child: Column(
                  children: [
                    if (options.isEmpty)
                      Center(
                        child: Text(
                          "No Menu Options found",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                  color: AppColors.appAccent,
                                  fontWeight: FontWeight.bold),
                        ),
                      ),
                    if (options.isNotEmpty)
                      ...options.entries.map((optionIndex) {
                        final key = optionIndex.key;
                        final value = optionIndex.value;
                        final type = value['type'].toString();
                        final price = value['price'];

                        return Padding(
                          padding: const EdgeInsets.only(
                              bottom: AppSize.listViewMargin),
                          child: Container(
                            padding: const EdgeInsets.all(AppSize.cardPadding),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                    AppSize.cardBorderRadius)),
                            child: Row(
                              children: [
                                Text(
                                  'Option: ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                          color: AppColors.appAccent,
                                          fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  key,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                const SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    OptionText(
                                      icon: 'assets/icons/cooking.png',
                                      label: 'Menu Method:  ',
                                      value: type.tr(),
                                    ),
                                    OptionText(
                                      icon: 'assets/icons/price.png',
                                      label: 'Menu Price:  ',
                                      value: price is String
                                          ? price.tr()
                                          : '$price',
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                SmallIconButton(
                                  icon: const Icon(Icons.remove,
                                      size: 25, color: Colors.white),
                                  onPressed: () =>
                                      menuDataProvider.removeMenuOption(
                                    context,
                                    widget.menuName,
                                    key,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ButtonUtils.forwardButton(
                            context: context,
                            width: 220,
                            label: 'Add Option',
                            fontSize: 17,
                            onPressed: () async {
                              buildAddOption(
                                context: context,
                                menuName: widget.menuName,
                                currentMethods: options,
                                type: BuildAddOptionType.mobileScreen,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ButtonUtils.forwardButton(
                            context: context,
                            width: 220,
                            label: 'Create Option',
                            fontSize: 17,
                            onPressed: () => buildCreateOption(
                              context: context,
                              menuName: widget.menuName,
                              type: BuildCreateOptionType.mobileScreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (menuDataProvider.isEditMethodLoading || isInitialLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
            ],
          );
        },
      ),
    );
  }
}
