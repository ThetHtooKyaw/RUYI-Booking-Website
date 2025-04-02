import 'package:flutter/material.dart';
import 'package:ruyi_booking/screens/home_screens/deskstopHomeScreen.dart';
import 'package:ruyi_booking/screens/home_screens/mobileHomeScreen.dart';
import 'package:ruyi_booking/widgets/cores/responsive_layout.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
        mobileBody: MobileHomeScreen(),
        deskstopBody: DeskstopHomeScreen(),
      ),
    );
  }
}
