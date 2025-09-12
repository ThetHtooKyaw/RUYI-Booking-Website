import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../providers/menu_data_provider.dart';
import '../../../../menus/widgets/menu_type_picker.dart';
import '../../../../menus/widgets/small_button.dart';
import '../../edit_menu_options/edit_menu_options_screen.dart';
import '../../widgets/lang_text_field.dart';
import 'dialog_edit_method.dart';

class EditTypeSection extends StatelessWidget {
  final Map<String, dynamic> itemDetail;
  final Map<String, dynamic> options;
  const EditTypeSection(
      {super.key, required this.itemDetail, required this.options});

  @override
  Widget build(BuildContext context) {
    final menuData = Provider.of<MenuDataProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Menu Method:",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const Spacer(),
            SmallIconButton(
              icon: const Icon(Icons.add, size: 25, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditMenuOptionsScreen(
                            menuOption: options,
                            menuName: itemDetail['name'],
                          )),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            MenuTypePicker(
              itemId: itemDetail['id'],
              itemOptions: options,
              itemDetail: itemDetail,
              fromAdminMenuDetail: true,
              key: ObjectKey(itemDetail['id']),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: LangTextField(
                controller: menuData.typeEnController,
                labelText: "English",
                isLoading: menuData.isMenuLangLoading,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: LangTextField(
                controller: menuData.typeZhController,
                labelText: "Chinese",
                isLoading: menuData.isMenuLangLoading,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: LangTextField(
                controller: menuData.typeMyController,
                labelText: "Myanmar",
                isLoading: menuData.isMenuLangLoading,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

enum EditAddTypeSectionType { mobileScreen, desktopScreen }

class EditAddTypeSection extends StatelessWidget {
  final Map<String, dynamic> itemDetail;
  final EditAddTypeSectionType type;
  const EditAddTypeSection({
    super.key,
    required this.itemDetail,
    this.type = EditAddTypeSectionType.mobileScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Menu Method:",
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const Spacer(),
        SmallIconButton(
          icon: const Icon(Icons.add, size: 25, color: Colors.white),
          onPressed: () => buildEditMethod(
            context: context,
            itemDetail: itemDetail,
            type: type == EditAddTypeSectionType.mobileScreen
                ? BuildEditMethodType.mobileScreen
                : BuildEditMethodType.desktopScreen,
          ),
        ),
      ],
    );
  }
}
