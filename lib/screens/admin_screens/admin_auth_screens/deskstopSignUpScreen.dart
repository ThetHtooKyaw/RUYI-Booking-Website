import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/adminAuthProvider.dart';
import 'package:ruyi_booking/utils/colors.dart';
import 'package:ruyi_booking/widgets/extras/custom_icon.dart';
import 'package:ruyi_booking/widgets/extras/deskstopAppBar.dart';

class DeskstopSignUpScreen extends StatefulWidget {
  const DeskstopSignUpScreen({super.key});

  @override
  State<DeskstopSignUpScreen> createState() => _DeskstopSignUpScreenState();
}

class _DeskstopSignUpScreenState extends State<DeskstopSignUpScreen> {
  @override
  Widget build(BuildContext context) {
    var adminAuthData = Provider.of<AdminAuthProvider>(context);
    return Scaffold(
      appBar: DeskstopAppBar(title: 'admin_signup'.tr(), isClickable: false),
      body: adminAuthData.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Form(
                key: adminAuthData.signUpFormKey,
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.30,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: CustomIcon(
                            iconImage: Icons.admin_panel_settings_rounded,
                            size: 100,
                            borderRadius: 60,
                            thickness: 4,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Text(
                            'admin_title'.tr(),
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontSize: 35,
                                      color: AppColors.appAccent,
                                      fontFamily: 'PlayfairDisplay',
                                    ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            'signup_title'.tr(),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildTitle(context, 'username'.tr()),
                        _buildTextField(
                            context,
                            adminAuthData.signUpNameController,
                            'Enter admin username', (value) {
                          if (value == null || value.isEmpty) {
                            return 'Username is required';
                          } else if (value.length < 3) {
                            return 'Username must have at least 3 characters';
                          }

                          return null;
                        }),
                        const SizedBox(height: 10),
                        _buildTitle(context, 'email'.tr()),
                        _buildTextField(
                          context,
                          adminAuthData.signUpEmailController,
                          'Enter admin email',
                          (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            } else if (value.contains(' ')) {
                              return 'Email should not contain spaces';
                            } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return 'Enter a valid email';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        _buildTitle(context, 'password'.tr()),
                        _buildPasswordTextField(
                          context,
                          adminAuthData.signUpPasswordController,
                          'Enter admin password',
                          (value) {
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
                        ),
                        const SizedBox(height: 10),
                        _buildTitle(context, 'confirm_password'.tr()),
                        _buildPasswordTextField(
                          context,
                          adminAuthData.signUpConfirmPasswordController,
                          'Enter admin confirm password',
                          (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required';
                            } else if (value !=
                                adminAuthData.signUpPasswordController.text) {
                              return "Passwords do not match";
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 60),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                          width: 450,
                          child: ElevatedButton(
                            onPressed: adminAuthData.isLoading
                                ? null
                                : () => adminAuthData.adminSignUp(context),
                            style: ElevatedButton.styleFrom(
                              elevation: 5,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Text(
                              'signup'.tr(),
                              style: const TextStyle(fontSize: 17),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            bottom: 20,
                          ),
                          width: 450,
                          child: Material(
                            elevation: 5,
                            shadowColor: Colors.black.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.appBackground,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              child: Text(
                                'back'.tr(),
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  SizedBox _buildPasswordTextField(
      BuildContext context,
      TextEditingController controller,
      String hintText,
      String? Function(String?) validator) {
    return SizedBox(
      width: 450,
      child: TextFormField(
        controller: controller,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        obscureText: true,
        autocorrect: false,
        decoration: InputDecoration(
          hintText: hintText,
          errorStyle: const TextStyle(
            fontSize: 15,
            color: AppColors.appAccent,
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.appAccent),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(BuildContext context, TextEditingController controller,
      String hintText, String? Function(String?) validator) {
    return SizedBox(
      width: 450,
      child: TextFormField(
        controller: controller,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          hintText: hintText,
          errorStyle: const TextStyle(
            fontSize: 15,
            color: AppColors.appAccent,
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.appAccent),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Padding _buildTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18),
      ),
    );
  }
}
