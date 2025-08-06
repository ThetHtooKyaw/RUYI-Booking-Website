import 'package:flutter/material.dart';
import 'package:ruyi_booking/utils/colors.dart';

class ButtonUtils {
  static Widget forwardButton(
    BuildContext context,
    double width,
    String text,
    VoidCallback onPressed,
    double fontSize,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 5,
          padding: EdgeInsets.symmetric(
              vertical:
                  (MediaQuery.of(context).size.width * 0.04).clamp(14.0, 24.0)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: fontSize),
        ),
      ),
    );
  }

  static Widget backwardButton(
    BuildContext context,
    double width,
    String text,
    VoidCallback onPressed,
    double fontSize,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      width: width,
      child: Material(
        elevation: 5,
        shadowColor: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
        color: AppColors.appBackground,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(
                vertical: (MediaQuery.of(context).size.width * 0.045)
                    .clamp(12.0, 24.0)),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
          child: Text(
            text,
            style: TextStyle(fontSize: fontSize),
          ),
        ),
      ),
    );
  }
}
