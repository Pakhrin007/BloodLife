import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:bloodlife/DonorsSectionPages/dashboard.dart';
import 'package:bloodlife/SignupandSignPages/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 200),
              child: SizedBox(
                width: 400,
                height: 400,
                child: LottieBuilder.asset("assets/lottie/anime1.json"),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          const Center(
            child: Text(
              "BloodLife",
              style: TextStyle(
                fontFamily: 'pacificio',
                fontSize: 30,
              ),
            ),
          )
        ],
      ),
      nextScreen: const Loginpage(),
      splashIconSize: double.infinity,
      backgroundColor: Colors.white,
    );
  }
}
