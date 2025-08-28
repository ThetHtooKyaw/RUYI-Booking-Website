import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/admin_auth_provider.dart';
import 'package:ruyi_booking/screens/admins/widgets/auth_title.dart';
import 'package:ruyi_booking/utils/constants.dart';
import 'package:ruyi_booking/widgets/extras/custom_buttons.dart';
import 'package:ruyi_booking/widgets/extras/custom_icon.dart';
import 'package:ruyi_booking/widgets/extras/custom_textfields.dart';
import 'package:ruyi_booking/widgets/cores/desktop_app_bar.dart';

class DesktopSignUpScreen extends StatefulWidget {
  const DesktopSignUpScreen({super.key});

  @override
  State<DesktopSignUpScreen> createState() => _DesktopSignUpScreenState();
}

class _DesktopSignUpScreenState extends State<DesktopSignUpScreen> {
  @override
  Widget build(BuildContext context) {
    var adminAuthData = Provider.of<AdminAuthProvider>(context);
    return Scaffold(
      appBar: DesktopAppBar(title: 'admin_signup'.tr()),
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
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(
                                  color: AppColors.appAccent,
                                  fontFamily: 'PlayfairDisplay',
                                ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            'signup_title'.tr(),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        const SizedBox(height: 20),
                        AdminTitle(
                          title: 'username'.tr(),
                          type: AdminTitleType.desktopSize,
                        ),
                        const SizedBox(height: 10),
                        TextFieldUtils.nameTextField(
                            adminAuthData.signUpNameController,
                            'Enter admin username',
                            double.infinity),
                        const SizedBox(height: 10),
                        AdminTitle(
                          title: 'email'.tr(),
                          type: AdminTitleType.desktopSize,
                        ),
                        const SizedBox(height: 10),
                        TextFieldUtils.emailTextField(
                            adminAuthData.signUpEmailController,
                            'Enter admin username',
                            double.infinity),
                        const SizedBox(height: 10),
                        AdminTitle(
                          title: 'password'.tr(),
                          type: AdminTitleType.desktopSize,
                        ),
                        const SizedBox(height: 10),
                        TextFieldUtils.passwordTextField(
                            adminAuthData.signUpPasswordController,
                            'Enter admin password',
                            double.infinity),
                        const SizedBox(height: 10),
                        AdminTitle(
                          title: 'confirm_password'.tr(),
                          type: AdminTitleType.desktopSize,
                        ),
                        const SizedBox(height: 10),
                        TextFieldUtils.confirmPasswordTextField(
                            adminAuthData.signUpConfirmPasswordController,
                            adminAuthData.signUpPasswordController,
                            'Enter admin confirm password',
                            double.infinity),
                        const SizedBox(height: 60),
                        ButtonUtils.forwardButton(
                          context: context,
                          width: double.infinity,
                          label: 'signup'.tr(),
                          fontSize: 17,
                          onPressed: () {
                            if (!adminAuthData.isLoading) {
                              adminAuthData.adminSignUp(context);
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        ButtonUtils.backwardButton(
                          context: context,
                          width: double.infinity,
                          label: 'back'.tr(),
                          fontSize: 17,
                          onPressed: () => Navigator.pop(context),
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

  Widget _buildTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall,
    );
  }
}
