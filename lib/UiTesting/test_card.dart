import 'package:anti_procastination/constants.dart';
import 'package:flutter/material.dart';

import '../presentation/screens/home/home_helper.dart';

class TestCards extends StatefulWidget {
  const TestCards({super.key});

  @override
  State<TestCards> createState() => _TestCardsState();
}

class _TestCardsState extends State<TestCards> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              // TaskCard(),
            ],
          ),
        ),
      ),
    );
  }
}
