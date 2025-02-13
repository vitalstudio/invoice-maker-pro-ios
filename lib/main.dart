import 'dart:io';
// import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/constants/app_constants/App_Constants.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:window_manager/window_manager.dart';
import 'core/constants/app_constants/app_bindings.dart';
import 'core/constants/color/color.dart';
import 'core/languages/languages.dart';
import 'core/preferenceManager/sharedPreferenceManager.dart';
import 'core/routes/routes.dart';

void main() async {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // Initialize FFI
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  try {
    WidgetsFlutterBinding.ensureInitialized();

    await SharedPreferencesManager.initialize();

    if(Platform.isAndroid || Platform.isIOS){
      await Firebase.initializeApp();
      debugPrint('Firebase initialized successfully');
    }

    if(Platform.isMacOS || Platform.isWindows){
      await windowManager.ensureInitialized();
      WindowOptions windowOptions = const WindowOptions(
        minimumSize: Size(850,600),
        center: true,
        backgroundColor: Colors.transparent,
        skipTaskbar: false,
        titleBarStyle: TitleBarStyle.normal,
      );
      windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.show();
        await windowManager.focus();
      });
    }

    AppConstants.setPlatformType();

  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }

  runApp(
      // DevicePreview(enabled: true, builder: (context) => const MyApp())
      const MyApp()
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: Languages(),
      initialBinding: AppBindings(),
      locale: const Locale('en', 'US'),
      debugShowCheckedModeBanner: false,
      title: 'Invoice Maker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: mainPurpleColor),
        useMaterial3: true,
      ),
      initialRoute: Routes.splashView,
      getPages: Routes.pages,
    );
  }
}
