import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ruyi_booking/screens/admins/admin/admin_screen.dart';
import 'package:ruyi_booking/screens/admins/authentication/login/login_screen.dart';
import 'package:ruyi_booking/screens/bookings/booking/booking_screen.dart';
import 'package:ruyi_booking/screens/home/widgets/shop_content.dart';
import 'package:ruyi_booking/screens/menus/view_menu/view_menu_screen.dart';
import 'package:ruyi_booking/utils/constants.dart';
import 'package:ruyi_booking/widgets/extras/custom_buttons.dart';
import 'package:ruyi_booking/widgets/cores/image_slider.dart';
import 'package:ruyi_booking/widgets/cores/language_picker.dart';
import 'package:ruyi_booking/widgets/cores/main_logo.dart';
import 'package:ruyi_booking/screens/home/widgets/scrollable_appbar.dart';

class DesktopHomeScreen extends StatefulWidget {
  const DesktopHomeScreen({super.key});

  @override
  State<DesktopHomeScreen> createState() => _DesktopHomeScreenState();
}

class _DesktopHomeScreenState extends State<DesktopHomeScreen> {
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
                const SizedBox(height: 30),
                Center(
                  child: Text(
                    'shop_name'.tr(),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontFamily: 'PlayfairDisplay',
                        fontSize: 30,
                        color: AppColors.appAccent),
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
                    width: 400,
                    label: 'reserve'.tr(),
                    fontSize: 17,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
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
                    width: 400,
                    label: 'view_menu'.tr(),
                    fontSize: 17,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const ViewMenuScreen();
                      }));
                    },
                  ),
                ),
                const SizedBox(height: 60),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: ImageSlider(),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        flex: 6,
                        child: ShopContent(type: ShopContentType.desktopSize),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: 500,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/room2.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
            child: Container(
              color: Colors.black.withOpacity(0.25),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(AppSize.smallCardBorderRadius),
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
                            borderRadius: BorderRadius.circular(
                                AppSize.smallCardBorderRadius)),
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
            top: 125,
            left: 0,
            right: 0,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // InkWell(
                  //   onTap: () {},
                  //   child: Text(
                  //     'about'.tr(),
                  //     style: Theme.of(context)
                  //         .textTheme
                  //         .bodyLarge
                  //         ?.copyWith(color: Colors.white),
                  //   ),
                  // ),
                  // const SizedBox(width: 50),
                  // InkWell(
                  //   onTap: () {},
                  //   child: Text(
                  //     'FAQ'.tr(),
                  //     style: Theme.of(context)
                  //         .textTheme
                  //         .bodyLarge
                  //         ?.copyWith(color: Colors.white),
                  //   ),
                  // ),
                  // const SizedBox(width: 50),
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
                        return const LoginScreen();
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
          ),
          Positioned(
            top: 250,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  'home_title'.tr(),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
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
}
