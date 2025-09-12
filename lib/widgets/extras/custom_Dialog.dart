import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/menu_data_provider.dart';
import 'package:ruyi_booking/utils/constants.dart';

class DialogUtils {
  static void showBookingConfirmationDialog(
    BuildContext context,
    String title,
    String subtitle,
    VoidCallback onTap, {
    bool isClickable = false,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer<MenuDataProvider>(
          builder: (context, menuData, _) => Stack(
            children: [
              AlertDialog(
                contentPadding: const EdgeInsets.all(AppSize.cardPadding),
                backgroundColor: AppColors.appBackground,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      CupertinoIcons.exclamationmark_circle,
                      size: 25,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                content: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                  if (isClickable)
                    _buildDialogButton(
                      context: context,
                      label: 'Cancel',
                      btnColor: AppColors.appAccent,
                      textColor: Colors.white,
                      onTap: () => Navigator.pop(context),
                    ),
                  const SizedBox(height: 10),
                  _buildDialogButton(
                    context: context,
                    label: 'OK',
                    btnColor: Colors.white,
                    textColor: AppColors.appAccent,
                    onTap: onTap,
                  ),
                ],
              ),
              if (menuData.isConfirmLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
            ],
          ),
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
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.appAccent, fontWeight: FontWeight.bold),
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

  static Widget _buildDialogButton({
    required BuildContext context,
    required String label,
    required Color btnColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSize.cardPadding),
        width: 140,
        decoration: BoxDecoration(
          color: btnColor,
          borderRadius: BorderRadius.circular(AppSize.cardBorderRadius),
        ),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    );
  }
}
