import 'package:expy/common/color_extension.dart';
import 'package:expy/view/maintab/home_screen.dart';

import 'package:expy/view/onboarding/welcome_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'finlog',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: "Inter",
          colorScheme: ColorScheme.fromSeed(
            seedColor: TColor.primary,
            surface: TColor.gray80,
            primary: TColor.primary,
            primaryContainer: TColor.gray60,
            secondary: TColor.secondary,
          ),
          useMaterial3: false),
      home: const HomeScreen(),
    );
  }
}
