import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/menu_data_provider.dart';
import 'package:ruyi_booking/utils/constants.dart';
import 'package:ruyi_booking/widgets/extras/custom_buttons.dart';
import 'widgets/edit_price_section.dart';
import 'widgets/edit_type_section.dart';
import 'widgets/edit_name_category_section.dart';

class MobileEditMenuDetailScreen extends StatefulWidget {
  final Map<String, dynamic> itemDetail;
  const MobileEditMenuDetailScreen({super.key, required this.itemDetail});

  @override
  State<MobileEditMenuDetailScreen> createState() =>
      _MobileEditMenuDetailScreenState();
}

class _MobileEditMenuDetailScreenState
    extends State<MobileEditMenuDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final menuData = Provider.of<MenuDataProvider>(context, listen: false);
      setState(() {
        menuData.isMenuDetailLoading = true;
      });
      await menuData.loadTranslations(widget.itemDetail);
      setState(() {
        menuData.isMenuDetailLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final itemDetail = widget.itemDetail;

    return Scaffold(
      body: Consumer<MenuDataProvider>(
        builder: (context, menuData, child) {
          if (menuData.isMenuDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final options = itemDetail['options'] as Map<String, dynamic>?;
          final hasOptionType = options != null &&
              options.values.any((option) {
                final optionsMap = option as Map<String, dynamic>?;
                return optionsMap?['type'] != null;
              });

          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    buildHeadImage(context),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSize.screenPadding),
                      child: EditNameCategorySection(
                        textName: "Menu Name:",
                        enController: menuData.nameEnController,
                        zhController: menuData.nameZhController,
                        myController: menuData.nameMyController,
                      ),
                    ),
                    buildDivider(),
                    hasOptionType
                        ? Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: AppSize.screenPadding),
                                child: EditTypeSection(
                                  itemDetail: itemDetail,
                                  options: options,
                                ),
                              ),
                            ],
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSize.screenPadding),
                            child: EditAddTypeSection(
                              itemDetail: itemDetail,
                              type: EditAddTypeSectionType.mobileScreen,
                            ),
                          ),
                    buildDivider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSize.screenPadding),
                      child: EditPriceSection(itemDetail: itemDetail),
                    ),
                    buildDivider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSize.screenPadding),
                      child: EditNameCategorySection(
                        textName: "Menu Category:",
                        enController: menuData.categoryEnController,
                        zhController: menuData.categoryZhController,
                        myController: menuData.categoryMyController,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSize.screenPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ButtonUtils.forwardButton(
                              context: context,
                              width: 220,
                              label: 'confirm'.tr(),
                              fontSize: 17,
                              onPressed: () {
                                menuData.updateMenuData(context, itemDetail);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              if (menuData.isEditMethodLoading)
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

  Widget buildHeadImage(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(AppSize.cardBorderRadius + 10)),
          child: SizedBox(
            width: double.infinity,
            height: 400,
            child: Hero(
              tag: 'hero-image-${widget.itemDetail['image']}',
              child: Image.asset(
                widget.itemDetail['image'],
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned(
          top: 20,
          left: 20,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSize.cardBorderRadius),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius:
                        BorderRadius.circular(AppSize.cardBorderRadius)),
              ),
            ),
          ),
        ),
        Positioned(
          top: 20,
          left: 20,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.keyboard_arrow_left_rounded,
              size: 50,
              color: AppColors.appAccent,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDivider() {
    return const Padding(
      padding:
          EdgeInsets.symmetric(horizontal: AppSize.screenPadding, vertical: 10),
      child: Divider(
        thickness: 2,
      ),
    );
  }
}
