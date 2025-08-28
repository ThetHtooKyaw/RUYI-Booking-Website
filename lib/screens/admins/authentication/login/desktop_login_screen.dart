import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/admin_auth_provider.dart';
import 'package:ruyi_booking/screens/admins/widgets/auth_title.dart';
import 'package:ruyi_booking/screens/home/home_screen.dart';
import 'package:ruyi_booking/utils/constants.dart';
import 'package:ruyi_booking/widgets/extras/custom_buttons.dart';
import 'package:ruyi_booking/widgets/extras/custom_icon.dart';
import 'package:ruyi_booking/widgets/extras/custom_textfields.dart';
import 'package:ruyi_booking/widgets/cores/desktop_app_bar.dart';

class DesktopLoginScreen extends StatefulWidget {
  const DesktopLoginScreen({super.key});

  @override
  State<DesktopLoginScreen> createState() => _DesktopLoginScreenState();
}

class _DesktopLoginScreenState extends State<DesktopLoginScreen> {
  @override
  Widget build(BuildContext context) {
    var adminAuthData = Provider.of<AdminAuthProvider>(context);
    return Scaffold(
      appBar: DesktopAppBar(title: 'admin_login'.tr()),
      body: adminAuthData.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: adminAuthData.loginFormKey,
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
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          'login_title'.tr(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      const SizedBox(height: 20),
                      AdminTitle(
                        title: 'email'.tr(),
                        type: AdminTitleType.desktopSize,
                      ),
                      const SizedBox(height: 10),
                      TextFieldUtils.emailTextField(
                          adminAuthData.loginEmailController,
                          'Enter admin email',
                          double.infinity),
                      const SizedBox(height: 10),
                      AdminTitle(
                        title: 'password'.tr(),
                        type: AdminTitleType.desktopSize,
                      ),
                      const SizedBox(height: 10),
                      TextFieldUtils.passwordTextField(
                          adminAuthData.loginPasswordController,
                          'Enter admin password',
                          double.infinity),
                      const Spacer(),
                      ButtonUtils.forwardButton(
                        context: context,
                        width: double.infinity,
                        label: 'login'.tr(),
                        fontSize: 17,
                        onPressed: () {
                          if (!adminAuthData.isLoading) {
                            adminAuthData.adminLogin(context);
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      ButtonUtils.backwardButton(
                        context: context,
                        width: double.infinity,
                        label: 'back'.tr(),
                        fontSize: 17,
                        onPressed: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return const HomeScreen();
                          }));
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
