import 'dart:async';

import 'package:anti_procastination/presentation/screens/home/home.dart';
import 'package:anti_procastination/presentation/screens/onboarding/login.dart';
import 'package:flutter/material.dart';

import '../../../storage/model/local_user_model.dart';
import '../../../storage/storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Storage storage = Storage();

  @override
  void initState() {
    Timer(const Duration(seconds: 2), () async {
      LocalUserModel? response = await storage.getSignInInfo();
      if (response?.uuid != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Home()));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              width: size.width / 3,
              child: Image.asset(
                "assets/images/logo.png",
              ),
            ),
          ),
          // const SizedBox(
          //   height: 20,
          // ),
          // Text(
          //   "Welcome to DisciplineX",
          //   style: Theme.of(context).textTheme.headlineSmall!.copyWith(
          //         color: Colors.white,
          //         fontWeight: FontWeight.w500,
          //       ),
          // ),
        ],
      ),
    );
  }
}
