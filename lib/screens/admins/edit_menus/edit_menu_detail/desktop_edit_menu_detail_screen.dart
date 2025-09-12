import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/menu_data_provider.dart';
import 'package:ruyi_booking/screens/admins/edit_menus/edit_menu_detail/widgets/edit_type_section.dart';
import 'package:ruyi_booking/utils/constants.dart';
import 'package:ruyi_booking/widgets/cores/desktop_app_bar.dart';
import '../../../../widgets/extras/custom_buttons.dart';
import 'widgets/edit_name_category_section.dart';
import 'widgets/edit_price_section.dart';

class DesktopEditMenuDetailScreen extends StatefulWidget {
  final Map<String, dynamic> itemDetail;
  const DesktopEditMenuDetailScreen({super.key, required this.itemDetail});

  @override
  State<DesktopEditMenuDetailScreen> createState() =>
      _DesktopEditMenuDetailScreenState();
}

class _DesktopEditMenuDetailScreenState
    extends State<DesktopEditMenuDetailScreen> {
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
      appBar: DesktopAppBar(title: itemDetail['name']),
      body: Consumer<MenuDataProvider>(
        builder: (context, menuData, child) {
          // if (menuData.isMenuDetailLoading) {
          //   return const Center(child: CircularProgressIndicator());
          // }

          final options = itemDetail['options'] as Map<String, dynamic>?;
          final hasOptionType = options != null &&
              options.values.any((option) {
                final optionsMap = option as Map<String, dynamic>?;
                return optionsMap?['type'] != null;
              });

          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSize.screenPadding + 10,
                    AppSize.screenPadding + 20, AppSize.screenPadding + 10, 0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: buildHeadImage(context),
                          ),
                          const SizedBox(width: 30),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                                horizontal:
                                                    AppSize.screenPadding),
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
                                          type: EditAddTypeSectionType
                                              .desktopScreen,
                                        ),
                                      ),
                                buildDivider(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: AppSize.screenPadding),
                                  child:
                                      EditPriceSection(itemDetail: itemDetail),
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
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: ButtonUtils.forwardButton(
                          context: context,
                          width: 800,
                          label: 'confirm'.tr(),
                          fontSize: 17,
                          onPressed: () {
                            menuData.updateMenuData(context, itemDetail);
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              if (menuData.isMenuDetailLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget buildHeadImage(BuildContext context) {
    return Container(
      width: 550,
      height: 550,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.cardBorderRadius + 10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSize.cardBorderRadius + 10),
        child: Hero(
          tag: 'hero-image-${widget.itemDetail['image']}',
          child: Image.asset(
            widget.itemDetail['image'],
            fit: BoxFit.cover,
          ),
        ),
      ),
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
