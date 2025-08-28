import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ruyi_booking/utils/constants.dart';

class ButtonUtils {
  static Widget forwardButton({
    required BuildContext context,
    required double width,
    required String label,
    required double fontSize,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 55,
        width: width,
        decoration: BoxDecoration(
          color: AppColors.appAccent,
          borderRadius: BorderRadius.circular(AppSize.cardBorderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 5,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSize.cardBorderRadius - 1),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.1), width: 0.5),
                    borderRadius:
                        BorderRadius.circular(AppSize.cardBorderRadius - 2),
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget backwardButton({
    required BuildContext context,
    required double width,
    required String label,
    required VoidCallback onPressed,
    required double fontSize,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 55,
        width: width,
        decoration: BoxDecoration(
          color: AppColors.appBackground,
          borderRadius: BorderRadius.circular(AppSize.cardBorderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 5,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSize.cardBorderRadius - 1),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    border: Border.all(color: AppColors.appAccent, width: 2),
                    borderRadius:
                        BorderRadius.circular(AppSize.cardBorderRadius - 2),
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                label,
                style: TextStyle(
                  color: AppColors.appAccent,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
