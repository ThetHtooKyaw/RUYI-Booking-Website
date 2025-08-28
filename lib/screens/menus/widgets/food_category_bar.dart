import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ruyi_booking/classes/category.dart';
import 'package:ruyi_booking/utils/constants.dart';
import 'package:ruyi_booking/widgets/cores/list_view_shadow.dart';

enum FoodCategoryBarType { hAxis, vAxis }

class FoodCategoryBar extends StatefulWidget {
  final int selectedCategory;
  final ValueChanged<int> onCategorySelected;
  final FoodCategoryBarType type;
  const FoodCategoryBar({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.type = FoodCategoryBarType.hAxis,
  });

  @override
  State<FoodCategoryBar> createState() => _FoodCategoryBarState();
}

class _FoodCategoryBarState extends State<FoodCategoryBar> {
  final ScrollController _scrollController = ScrollController();
  double _shadowOpacity = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final offSet = _scrollController.offset;
      setState(() {
        _shadowOpacity = (offSet / 50).clamp(0.0, 0.3);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Stack(
        children: [
          ListView.separated(
            controller: _scrollController,
            padding: widget.type == FoodCategoryBarType.hAxis
                ? const EdgeInsets.only(right: 10)
                : const EdgeInsets.only(bottom: 20),
            scrollDirection: widget.type == FoodCategoryBarType.hAxis
                ? Axis.horizontal
                : Axis.vertical,
            separatorBuilder: (_, __) =>
                widget.type == FoodCategoryBarType.hAxis
                    ? const SizedBox(width: AppSize.listViewMargin)
                    : const SizedBox(height: AppSize.listViewMargin),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final isSelected = widget.selectedCategory == index;
              final category = categories[index];

              return GestureDetector(
                onTap: () => setState(() => widget.onCategorySelected(index)),
                child: Container(
                  padding: widget.type == FoodCategoryBarType.hAxis
                      ? const EdgeInsets.symmetric(
                          horizontal: AppSize.cardPadding)
                      : const EdgeInsets.all(AppSize.cardPadding),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.appAccent : Colors.white,
                    borderRadius:
                        BorderRadius.circular(AppSize.smallCardBorderRadius),
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
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          widget.type == FoodCategoryBarType.hAxis
              ? Positioned(
                  top: 0,
                  left: 0,
                  bottom: 0,
                  child: Container(
                    width: 1,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(_shadowOpacity),
                          blurRadius: 6,
                          spreadRadius: 0.6,
                        )
                      ],
                    ),
                  ),
                )
              : ListViewShadow(shadowOpacity: _shadowOpacity),
        ],
      ),
    );
  }
}
