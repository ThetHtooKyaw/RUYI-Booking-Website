import 'package:flutter/material.dart';
import 'package:ruyi_booking/utils/constants.dart';

class SmallButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const SmallButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          vertical: screenWidth <= 414 ? 6 : 20,
          horizontal: screenWidth <= 414 ? 4 : 10,
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.smallCardBorderRadius)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

class SmallIconButton extends StatelessWidget {
  final Icon icon;
  final VoidCallback onPressed;
  const SmallIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: AppColors.appAccent,
        borderRadius: BorderRadius.circular(AppSize.smallCardBorderRadius),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        onPressed: onPressed,
        icon: icon,
      ),
    );
  }
}
