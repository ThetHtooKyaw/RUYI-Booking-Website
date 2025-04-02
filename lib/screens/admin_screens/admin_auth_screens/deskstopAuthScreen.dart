import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/adminAuthProvider.dart';
import 'package:ruyi_booking/screens/home_screens/home_screen.dart';
import 'package:ruyi_booking/utils/colors.dart';
import 'package:ruyi_booking/widgets/extras/custom_icon.dart';
import 'package:ruyi_booking/widgets/extras/deskstopAppBar.dart';

class DeskstopAuthScreen extends StatefulWidget {
  const DeskstopAuthScreen({super.key});

  @override
  State<DeskstopAuthScreen> createState() => _DeskstopAuthScreenState();
}

class _DeskstopAuthScreenState extends State<DeskstopAuthScreen> {
  @override
  Widget build(BuildContext context) {
    var adminAuthData = Provider.of<AdminAuthProvider>(context);
    return Scaffold(
      appBar: DeskstopAppBar(title: 'admin_login'.tr(), isClickable: false),
      body: adminAuthData.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: adminAuthData.loginFormKey,
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.30,
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
                      SizedBox(
                        width: 450,
                        child: TextFormField(
                          controller: adminAuthData.loginEmailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            } else if (value.length < 6) {
                              return 'Phone number must have at least 6 characters';
                            } else if (value.contains(' ')) {
                              return 'Email should not contain spaces';
                            } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return 'Enter a valid email';
                            }

                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            hintText: 'Enter admin email',
                            errorStyle: const TextStyle(
                              fontSize: 15,
                              color: AppColors.appAccent,
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: AppColors.appAccent),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildTitle(context, 'password'.tr()),
                      SizedBox(
                        width: 450,
                        child: TextFormField(
                          controller: adminAuthData.loginPasswordController,
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
                          obscureText: true,
                          autocorrect: false,
                          decoration: InputDecoration(
                            hintText: 'Enter admin password',
                            errorStyle: const TextStyle(
                              fontSize: 15,
                              color: AppColors.appAccent,
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: AppColors.appAccent),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                        width: 450,
                        child: ElevatedButton(
                          onPressed: adminAuthData.isLoading
                              ? null
                              : () => adminAuthData.adminLogin(context),
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text(
                            'login'.tr(),
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
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                return const HomeScreen();
                              }));
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 20),
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
