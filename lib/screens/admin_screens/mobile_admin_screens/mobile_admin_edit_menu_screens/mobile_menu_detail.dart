import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/menu_data_provider.dart';
import 'package:ruyi_booking/utils/colors.dart';
import 'package:ruyi_booking/widgets/cores/menu_type_picker.dart';
import 'package:ruyi_booking/widgets/extras/custom_buttons.dart';

class MobileMenuDetail extends StatefulWidget {
  final Map<String, dynamic> itemDetail;
  const MobileMenuDetail({super.key, required this.itemDetail});

  @override
  State<MobileMenuDetail> createState() => _MobileMenuDetailState();
}

class _MobileMenuDetailState extends State<MobileMenuDetail> {
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
                    (item['type'] != null && item['type'].isNotEmpty)
                        ? Column(
                            children: [
                              buildTypeSection(context, item, menuData),
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
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ButtonUtils.forwardButton(
                              context,
                              220,
                              'confirm'.tr(),
                              () {
                                Navigator.pop(context);
                              },
                              17,
                            ),
                          ),
                        ],
                      ),
                    ),
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
            borderRadius: BorderRadius.circular(10),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10)),
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 15),
            child: Row(
              children: [
                Text(
                  textName,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 18),
                ),
                const SizedBox(width: 10),
                buildTextField(
                  controller: enController,
                  labelText: "English",
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
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
            ),
          )
        ],
      ),
    );
  }

  Widget buildTypeSection(
    BuildContext context,
    Map<String, dynamic> item,
    MenuDataProvider menuData,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              "Menu Type:",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              children: [
                MenuTypePicker(
                  itemId: item['id'],
                  itemType: item['type'],
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
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
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
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 15),
            child: Row(
              children: [
                Text(
                  "Menu Price:",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 18),
                ),
                const SizedBox(width: 10),
                onShowPriceString
                    ? buildTextField(
                        controller: menuData.priceEnController,
                        labelText: "English",
                        isLoading: menuData.isLoadingPrice,
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
          ),
          onShowPriceString
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTextField(
                        controller: menuData.priceZhController,
                        labelText: "Chinese",
                        isLoading: menuData.isLoadingPrice,
                      ),
                      const SizedBox(width: 10),
                      buildTextField(
                        controller: menuData.priceMyController,
                        labelText: "Myanmar",
                        isLoading: menuData.isLoadingPrice,
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Divider(
        thickness: 2,
      ),
    );
  }
}
