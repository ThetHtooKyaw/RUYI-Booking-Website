import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/menu_data_provider.dart';
import 'package:ruyi_booking/utils/colors.dart';

class MenuTypePicker extends StatefulWidget {
  final String itemId;
  final Map<String, dynamic> itemType;
  const MenuTypePicker(
      {super.key, required this.itemId, required this.itemType});

  @override
  State<MenuTypePicker> createState() => _MenuTypePickerState();
}

class _MenuTypePickerState extends State<MenuTypePicker> {
  late String selectedOption;

  @override
  void initState() {
    super.initState();
    final defaultOption = widget.itemType['0'] as String;
    selectedOption = defaultOption;
  }

  @override
  Widget build(BuildContext context) {
    var menuData = Provider.of<MenuDataProvider>(context);
    final typeOptions = (widget.itemType as Map).values.cast<String>().toList();

    return SizedBox(
      width: 150,
      child: DropdownButtonFormField<String>(
        value: selectedOption,
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              selectedOption = newValue;
              menuData.onOptionChanged(widget.itemId, selectedOption);
            });
          }
        },
        items: typeOptions.map((value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              width: 100,
              child: Text(
                value.tr(),
                maxLines: 2,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          );
        }).toList(),
        selectedItemBuilder: (BuildContext context) {
          return typeOptions.map<Widget>((String value) {
            return SizedBox(
              width: 90,
              child: Text(
                value.tr(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.appAccent,
                    ),
              ),
            );
          }).toList();
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide.none,
          ),
        ),
        icon: Icon(
          Icons.arrow_drop_down,
          color: Theme.of(context).iconTheme.color,
        ),
        dropdownColor: AppColors.appAccent,
      ),
    );
  }
}
