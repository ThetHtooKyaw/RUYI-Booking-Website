import 'package:flutter/material.dart';
import 'package:ruyi_booking/utils/constants.dart';

class LangTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isLoading;
  const LangTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          color: AppColors.appAccent,
          fontWeight: FontWeight.bold,
        ),
        suffixIcon: isLoading
            ? const Padding(
                padding: EdgeInsets.all(10),
                child: SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.appAccent,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}

class LangTextFromField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?) validator;
  final String labelText;
  final bool isLoading;
  const LangTextFromField({
    super.key,
    required this.controller,
    required this.validator,
    required this.labelText,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          color: AppColors.appAccent,
          fontWeight: FontWeight.bold,
        ),
        errorStyle: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(color: AppColors.appAccent),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.appAccent),
          borderRadius: BorderRadius.circular(AppSize.cardBorderRadius),
        ),
        suffixIcon: isLoading
            ? const Padding(
                padding: EdgeInsets.all(10),
                child: SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.appAccent,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
