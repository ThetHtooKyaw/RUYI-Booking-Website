import 'package:flutter/material.dart';
import 'package:ruyi_booking/screens/admins/authentication/login/desktop_login_screen.dart';
import 'package:ruyi_booking/screens/admins/authentication/login/mobile_login_screen.dart';
import 'package:ruyi_booking/widgets/cores/responsive_layout.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
        mobileBody: MobileLoginScreen(),
        deskstopBody: DesktopLoginScreen(),
      ),
    );
  }
}
