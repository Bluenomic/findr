import 'package:flutter/material.dart';

import 'login_page.dart';
import 'sample_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final Widget? initialScreen;

  const MyApp({super.key, this.initialScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Findr',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.green,
          primary: AppColors.green,
          secondary: AppColors.green,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: AppColors.cream,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.cream,
          elevation: 0,
          scrolledUnderElevation: 0,
          iconTheme: IconThemeData(color: AppColors.ink),
          titleTextStyle: TextStyle(
            color: AppColors.ink,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      home: initialScreen ?? const LoginPage(),
    );
  }
}
