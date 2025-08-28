import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/menu_data_provider.dart';
import 'package:ruyi_booking/screens/admins/edit_menus/edit_menu_options/mobile_edit_menu_options_screen.dart';
import 'package:ruyi_booking/utils/constants.dart';
import 'package:ruyi_booking/screens/menus/widgets/menu_type_picker.dart';
import 'package:ruyi_booking/widgets/extras/custom_buttons.dart';

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
        menuData.isLoading = true;
      });
      await menuData.loadTranslations(widget.itemDetail);
      setState(() {
        menuData.isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final menuData = Provider.of<MenuDataProvider>(context, listen: false);
    final item = widget.itemDetail;
    final options = item['options'] as Map<String, dynamic>?;
    final hasOptionType = options != null &&
        options.values.any((option) {
          final optionsMap = option as Map<String, dynamic>?;
          return optionsMap?['type'] != null;
        });

    return Scaffold(
      body: menuData.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Consumer<MenuDataProvider>(
              builder: (context, menuData, child) {
                return ListView(
                  children: [
                    buildHeadImage(context),
                    const SizedBox(height: 10),
                    buildNameCategorySection(
                      context,
                      "Menu Name:",
                      menuData.nameEnController,
                      menuData.nameZhController,
                      menuData.nameMyController,
                    ),
                    buildDivider(),
                    hasOptionType
                        ? Column(
                            children: [
                              buildTypeSection(
                                  context, item, options, menuData),
                              buildDivider(),
                            ],
                          )
                        : const SizedBox(),
                    buildPriceSection(context, item, menuData),
                    buildDivider(),
                    buildNameCategorySection(
                      context,
                      "Menu Category:",
                      menuData.categoryEnController,
                      menuData.categoryZhController,
                      menuData.categoryMyController,
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
                                menuData.updateMenuData(context, item);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
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

  Widget buildTextField({
    required TextEditingController controller,
    required String labelText,
    bool isLoading = false,
  }) {
    return Expanded(
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(
            color: AppColors.appAccent,
            fontWeight: FontWeight.bold,
          ),
          suffixIcon: isLoading
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
    );
  }

  Widget buildNameCategorySection(
    BuildContext context,
    String textName,
    TextEditingController enController,
    TextEditingController zhController,
    TextEditingController myController,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSize.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Row(
            children: [
              Text(textName, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(width: 10),
              buildTextField(
                controller: enController,
                labelText: "English",
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextField(
                controller: zhController,
                labelText: "Chinese",
              ),
              const SizedBox(width: 10),
              buildTextField(
                controller: myController,
                labelText: "Myanmar",
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildTypeSection(
    BuildContext context,
    Map<String, dynamic> item,
    Map<String, dynamic> options,
    MenuDataProvider menuData,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSize.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Menu Type:",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const Spacer(),
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: AppColors.appAccent,
                  borderRadius:
                      BorderRadius.circular(AppSize.smallCardBorderRadius),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MobileEditMenuOptionsScreen(
                                  menuOption: options,
                                )));
                  },
                  icon: const Icon(Icons.add, size: 25, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              MenuTypePicker(
                itemId: item['id'],
                itemOptions: options,
                itemDetail: widget.itemDetail,
                fromAdminMenuDetail: true,
                key: ObjectKey(item['id']),
              ),
              const SizedBox(width: 10),
              buildTextField(
                controller: menuData.typeEnController,
                labelText: "English",
                isLoading: menuData.isLoadingType,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextField(
                controller: menuData.typeZhController,
                labelText: "Chinese",
                isLoading: menuData.isLoadingType,
              ),
              const SizedBox(width: 10),
              buildTextField(
                controller: menuData.typeMyController,
                labelText: "Myanmar",
                isLoading: menuData.isLoadingType,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildPriceSection(
    BuildContext context,
    Map<String, dynamic> item,
    MenuDataProvider menuData,
  ) {
    final bool onShowPriceString = menuData.onShowPriceString(item);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSize.screenPadding),
      child: Row(
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
                      suffixIcon: menuData.isLoadingPrice
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
