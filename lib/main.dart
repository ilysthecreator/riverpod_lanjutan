import 'package:riverpod_lanjutan/core/constants/constants.dart';
import 'package:riverpod_lanjutan/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:riverpod_lanjutan/features/dashboard/presentation/pages/dashboard_page.dart';

void main() {
  // runApp(const MyApp());
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const DashboardPage(),
    ); // MaterialApp
  }
}
