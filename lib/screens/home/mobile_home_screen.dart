import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ruyi_booking/screens/admins/admin/admin_screen.dart';
import 'package:ruyi_booking/screens/admins/authentication/login/login_screen.dart';
import 'package:ruyi_booking/screens/bookings/booking/booking_screen.dart';
import 'package:ruyi_booking/screens/home/widgets/shop_content.dart';
import 'package:ruyi_booking/screens/menus/view_menu/view_menu_screen.dart';
import 'package:ruyi_booking/screens/menus/widgets/small_button.dart';
import 'package:ruyi_booking/utils/constants.dart';
import 'package:ruyi_booking/widgets/extras/custom_buttons.dart';
import 'package:ruyi_booking/widgets/extras/custom_divider.dart';
import 'package:ruyi_booking/widgets/cores/image_slider.dart';
import 'package:ruyi_booking/widgets/cores/language_picker.dart';
import 'package:ruyi_booking/widgets/cores/main_logo.dart';

class MobileHomeScreen extends StatefulWidget {
  const MobileHomeScreen({super.key});

  @override
  State<MobileHomeScreen> createState() => _MobileHomeScreenState();
}

class _MobileHomeScreenState extends State<MobileHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: _buildAppBar(screenWidth),
      body: ListView(
        children: [
          _buildHeader(context, screenWidth),
          const SizedBox(height: 30),
          Center(
            child: Text(
              'shop_name'.tr(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontFamily: 'PlayfairDisplay',
                    color: AppColors.appAccent,
                  ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              'sub_title'.tr(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 90),
            child: ButtonUtils.forwardButton(
              context: context,
              width: 100,
              label: 'reserve'.tr(),
              fontSize: 17,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const BookingScreen();
                }));
              },
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 90),
            child: ButtonUtils.backwardButton(
              context: context,
              width: 100,
              label: 'view_menu'.tr(),
              fontSize: 17,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const ViewMenuScreen();
                }));
              },
            ),
          ),
          const SizedBox(height: 40),
          const ImageSlider(),
          const SizedBox(height: 30),
          const ShopContent(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double screenWidth) {
    return SizedBox(
      height: 450,
      width: double.infinity,
      child: Stack(
        children: [
          Image.asset(
            'assets/images/room2.jpeg',
            fit: BoxFit.fill,
            width: double.infinity,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
            child: Container(
              color: Colors.black.withOpacity(0.25),
            ),
          ),
          Positioned(
            top: 170,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  'home_title'.tr(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontFamily: 'PlayfairDisplay',
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 20),
                Text(
                  'home_sub_title'.tr(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.white),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(double screenWidth) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.white,
      title: const MainLogo(height: 45, width: 45, isClickable: true),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: screenWidth < 430 ? 4 : 10),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const BookingScreen();
              }));
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                vertical: screenWidth <= 414 ? 8 : 20,
                horizontal: screenWidth <= 414 ? 8 : 10,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppSize.smallCardBorderRadius)),
            ),
            child: Text(
              'BOOK NOW',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const SizedBox(height: 60),
          const LanguagePicker(
            offset: -35,
            color: Colors.black,
          ),
          const SizedBox(height: 40),
          // _buildDrawerTab(context, 'about'.tr(), () {}),
          // const CustomDivider(),
          // _buildDrawerTab(context, 'FAQ'.tr(), () {}),
          const CustomDivider(),
          _buildDrawerTab(context, 'admin'.tr(), () {
            if (FirebaseAuth.instance.currentUser != null) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return const AdminScreen();
              }));
              return;
            }
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return const LoginScreen();
            }));
          }),
          // const CustomDivider(),
        ],
      ),
    );
  }

  InkWell _buildDrawerTab(
      BuildContext context, String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
