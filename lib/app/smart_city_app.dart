import 'package:flutter/material.dart';

import '../screens/app_shell.dart';

class SmartCityApp extends StatefulWidget {
  const SmartCityApp({super.key});

  @override
  State<SmartCityApp> createState() => _SmartCityAppState();
}

class _SmartCityAppState extends State<SmartCityApp> {
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF167D68);
    return MaterialApp(
      title: 'Civicly · Smart City',
      debugShowCheckedModeBanner: false,
      themeMode: _darkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.light,
          surface: const Color(0xFFFCFDFD),
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F7F7),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF4F7F7),
          surfaceTintColor: Colors.transparent,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.dark,
          surface: const Color(0xFF17211F),
        ),
        scaffoldBackgroundColor: const Color(0xFF101715),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF101715),
          surfaceTintColor: Colors.transparent,
        ),
      ),
      home: AppShell(
        darkMode: _darkMode,
        onThemeChanged: (value) => setState(() => _darkMode = value),
      ),
    );
  }
}
