import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ruyi_booking/screens/admin_screens/admin_auth_screens/admin_auth_screen.dart';
import 'package:ruyi_booking/screens/admin_screens/admin_screen.dart';
import 'package:ruyi_booking/screens/booking_screens/booking_screen.dart';
import 'package:ruyi_booking/screens/view_menu_screens/mobile_menu_view/mobile_view_menu_screen.dart';
import 'package:ruyi_booking/utils/colors.dart';
import 'package:ruyi_booking/widgets/extras/custom_buttons.dart';
import 'package:ruyi_booking/widgets/extras/custom_divider.dart';
import 'package:ruyi_booking/widgets/extras/image_slider.dart';
import 'package:ruyi_booking/widgets/extras/info_tile.dart';
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
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontFamily: 'PlayfairDisplay',
                  fontSize: screenWidth < 430 ? 22 : 27,
                  color: AppColors.appAccent),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              'sub_title'.tr(),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: screenWidth < 430 ? 12 : 14),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 90),
            child: ButtonUtils.forwardButton(context, 100, 'reserve'.tr(), () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const BookingScreen();
              }));
            }, 17),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 90),
            child:
                ButtonUtils.backwardButton(context, 100, 'view_menu'.tr(), () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const MobileViewMenuScreen();
              }));
            }, 17),
          ),
          const SizedBox(height: 40),
          const ImageSlider(),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: InfoTile(
                icon: Icons.access_time_filled_rounded,
                title: 'open_hour'.tr(),
                content: 'Daily : 9 AM - 10 PM'),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: InfoTile(
                icon: Icons.location_on_rounded,
                title: 'location'.tr(),
                content:
                    'Address : No.(1A/2B+2kha/2H), Mindama Street, (3)Ward Mayangone Township, Yangon'),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: InfoTile(
                icon: Icons.phone,
                title: 'contact_us'.tr(),
                content:
                    'Phone Number : 09-986619999, 09-986629999\nEmail : yinli5027770@gmail.com'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  SizedBox _buildHeader(BuildContext context, double screenWidth) {
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
          Container(
            width: double.infinity,
            height: 450,
            color: Colors.black.withOpacity(0.3),
          ),
          Positioned(
            top: 170,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  'home_title'.tr(),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontFamily: 'PlayfairDisplay',
                        fontSize: screenWidth < 430 ? 22 : 27,
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 20),
                Text(
                  'home_sub_title'.tr(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontSize: screenWidth < 430 ? 12 : 14),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  AppBar _buildAppBar(double screenWidth) {
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
                horizontal: (screenWidth * 0.03).clamp(7.0, 14.0),
                vertical: (screenWidth * 0.038).clamp(6.0, 22.0),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
            ),
            child: Text(
              'BOOK NOW',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white, fontSize: screenWidth < 430 ? 12 : 14),
            ),
          ),
        )
      ],
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const SizedBox(height: 40),
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
              return const AdminAuthScreen();
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
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
