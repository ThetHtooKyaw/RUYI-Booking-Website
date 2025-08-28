import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/admin_auth_provider.dart';
import 'package:ruyi_booking/screens/admins/edit_admin_detail/widgets/admin_current_data.dart';
import 'package:ruyi_booking/screens/admins/authentication/signup/signup_screen.dart';
import 'package:ruyi_booking/screens/admins/widgets/auth_title.dart';
import 'package:ruyi_booking/utils/constants.dart';
import 'package:ruyi_booking/widgets/extras/custom_buttons.dart';
import 'package:ruyi_booking/widgets/extras/custom_icon.dart';
import 'package:ruyi_booking/widgets/extras/custom_textfields.dart';

class DesktopEditAdminDetailScreen extends StatefulWidget {
  const DesktopEditAdminDetailScreen({super.key});

  @override
  State<DesktopEditAdminDetailScreen> createState() =>
      _DesktopEditAdminDetailScreenState();
}

class _DesktopEditAdminDetailScreenState
    extends State<DesktopEditAdminDetailScreen> {
  @override
  Widget build(BuildContext context) {
    var adminAuthData = Provider.of<AdminAuthProvider>(context);
    return Scaffold(
      body: adminAuthData.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Form(
                key: adminAuthData.updateFormKey,
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
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
                        const SizedBox(height: 20),
                        AdminTitle(
                          title: 'username'.tr(),
                          type: AdminTitleType.desktopSize,
                        ),
                        const SizedBox(height: 10),
                        adminAuthData.nameEdit
                            ? SizedBox(
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFieldUtils.nameTextField(
                                          adminAuthData.updateNameController,
                                          'Enter new admin username',
                                          double.infinity),
                                    ),
                                    const SizedBox(width: 20),
                                    ButtonUtils.forwardButton(
                                      context: context,
                                      width: 100,
                                      label: 'done'.tr(),
                                      fontSize: 17,
                                      onPressed: () async {
                                        await adminAuthData
                                            .updateAdminName(context);
                                      },
                                    ),
                                  ],
                                ),
                              )
                            : AdminCurrentData(
                                label: adminAuthData.adminData['admin_name'] ??
                                    'Unknown',
                                onTap: () {
                                  setState(() {
                                    adminAuthData.setNameEdit(true);
                                  });
                                },
                              ),
                        const SizedBox(height: 20),
                        AdminTitle(
                          title: 'email'.tr(),
                          type: AdminTitleType.desktopSize,
                        ),
                        const SizedBox(height: 10),
                        adminAuthData.emailEdit
                            ? Column(
                                children: [
                                  TextFieldUtils.emailTextField(
                                      adminAuthData.updateEmailController,
                                      'Enter new admin email',
                                      double.infinity),
                                  const SizedBox(height: 5),
                                  TextFieldUtils.passwordTextField(
                                      adminAuthData
                                          .passwordForEmailUpdateController,
                                      'Enter admin password',
                                      double.infinity),
                                  const SizedBox(height: 10),
                                  ButtonUtils.forwardButton(
                                    context: context,
                                    width: double.infinity,
                                    label: 'done'.tr(),
                                    fontSize: 17,
                                    onPressed: () async {
                                      await adminAuthData.updateEmail(context);
                                    },
                                  ),
                                ],
                              )
                            : AdminCurrentData(
                                label: adminAuthData.adminData['email'] ??
                                    'Unknown',
                                onTap: () {
                                  setState(() {
                                    adminAuthData.setEmailEdit(true);
                                  });
                                },
                              ),
                        const SizedBox(height: 20),
                        AdminTitle(
                          title: 'password'.tr(),
                          type: AdminTitleType.desktopSize,
                        ),
                        const SizedBox(height: 10),
                        adminAuthData.passwordEdit
                            ? Column(
                                children: [
                                  TextFieldUtils.passwordTextField(
                                      adminAuthData
                                          .passwordForPasswordUpdateController,
                                      'Enter old admin password',
                                      double.infinity),
                                  const SizedBox(height: 5),
                                  TextFieldUtils.passwordTextField(
                                      adminAuthData.updatePasswordController,
                                      'Enter new admin password',
                                      double.infinity),
                                  const SizedBox(height: 10),
                                  ButtonUtils.forwardButton(
                                    context: context,
                                    width: double.infinity,
                                    label: 'done'.tr(),
                                    fontSize: 17,
                                    onPressed: () async {
                                      await adminAuthData
                                          .updatePassword(context);
                                    },
                                  ),
                                ],
                              )
                            : ButtonUtils.forwardButton(
                                context: context,
                                width: double.infinity,
                                label: 'change_password'.tr(),
                                fontSize: 17,
                                onPressed: () {
                                  setState(() {
                                    adminAuthData.setPasswordEdit(true);
                                  });
                                },
                              ),
                        const SizedBox(height: 60),
                        ButtonUtils.backwardButton(
                          context: context,
                          width: double.infinity,
                          label: 'cancel'.tr(),
                          fontSize: 17,
                          onPressed: () {
                            adminAuthData.setNameEdit(false);
                            adminAuthData.setEmailEdit(false);
                            adminAuthData.setPasswordEdit(false);
                          },
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return const SignupScreen();
                              }));
                            },
                            child: Text(
                              'signup'.tr(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: AppColors.appAccent),
                            ),
                          ),
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
}
