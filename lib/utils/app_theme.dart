import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppTheme {
  static const purple = Color(0xFF8B5CF6);
  static const blue = Color(0xFF3B82F6);
  static const bg = Color(0xFF0E0E1A);
  static const card = Color(0xFF1A1A2E);
  static const gradient = LinearGradient(
    colors: [purple, blue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bg,
        colorScheme: ColorScheme.fromSeed(seedColor: purple, brightness: Brightness.dark),
        appBarTheme: const AppBarTheme(
          backgroundColor: bg,
          elevation: 0,
          titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: card,
          indicatorColor: purple.withOpacity(0.35),
        ),
      );
}

String todayStr() => DateFormat('yyyy-MM-dd').format(DateTime.now());
String addDays(String d, int n) =>
    DateFormat('yyyy-MM-dd').format(DateTime.parse(d).add(Duration(days: n)));
