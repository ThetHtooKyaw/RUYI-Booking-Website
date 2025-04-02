import 'package:flutter/material.dart';
import 'package:ruyi_booking/utils/colors.dart';

class DialogUtils {
  static void showBookingConfirmationDialog(
      BuildContext context, String title, String subtitle, VoidCallback onTap,
      {bool isClickable = false}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.appBackground,
          title: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: 300,
            child: Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          actions: [
            isClickable
                ? TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontSize: 18),
                    ),
                  )
                : const SizedBox(),
            TextButton(
              onPressed: onTap,
              child: Text(
                'OK',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontSize: 18),
              ),
            ),
          ],
        );
      },
    );
  }

  static void showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.appBackground,
          title: Text(
            'Error',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 20,
                color: AppColors.appAccent,
                fontWeight: FontWeight.bold),
          ),
          content: Text(
            errorMessage,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.appAccent),
          ),
          actions: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                'OK',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontSize: 18),
              ),
            ),
          ],
        );
      },
    );
  }
}
