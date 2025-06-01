import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ruyi_booking/screens/admin_screens/adminAuth_screens/admin_auth_screen.dart';
import 'package:ruyi_booking/screens/admin_screens/admin_screen.dart';
import 'package:ruyi_booking/screens/booking_screens/booking_screen.dart';
import 'package:ruyi_booking/screens/view_menu_screens/mobile_view_menu_screen.dart';
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
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: _buildAppBar(),
      body: ListView(
        children: [
          _buildHeader(context),
          const SizedBox(height: 30),
          Center(
            child: Text(
              'shop_name'.tr(),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontFamily: 'PlayfairDisplay',
                  fontSize: 27,
                  color: AppColors.appAccent),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              'sub_title'.tr(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 90),
            child: ButtonUtils.forwardButton(100, 'reserve'.tr(), () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const BookingScreen();
              }));
            }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 90),
            child: ButtonUtils.backwardButton(100, 'view_menu'.tr(), () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const MobileViewMenuScreen();
              }));
            }),
          ),
          const SizedBox(height: 40),
          const ImageSlider(indicaterLeft: 215),
          const SizedBox(height: 30),
          InfoTile(
              icon: Icons.access_time_filled_rounded,
              title: 'open_hour'.tr(),
              content: 'Daily : 9 AM - 10 PM'),
          const SizedBox(height: 20),
          InfoTile(
              icon: Icons.location_on_rounded,
              title: 'location'.tr(),
              content:
                  'Address : No.(1A/2B+2kha/2H), Mindama Street, (3)Ward Mayangone Township, Yangon'),
          const SizedBox(height: 20),
          InfoTile(
              icon: Icons.phone,
              title: 'contact_us'.tr(),
              content:
                  'Phone Number : 09-986619999, 09-986629999\nEmail : yinli5027770@gmail.com'),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  SizedBox _buildHeader(BuildContext context) {
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
                        fontSize: 27,
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 20),
                Text(
                  'home_sub_title'.tr(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.white),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.white,
      title: const MainLogo(height: 45, width: 45, isClickable: true),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const BookingScreen();
              }));
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
            ),
            child: const Text(
              'BOOK NOW',
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
          _buildDrawerTab(context, 'about'.tr(), () {}),
          const CustomDivider(),
          _buildDrawerTab(context, 'FAQ'.tr(), () {}),
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
          const CustomDivider(),
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
