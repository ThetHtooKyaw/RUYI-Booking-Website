import 'package:flutter/material.dart';
import 'package:ruyi_booking/utils/colors.dart';

final ThemeData appTheme = ThemeData(
  fontFamily: 'Noto Sans',
  useMaterial3: true,
  brightness: Brightness.dark,
  primaryColor: AppColors.appAccent,
  scaffoldBackgroundColor: AppColors.appBackground,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.appBackground,
    foregroundColor: AppColors.appText,
    iconTheme: IconThemeData(
      color: AppColors.appText,
    ),
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: AppColors.appBackground,
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: AppColors.appAccent,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColors.appText),
    bodyMedium: TextStyle(color: AppColors.appText),
    bodySmall: TextStyle(color: AppColors.appText),
  ),
  iconTheme: const IconThemeData(color: AppColors.appAccent),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      textStyle: const TextStyle(
          fontFamily: 'Montserrat',
          letterSpacing: 1.8,
          fontWeight: FontWeight.bold),
      backgroundColor: AppColors.appButton,
      foregroundColor: AppColors.appBackground,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      textStyle: WidgetStateProperty.all(
        const TextStyle(
            fontFamily: 'Montserrat',
            letterSpacing: 1.8,
            fontWeight: FontWeight.bold),
      ),
      side: WidgetStateProperty.all(
          const BorderSide(width: 3, color: AppColors.appButton)),
      foregroundColor: WidgetStateProperty.all(AppColors.appButton),
      backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.hovered)) {
          return AppColors.hoverColor;
        }
        return Colors.transparent;
      }),
    ),
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: AppColors.appAccent,
    selectionColor: AppColors.appAccent.withOpacity(0.5),
    selectionHandleColor: AppColors.appAccent,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    prefixIconColor: AppColors.appBackground,
    hintStyle: TextStyle(
      color: Colors.grey[500],
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStateProperty.all(AppColors.appButton),
    checkColor: WidgetStateProperty.all(AppColors.appBackground),
    side: const BorderSide(color: AppColors.appButton),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: AppColors.appBackground,
  ),
  popupMenuTheme: const PopupMenuThemeData(
    color: AppColors.appAccent,
  ),
  hoverColor: AppColors.hoverColor,
  dividerTheme: const DividerThemeData(
    color: AppColors.appAccent,
    thickness: 1,
  ),
  datePickerTheme: DatePickerThemeData(
    backgroundColor: Colors.white,
    surfaceTintColor: AppColors.appBackground,
    headerForegroundColor: Colors.black,
    todayBackgroundColor: WidgetStateProperty.all(AppColors.hoverColor),
    todayForegroundColor: WidgetStateProperty.all(Colors.black),
    dayForegroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.white;
      }
      return Colors.black;
    }),
    dayBackgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.appAccent;
      }
      return Colors.transparent;
    }),
    yearForegroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.white;
      }
      return Colors.black;
    }),
    yearBackgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.appAccent;
      }
      return Colors.transparent;
    }),
    weekdayStyle:
        const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    confirmButtonStyle: ButtonStyle(
      foregroundColor: WidgetStateProperty.all(Colors.black),
    ),
    cancelButtonStyle: ButtonStyle(
      foregroundColor: WidgetStateProperty.all(Colors.black),
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    dividerColor: AppColors.appAccent,
  ),
);
