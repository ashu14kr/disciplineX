import 'package:anti_procastination/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestCards extends StatefulWidget {
  const TestCards({super.key});

  @override
  State<TestCards> createState() => _TestCardsState();
}

class _TestCardsState extends State<TestCards> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 164,
                width: Size.infinite.width,
                decoration: BoxDecoration(
                    color: boxbgColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 0.3,
                        offset: Offset(0.3, 0.3),
                      )
                    ]),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 3,
                              ),
                              child: Text(
                                "High",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 9),
                          SizedBox(
                            width: 260,
                            child: Text(
                              "Get back linkedin account",
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 9),
                          Row(
                            children: [
                              const Icon(
                                CupertinoIcons.clock,
                                color: Colors.grey,
                                size: 23,
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Text(
                                "1 mins",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 9),
                          Row(
                            children: [
                              Text(
                                "Date:",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(color: Colors.grey),
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Text(
                                "13 August",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 18, 88, 0),
                              Color.fromARGB(255, 0, 142, 36),
                              Color.fromARGB(255, 98, 255, 0)
                            ],
                          ),
                          borderRadius: BorderRadius.circular(35),
                        ),
                        child: const Icon(
                          CupertinoIcons.play_arrow_solid,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
