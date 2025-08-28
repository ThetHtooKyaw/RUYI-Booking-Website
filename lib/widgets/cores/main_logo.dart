import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/booking_data_provider.dart';
import 'package:ruyi_booking/providers/menu_data_provider.dart';
import 'package:ruyi_booking/screens/home/home_screen.dart';
import 'package:ruyi_booking/utils/constants.dart';

class MainLogo extends StatelessWidget {
  final double height;
  final double width;
  final bool isClickable;

  const MainLogo({
    super.key,
    required this.height,
    required this.width,
    this.isClickable = false,
  });

  @override
  Widget build(BuildContext context) {
    var bookingDate = Provider.of<BookingDataProvider>(context);
    var menuData = Provider.of<MenuDataProvider>(context);

    return InkWell(
      onTap: isClickable
          ? () {
              () => bookingDate.resetForm(context, menuData.cartedItems);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return const HomeScreen();
              }));
            }
          : null,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(width: 3, color: AppColors.appAccent),
            borderRadius: BorderRadius.circular(30)),
        child: Image.asset(
          'assets/icons/logo.png',
          height: height,
          width: width,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
