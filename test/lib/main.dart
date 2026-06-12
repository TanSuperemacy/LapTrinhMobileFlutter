import 'package:flutter/material.dart';
import 'core/app_colors.dart';
import 'screens/hub_screen.dart';
import 'screens/thi_screen.dart';
import 'screens/fulltest_list_screen.dart';
import 'screens/listening_screen.dart';

void main() => runApp(const TOEICMasterApp());

class TOEICMasterApp extends StatelessWidget {
  const TOEICMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TOEIC Master',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.appBarBg,
          foregroundColor: AppColors.appBarFg,
          elevation: 0,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/':              (_) => const HubScreen(),
        '/listening':     (_) => const ListeningScreen(),
        '/thi':           (_) => const ThiScreen(),
        '/fulltest-list': (_) => const FulltestListScreen(),
      },
    );
  }
}
