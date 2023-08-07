import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lunar_calendar/screen/lunar_screen.dart';
import 'package:lunar_calendar/screen/main_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: '음력 생일 조회',
        home: const HomeScreen(),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('ko'),
          Locale('ja'),
          Locale('ch')
        ],
        routes: {
          '/solar': (context) => const HomeScreen(),
          '/lunar': (context) => const LunarScreen(),
        });
  }
}
