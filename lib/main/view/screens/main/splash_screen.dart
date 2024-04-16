// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  final Widget nextScreen;
  const SplashScreen({super.key, required this.nextScreen});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      curve: Curves.bounceOut,
      duration: 4000,
      splashTransition: SplashTransition.slideTransition,
      splashIconSize: 300,
      function: () async {
        Future.delayed(const Duration(seconds: 2));
      },
      splash: Container(
        decoration: const BoxDecoration(
            image:
                DecorationImage(image: AssetImage('assets/images/logo.png'))),
      ),
      nextScreen: widget.nextScreen,
      pageTransitionType: PageTransitionType.bottomToTop,
      animationDuration: const Duration(milliseconds: 2500),
    );
  }
}

// animated splash object
