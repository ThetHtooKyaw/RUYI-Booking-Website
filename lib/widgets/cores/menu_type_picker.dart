import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/menu_data_provider.dart';
import 'package:ruyi_booking/utils/colors.dart';

class MenuTypePicker extends StatefulWidget {
  final String itemId;
  final Map<String, dynamic> itemOptions;
  final Map<String, dynamic>? itemDetail;
  final bool fromAdminMenuDetail;
  const MenuTypePicker({
    super.key,
    required this.itemId,
    required this.itemOptions,
    this.itemDetail,
    this.fromAdminMenuDetail = false,
  });

  @override
  State<MenuTypePicker> createState() => _MenuTypePickerState();
}

class _MenuTypePickerState extends State<MenuTypePicker> {
  String? selectedOption;

  @override
  void initState() {
    super.initState();
    final defaultOption = widget.itemOptions.values.first;
    selectedOption = defaultOption['type']?.toString();
  }

  @override
  Widget build(BuildContext context) {
    final menuData = Provider.of<MenuDataProvider>(context);
    final options = widget.itemOptions.values
        .map<String>((option) => option['type']?.toString() ?? '')
        .where((type) => type.isNotEmpty)
        .toList();

    if (options.isEmpty) {
      return const SizedBox();
    }

    return SizedBox(
      width: 150,
      child: DropdownButtonFormField<String>(
        value: selectedOption,
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              selectedOption = newValue;
              menuData.onOptionChanged(widget.itemId, selectedOption!);
              if (widget.fromAdminMenuDetail && widget.itemDetail != null) {
                menuData.loadTranslations(widget.itemDetail!);
              }
            });
          }
        },
        items: options.map((value) {
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
          return options.map<Widget>((String value) {
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
