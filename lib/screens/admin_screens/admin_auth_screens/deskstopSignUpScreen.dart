import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/adminAuthProvider.dart';
import 'package:ruyi_booking/utils/colors.dart';
import 'package:ruyi_booking/widgets/extras/custom_buttons.dart';
import 'package:ruyi_booking/widgets/extras/custom_icon.dart';
import 'package:ruyi_booking/widgets/extras/custom_textfields.dart';
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
                    width: MediaQuery.of(context).size.width * 0.35,
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
                        TextFieldUtils.nameTextField(
                            adminAuthData.signUpNameController,
                            'Enter admin username',
                            double.infinity),
                        const SizedBox(height: 5),
                        _buildTitle(context, 'email'.tr()),
                        TextFieldUtils.emailTextField(
                            adminAuthData.signUpEmailController,
                            'Enter admin username',
                            double.infinity),
                        const SizedBox(height: 5),
                        _buildTitle(context, 'password'.tr()),
                        TextFieldUtils.passwordTextField(
                            adminAuthData.signUpPasswordController,
                            'Enter admin password',
                            double.infinity),
                        const SizedBox(height: 5),
                        _buildTitle(context, 'confirm_password'.tr()),
                        TextFieldUtils.confirmPasswordTextField(
                            adminAuthData.signUpConfirmPasswordController,
                            adminAuthData.signUpPasswordController,
                            'Enter admin confirm password',
                            double.infinity),
                        const SizedBox(height: 60),
                        ButtonUtils.forwardButton(
                            double.infinity, 'signup'.tr(), () {
                          if (!adminAuthData.isLoading) {
                            adminAuthData.adminSignUp(context);
                          }
                        }),
                        ButtonUtils.backwardButton(
                          double.infinity,
                          'back'.tr(),
                          () => Navigator.pop(context),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
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
