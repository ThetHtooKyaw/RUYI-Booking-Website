import 'package:flutter/material.dart';
import 'package:ruyi_booking/utils/constants.dart';

class TextFieldUtils {
  static Widget nameTextField(
      TextEditingController controller, String hintText, double width) {
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Username is required';
          } else if (value.length < 3) {
            return 'Username must have at least 3 characters';
          }

          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          hintText: hintText,
          errorStyle: const TextStyle(
            fontSize: 14,
            color: AppColors.appAccent,
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.appAccent),
            borderRadius: BorderRadius.circular(AppSize.cardBorderRadius),
          ),
        ),
      ),
    );
  }

  static Widget emailTextField(
      TextEditingController controller, String hintText, double width) {
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Email is required';
          } else if (value.length < 6) {
            return 'Phone number must have at least 6 characters';
          } else if (value.contains(' ')) {
            return 'Email should not contain spaces';
          } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
            return 'Enter a valid email';
          }

          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: hintText,
          errorStyle: const TextStyle(
            fontSize: 14,
            color: AppColors.appAccent,
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.appAccent),
            borderRadius: BorderRadius.circular(AppSize.cardBorderRadius),
          ),
        ),
      ),
    );
  }

  static Widget phoneNumberTextField(
      TextEditingController controller, String hintText, double width) {
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Phone number is required';
          } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
            return 'Phone number must contain only digits';
          } else if (value.length < 9) {
            return 'Enter a valid phone number';
          } else if (value.contains(' ')) {
            return 'Email should not contain spaces';
          }

          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          hintText: hintText,
          errorStyle: const TextStyle(
            fontSize: 14,
            color: AppColors.appAccent,
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.appAccent),
            borderRadius: BorderRadius.circular(AppSize.cardBorderRadius),
          ),
        ),
      ),
    );
  }

  static Widget passwordTextField(
      TextEditingController controller, String hintText, double width) {
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Password is required';
          } else if (value.length < 8) {
            return 'Password must have at least 8 characters';
          } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
            return 'Password must contain at least one uppercase letter';
          } else if (!RegExp(r'[a-z]').hasMatch(value)) {
            return 'Password must contain at least one lowercase letter';
          } else if (!RegExp(r'[0-9]').hasMatch(value)) {
            return 'Password must contain at least one number';
          } else if (value.contains(' ')) {
            return 'Email should not contain spaces';
          }

          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.text,
        obscureText: true,
        enableSuggestions: false,
        autocorrect: false,
        decoration: InputDecoration(
          hintText: hintText,
          errorStyle: const TextStyle(
            fontSize: 14,
            color: AppColors.appAccent,
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.appAccent),
            borderRadius: BorderRadius.circular(AppSize.cardBorderRadius),
          ),
        ),
      ),
    );
  }

  static Widget confirmPasswordTextField(TextEditingController controller1,
      TextEditingController controller2, String hintText, double width) {
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: controller1,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Confirm password is required';
          } else if (value != controller2.text) {
            return "Confirm password do not match";
          }

          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.text,
        obscureText: true,
        enableSuggestions: false,
        autocorrect: false,
        decoration: InputDecoration(
          hintText: hintText,
          errorStyle: const TextStyle(
            fontSize: 14,
            color: AppColors.appAccent,
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.appAccent),
            borderRadius: BorderRadius.circular(AppSize.cardBorderRadius),
          ),
        ),
      ),
    );
  }
}
