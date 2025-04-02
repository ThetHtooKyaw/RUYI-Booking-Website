import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/adminAuthProvider.dart';
import 'package:ruyi_booking/screens/admin_screens/admin_auth_screens/mobileSignUpScreen.dart';
import 'package:ruyi_booking/utils/colors.dart';
import 'package:ruyi_booking/widgets/extras/custom_icon.dart';

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
                          ? Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                      context,
                                      adminAuthData.updateNameController,
                                      'Enter admin username', (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Username is required';
                                    } else if (value.length < 3) {
                                      return 'Username must have at least 3 characters';
                                    }

                                    return null;
                                  }),
                                ),
                                const SizedBox(width: 20),
                                _buildButtons(
                                  context,
                                  'done'.tr(),
                                  100,
                                  () async {
                                    await adminAuthData
                                        .updateAdminName(context);
                                  },
                                ),
                              ],
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
                                _buildTextField(
                                  context,
                                  adminAuthData.updateEmailController,
                                  'Enter new admin email',
                                  (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Email is required';
                                    } else if (value.length < 6) {
                                      return 'Phone number must have at least 6 characters';
                                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                        .hasMatch(value)) {
                                      return 'Enter a valid email';
                                    }

                                    return null;
                                  },
                                ),
                                const SizedBox(height: 10),
                                _buildPasswordTextField(
                                    adminAuthData
                                        .passwordForEmailUpdateController,
                                    'Enter old admin password'),
                                const SizedBox(height: 10),
                                _buildButtons(
                                  context,
                                  'done'.tr(),
                                  MediaQuery.of(context).size.width * 0.95,
                                  () async {
                                    await adminAuthData.updateEmail(context);
                                  },
                                ),
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
                                _buildPasswordTextField(
                                  adminAuthData
                                      .passwordForPasswordUpdateController,
                                  'Enter old admin password',
                                ),
                                const SizedBox(height: 10),
                                _buildPasswordTextField(
                                  adminAuthData.updatePasswordController,
                                  'Enter new admin password',
                                ),
                                const SizedBox(height: 10),
                                _buildButtons(
                                  context,
                                  'done'.tr(),
                                  MediaQuery.of(context).size.width * 0.95,
                                  () async {
                                    await adminAuthData.updatePassword(context);
                                  },
                                ),
                              ],
                            )
                          : _buildButtons(
                              context,
                              'change_password'.tr(),
                              450,
                              () {
                                setState(() {
                                  adminAuthData.setPasswordEdit(true);
                                });
                              },
                            ),
                      const SizedBox(height: 60),
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
                              adminAuthData.setNameEdit(false);
                              adminAuthData.setEmailEdit(false);
                              adminAuthData.setPasswordEdit(false);
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Text(
                              'cancel'.tr(),
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
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

  Container _buildButtons(
    BuildContext context,
    String name,
    double width,
    VoidCallback onPressed,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 5,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(
          name,
          style: const TextStyle(fontSize: 17),
        ),
      ),
    );
  }

  Widget _buildTextField(BuildContext context, TextEditingController controller,
      String hintText, String? Function(String?) validator) {
    return SizedBox(
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

  Widget _buildPasswordTextField(
      TextEditingController controller, String hintText) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.95,
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
          }

          return null;
        },
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
