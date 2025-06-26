import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ruyi_booking/classes/category.dart';
import 'package:ruyi_booking/utils/colors.dart';

class FoodCategory extends StatefulWidget {
  final int selectedCategory;
  final ValueChanged<int> onCategorySelected;
  const FoodCategory(
      {super.key,
      required this.selectedCategory,
      required this.onCategorySelected});

  @override
  State<FoodCategory> createState() => _FoodCategoryState();
}

class _FoodCategoryState extends State<FoodCategory> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = widget.selectedCategory == index;
          final category = categories[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: GestureDetector(
              onTap: () => setState(() => widget.onCategorySelected(index)),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.appAccent : Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      category.icon,
                      width: 17,
                      height: 17,
                      color: isSelected ? Colors.white : AppColors.appAccent,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      category.name.tr(),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
