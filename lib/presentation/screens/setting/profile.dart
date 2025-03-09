import 'package:anti_procastination/constants.dart';
import 'package:anti_procastination/presentation/screens/setting/bounty.dart';
import 'package:anti_procastination/presentation/screens/onboarding/login.dart';
import 'package:anti_procastination/storage/storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'setting_helper.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();
    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    Text(
                      "Settings",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        CupertinoIcons.arrow_branch,
                        color: Colors.transparent,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 120,
                  width: Size.infinite.width,
                  decoration: BoxDecoration(
                    color: boxbgColor,
                    borderRadius: BorderRadius.circular(16),
                    // border: Border.all(
                    //   color: Colors.white,
                    // ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.white,
                        blurRadius: 0.3,
                        offset: Offset(
                          0.3,
                          0.3,
                        ),
                      ),
                    ],
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Flexible(child: CalendarGrid()),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "App",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.white),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: Size.infinite.width,
                  decoration: BoxDecoration(
                    // border: Border.all(
                    //   color: Colors.white,
                    // ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.white,
                        blurRadius: 0.3,
                        offset: Offset(
                          0.3,
                          0.3,
                        ),
                      ),
                    ],
                    color: boxbgColor,
                    borderRadius: BorderRadius.circular(
                      16,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        SettingInfo(
                          title: 'Reward',
                          icon: CupertinoIcons.gift,
                          color: const Color.fromARGB(255, 205, 141, 92),
                          ontap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const BountyScreen()));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "General",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.white),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 325,
                  width: Size.infinite.width,
                  decoration: BoxDecoration(
                    // border: Border.all(
                    //   color: Colors.white,
                    // ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.white,
                        blurRadius: 0.3,
                        offset: Offset(
                          0.3,
                          0.3,
                        ),
                      ),
                    ],
                    color: boxbgColor,
                    borderRadius: BorderRadius.circular(
                      16,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        SettingInfo(
                          title: 'Website',
                          icon: CupertinoIcons.globe,
                          color: const Color.fromARGB(255, 92, 205, 96),
                          ontap: () {},
                        ),
                        const Divider(
                          height: 1,
                          thickness: 0.3,
                          color: Color.fromARGB(255, 103, 103, 103),
                        ),
                        SettingInfo(
                          title: 'Follow on X',
                          icon: CupertinoIcons.xmark,
                          color: const Color.fromARGB(255, 0, 0, 0),
                          ontap: () {},
                        ),
                        const Divider(
                          height: 1,
                          thickness: 0.3,
                          color: Color.fromARGB(255, 103, 103, 103),
                        ),
                        SettingInfo(
                          title: 'Privacy Policy',
                          icon: CupertinoIcons.lock,
                          color: const Color.fromARGB(255, 236, 121, 196),
                          ontap: () {},
                        ),
                        const Divider(
                          height: 1,
                          thickness: 0.3,
                          color: Color.fromARGB(255, 103, 103, 103),
                        ),
                        SettingInfo(
                          title: 'Terms of Use',
                          icon: CupertinoIcons.doc_append,
                          color: const Color.fromARGB(255, 109, 255, 114),
                          ontap: () {},
                        ),
                        const Divider(
                          height: 1,
                          thickness: 0.3,
                          color: Color.fromARGB(255, 103, 103, 103),
                        ),
                        SettingInfo(
                          title: 'Rate the app',
                          icon: CupertinoIcons.star,
                          color: const Color.fromARGB(255, 132, 92, 205),
                          ontap: () {},
                        ),
                        const Divider(
                          height: 1,
                          thickness: 0.3,
                          color: Color.fromARGB(255, 103, 103, 103),
                        ),
                        SettingInfo(
                          title: 'Send feedback',
                          icon: CupertinoIcons.paperplane,
                          color: const Color.fromARGB(255, 0, 0, 0),
                          ontap: () async {
                            await storage.deleteSignInInfo();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 130,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    child: Text(
                      "DiscplineX 1.0",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    child: Text(
                      "Made with ❤️ and ☕️ by Ashutosh Kumar 2025",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
