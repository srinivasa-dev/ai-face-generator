import 'dart:async';

import 'package:ai_face_generator/home_screen.dart';
import 'package:ai_face_generator/models/theme_provider.dart';
import 'package:ai_face_generator/services/fake_face_service.dart';
import 'package:ai_face_generator/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
    await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return  ChangeNotifierProvider(
      create: (_) {
        return themeChangeProvider;
      },
      child: Consumer<DarkThemeProvider>(
        builder: (context, value1, child) {
          return MaterialApp(
            theme: Styles.themeData(themeChangeProvider.darkTheme, context),
            debugShowCheckedModeBanner: false,
            home: MultiRepositoryProvider(
              providers: [
                RepositoryProvider(
                  create: (context) => FakeFaceService(),
                ),
              ],
              child: const SplashScreen(),
            ),
          );
        },
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 4),
            () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LottieBuilder.asset('assets/lottie_animations/face_scan.json'),
      ),
    );
  }
}

