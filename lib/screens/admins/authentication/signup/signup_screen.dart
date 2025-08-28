import 'package:flutter/material.dart';
import 'package:ruyi_booking/screens/admins/authentication/signup/desktop_signup_screen.dart';
import 'package:ruyi_booking/screens/admins/authentication/signup/mobile_signup_screen.dart';
import 'package:ruyi_booking/widgets/cores/responsive_layout.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobileBody: MobileSignUpScreen(),
      deskstopBody: DesktopSignUpScreen(),
    );
  }
}
