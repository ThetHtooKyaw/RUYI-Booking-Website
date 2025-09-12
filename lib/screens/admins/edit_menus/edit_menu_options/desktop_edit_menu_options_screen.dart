import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/menu_data_provider.dart';
import '../../../../utils/constants.dart';
import '../../../../widgets/cores/desktop_app_bar.dart';
import '../../../../widgets/extras/custom_buttons.dart';
import '../../../menus/widgets/small_button.dart';
import 'widgets/dialog_add_option.dart';
import 'widgets/dialog_create_option.dart';
import 'widgets/option_text.dart';

class DesktopEditMenuOptionsScreen extends StatefulWidget {
  final String menuName;
  final Map<String, dynamic> menuOption;
  const DesktopEditMenuOptionsScreen({
    super.key,
    required this.menuName,
    required this.menuOption,
  });

  @override
  State<DesktopEditMenuOptionsScreen> createState() =>
      _DesktopEditMenuOptionsScreenState();
}

class _DesktopEditMenuOptionsScreenState
    extends State<DesktopEditMenuOptionsScreen> {
  late final MenuDataProvider menuDataProvider;

  @override
  void initState() {
    super.initState();
    menuDataProvider = Provider.of<MenuDataProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DesktopAppBar(
        title: widget.menuName.tr(),
        type: DesktopAppBarType.withBtn,
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.40,
          child: StreamBuilder<Map<String, dynamic>>(
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
                                padding:
                                    const EdgeInsets.all(AppSize.cardPadding),
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
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    const SizedBox(width: 20),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                    type: BuildAddOptionType.desktopScreen,
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
                                  type: BuildCreateOptionType.desktopScreen,
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
        ),
      ),
    );
  }
}
