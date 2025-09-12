import 'package:flutter/material.dart';
import 'package:ruyi_booking/utils/constants.dart';

class EditTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?) validator;
  final String hintText;
  final Color bgColor;
  const EditTextFormField({
    super.key,
    required this.controller,
    required this.validator,
    required this.hintText,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        fillColor: bgColor,
        hintText: hintText,
        errorStyle: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(color: AppColors.appAccent),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.appAccent),
          borderRadius: BorderRadius.circular(AppSize.cardBorderRadius),
        ),
      ),
    );
  }
}
