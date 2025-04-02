import 'package:flutter/material.dart';
import 'package:ruyi_booking/utils/colors.dart';

class CustomIcon extends StatelessWidget {
  final IconData iconImage;
  final double size;
  final double borderRadius;
  final double thickness;
  const CustomIcon({
    super.key,
    required this.iconImage,
    required this.size,
    required this.borderRadius,
    required this.thickness,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.appAccent,
          width: thickness,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Icon(
        iconImage,
        size: size,
        color: Theme.of(context).iconTheme.color,
      ),
    );
  }
}
