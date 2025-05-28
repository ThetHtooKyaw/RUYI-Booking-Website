import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/menu_data_provider.dart';
import 'package:ruyi_booking/utils/colors.dart';
import 'package:ruyi_booking/utils/menu_data.dart';

class MenuTypePicker extends StatefulWidget {
  final String itemID;
  const MenuTypePicker({super.key, required this.itemID});

  @override
  State<MenuTypePicker> createState() => _MenuTypePickerState();
}

class _MenuTypePickerState extends State<MenuTypePicker> {
  late String selectedOption;

  @override
  void initState() {
    super.initState();
    final item = menuItems.firstWhere((item) => item['id'] == widget.itemID);
    final defaultOption = item['type']['0'] as String;

    selectedOption = defaultOption;
  }

  @override
  Widget build(BuildContext context) {
    var menuData = Provider.of<MenuDataProvider>(context);
    final item = menuItems.firstWhere((item) => item['id'] == widget.itemID);
    final typeOptions = (item['type'] as Map).values.cast<String>().toList();

    return DropdownMenu(
      menuHeight: typeOptions.length * 60,
      initialSelection: selectedOption,
      onSelected: (String? value) {
        if (value != null) {
          setState(() {
            selectedOption = value;
            menuData.onOptionChanged(widget.itemID, selectedOption);
          });
        }
      },
      dropdownMenuEntries: typeOptions
          .map((value) => DropdownMenuEntry<String>(
                value: value,
                label: value.tr(),
                labelWidget: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  width: 100,
                  child: Text(
                    value.tr(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ))
          .toList(),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide.none,
        ),
      ),
      menuStyle: MenuStyle(
        visualDensity: VisualDensity.compact,
        backgroundColor: WidgetStateProperty.all(AppColors.appAccent),
      ),
      textStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: AppColors.appAccent,
      ),
      trailingIcon: Icon(
        Icons.arrow_drop_down,
        color: Theme.of(context).iconTheme.color,
      ),
    );
  }
}
