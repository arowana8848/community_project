import 'dart:async';
import 'package:community/core/services/storage/user_session_service.dart';
import 'package:community/features/auth/presentation/pages/login_screen.dart';
import 'package:community/features/dashboard/presentation/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      // Check if user is already logged in
    final userSessionService = ref.read(userSessionServiceProvider);
    final isLoggedIn = userSessionService.isLoggedIn();

    if (isLoggedIn) {
      // Navigate to Dashboard if user is logged in
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    } else {
      // Navigate to Onboarding if user is not logged in
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Image(
          image: AssetImage('assets/icons/logo_main.png'),
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}