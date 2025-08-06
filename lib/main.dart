import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/firebase_options.dart';
import 'package:ruyi_booking/providers/admin_auth_provider.dart';
import 'package:ruyi_booking/providers/booking_data_provider.dart';
import 'package:ruyi_booking/providers/menu_data_provider.dart';
import 'package:ruyi_booking/screens/home_screens/home_screen.dart';
import 'package:ruyi_booking/utils/asset_loader.dart';
import 'package:ruyi_booking/utils/menu_data.dart';
import 'package:ruyi_booking/utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await EasyLocalization.ensureInitialized();
  await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('zh'), Locale('my')],
      path: 'translations',
      fallbackLocale: const Locale('en'),
      assetLoader: const LocalAssetLoader(),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => BookingDataProvider()),
          ChangeNotifierProvider(create: (context) => AdminAuthProvider()),
          ChangeNotifierProvider(
              create: (context) => MenuDataProvider()..loadMenuData()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: appTheme,
      home: const HomeScreen(),
    );
  }

  // void onClick(map) async {
  //   final storageRef = FirebaseStorage.instance.ref();

  //   final menuData = await json.decode(utf8
  //       .decode((await storageRef.child('menu/menu_data.json').getData())!));

  //   FirebaseStorage.instance
  //       .ref("data/menu_data.json")
  //       .putData(Uint8List.fromList(jsonEncode(menuData).codeUnits));
  // }
}
