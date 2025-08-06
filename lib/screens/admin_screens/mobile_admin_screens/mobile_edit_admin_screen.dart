import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/admin_auth_provider.dart';
import 'package:ruyi_booking/screens/admin_screens/admin_auth_screens/mobile_admin_auth_screens/mobile_signup_screen.dart';
import 'package:ruyi_booking/utils/colors.dart';
import 'package:ruyi_booking/widgets/extras/custom_buttons.dart';
import 'package:ruyi_booking/widgets/extras/custom_icon.dart';
import 'package:ruyi_booking/widgets/extras/custom_textfields.dart';

class MobileEditAdminScreen extends StatefulWidget {
  const MobileEditAdminScreen({super.key});

  @override
  State<MobileEditAdminScreen> createState() => _MobileEditAdminScreenState();
}

class _MobileEditAdminScreenState extends State<MobileEditAdminScreen> {
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
                child: Padding(
                  padding: const EdgeInsets.all(20),
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
                      _buildTitle(context, 'username'.tr()),
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
                                      context, 100, 'done'.tr(), () async {
                                    await adminAuthData
                                        .updateAdminName(context);
                                  }, 17),
                                ],
                              ),
                            )
                          : _buildCurrentData(
                              context,
                              adminAuthData.adminData['admin_name'] ??
                                  'Unknown',
                              () {
                                setState(() {
                                  adminAuthData.setNameEdit(true);
                                });
                              },
                            ),
                      _buildTitle(context, 'email'.tr()),
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
                                const SizedBox(height: 5),
                                ButtonUtils.forwardButton(
                                    context, double.infinity, 'done'.tr(),
                                    () async {
                                  await adminAuthData.updateEmail(context);
                                }, 17),
                              ],
                            )
                          : _buildCurrentData(
                              context,
                              adminAuthData.adminData['email'] ?? 'Unknown',
                              () {
                                setState(() {
                                  adminAuthData.setEmailEdit(true);
                                });
                              },
                            ),
                      _buildTitle(context, 'password'.tr()),
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
                                const SizedBox(height: 5),
                                ButtonUtils.forwardButton(
                                    context, double.infinity, 'done'.tr(),
                                    () async {
                                  await adminAuthData.updatePassword(context);
                                }, 17),
                              ],
                            )
                          : ButtonUtils.forwardButton(
                              context, double.infinity, 'change_password'.tr(),
                              () {
                              setState(() {
                                adminAuthData.setPasswordEdit(true);
                              });
                            }, 17),
                      const SizedBox(height: 60),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: ButtonUtils.backwardButton(
                            context, double.infinity, 'cancel'.tr(), () {
                          adminAuthData.setNameEdit(false);
                          adminAuthData.setEmailEdit(false);
                          adminAuthData.setPasswordEdit(false);
                        }, 17),
                      ),
                      Center(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const MobileSignUpScreen();
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
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Row _buildCurrentData(BuildContext context, String name, VoidCallback onTap) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            name,
            style:
                Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18),
          ),
        ),
        InkWell(
          onTap: onTap,
          child: Icon(
            Icons.edit_rounded,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
      ],
    );
  }

  Padding _buildTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18),
      ),
    );
  }
}
