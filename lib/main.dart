import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/firebase_options.dart';
import 'package:ruyi_booking/providers/admin_auth_provider.dart';
import 'package:ruyi_booking/providers/booking_data_provider.dart';
import 'package:ruyi_booking/providers/menu_data_provider.dart';
import 'package:ruyi_booking/screens/home/home_screen.dart';
import 'package:ruyi_booking/utils/asset_loader.dart';
import 'package:ruyi_booking/utils/constants.dart';
import 'package:ruyi_booking/utils/theme.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    // Initialize EasyLocalization with error handling
    try {
      await EasyLocalization.ensureInitialized();
    } catch (e) {
      debugPrint('Warning: EasyLocalization initialization failed: $e');
      // Continue without localization if it fails
    }

    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);

    runApp(
      EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('zh'), Locale('my')],
        path: 'translations',
        fallbackLocale: const Locale('en'),
        assetLoader: const LocalAssetLoader(),
        errorWidget: (error) {
          debugPrint('EasyLocalization error: $error');
          return const SizedBox.shrink();
        },
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
  } catch (e) {
    // You could show an error screen here or continue with basic functionality
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: const Color(0xFFF2EAE2),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSize.screenPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo or Icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.appAccent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.error_outline,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Error Title
                  const Text(
                    'RUYI Booking',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.appAccent,
                      fontFamily: 'PlayfairDisplay',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Error Message
                  const Text(
                    'Initialization Error',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Error Details
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Unable to initialize the application properly.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Error: $e',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Retry Button
                  ElevatedButton(
                    onPressed: () {
                      // Restart the app or attempt to reinitialize
                      main();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.appAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSize.cardBorderRadius),
                      ),
                    ),
                    child: const Text(
                      'Retry Initialization',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
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
}
