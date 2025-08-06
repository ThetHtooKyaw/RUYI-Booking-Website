import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/admin_auth_provider.dart';
import 'package:ruyi_booking/screens/home_screens/home_screen.dart';
import 'package:ruyi_booking/utils/colors.dart';
import 'package:ruyi_booking/widgets/extras/custom_buttons.dart';
import 'package:ruyi_booking/widgets/extras/custom_icon.dart';
import 'package:ruyi_booking/widgets/extras/custom_textfields.dart';
import 'package:ruyi_booking/widgets/extras/mobile_app_bar.dart';

class MobileAuthScreen extends StatefulWidget {
  const MobileAuthScreen({super.key});

  @override
  State<MobileAuthScreen> createState() => _MobileAuthScreenState();
}

class _MobileAuthScreenState extends State<MobileAuthScreen> {
  @override
  Widget build(BuildContext context) {
    var adminAuthData = Provider.of<AdminAuthProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: MobileAppbar(
        title: 'admin_login'.tr(),
        type: MobileAppBarType.withoudBtn,
      ),
      body: adminAuthData.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: adminAuthData.loginFormKey,
              child: SafeArea(
                child: SingleChildScrollView(
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
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          'login_title'.tr(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildTitle(context, 'email'.tr()),
                      TextFieldUtils.emailTextField(
                          adminAuthData.loginEmailController,
                          'Enter admin email',
                          double.infinity),
                      const SizedBox(height: 5),
                      _buildTitle(context, 'password'.tr()),
                      TextFieldUtils.passwordTextField(
                          adminAuthData.loginPasswordController,
                          'Enter admin password',
                          double.infinity),
                      const SizedBox(height: 60),
                      ButtonUtils.forwardButton(
                          context, double.infinity, 'login'.tr(), () {
                        if (!adminAuthData.isLoading) {
                          adminAuthData.adminLogin(context);
                        }
                      }, 17),
                      ButtonUtils.backwardButton(
                          context, double.infinity, 'back'.tr(), () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return const HomeScreen();
                        }));
                      }, 17),
                    ],
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
