import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ruyi_booking/screens/admin_screens/admin_auth_screens/adminAuth_screen%20copy.dart';
import 'package:ruyi_booking/screens/admin_screens/admin_screen.dart';
import 'package:ruyi_booking/screens/booking_screens/booking_screen.dart';
import 'package:ruyi_booking/utils/colors.dart';
import 'package:ruyi_booking/widgets/extras/image_slider.dart';
import 'package:ruyi_booking/widgets/extras/infoTile.dart';
import 'package:ruyi_booking/widgets/cores/language_picker.dart';
import 'package:ruyi_booking/widgets/cores/main_logo.dart';
import 'package:ruyi_booking/widgets/cores/scrollable_appbar.dart';

class DeskstopHomeScreen extends StatefulWidget {
  const DeskstopHomeScreen({super.key});

  @override
  State<DeskstopHomeScreen> createState() => _DeskstopHomeScreenState();
}

class _DeskstopHomeScreenState extends State<DeskstopHomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showAppBar = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.offset > 200 && !_showAppBar) {
      setState(() {
        _showAppBar = true;
      });
    } else if (_scrollController.offset <= 200 && _showAppBar) {
      setState(() {
        _showAppBar = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          if (_showAppBar)
            ScrollableAppbar(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BookingScreen(),
                  ),
                );
              },
            ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildHeader(context),
                const SizedBox(height: 90),
                Center(
                  child: Text(
                    'shop_name'.tr(),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontFamily: 'PlayfairDisplay',
                        fontSize: 30,
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
                Center(
                  child: SizedBox(
                    width: 400,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const BookingScreen();
                        }));
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 22),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      child: Text(
                        'reserve'.tr(),
                        style: const TextStyle(fontSize: 17),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: SizedBox(
                    width: 400,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 22),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      child: Text(
                        'menu'.tr(),
                        style: const TextStyle(fontSize: 17),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                _buildContent(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            flex: 4,
            child: ImageSlider(indicaterLeft: 250),
          ),
          Expanded(
            flex: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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
                        'Phone Numberc: 09-986619999, 09-986629999\nEmail: '),
                const SizedBox(height: 20),
              ],
            ),
          )
        ],
      ),
    );
  }

  SizedBox _buildHeader(BuildContext context) {
    return SizedBox(
      height: 500,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
              child: Image.asset(
                'assets/images/room2.jpeg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 500,
            color: Colors.black.withOpacity(0.3),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BookingScreen(),
                            ));
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 25),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      child: const Text(
                        'BOOK NOW',
                      ),
                    ),
                  ),
                ),
                const MainLogo(height: 55, width: 55, isClickable: true),
                const LanguagePicker(
                  offset: 45,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          const Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Divider(thickness: 2),
          ),
          Positioned(
            top: 140,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {},
                  child: Text(
                    'about'.tr(),
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 50),
                InkWell(
                  onTap: () {},
                  child: Text(
                    'FAQ'.tr(),
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 50),
                InkWell(
                  onTap: () {
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
                  },
                  child: Text(
                    'admin'.tr(),
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 250,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  'home_title'.tr(),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontFamily: 'PlayfairDisplay',
                        fontSize: 30,
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
}
