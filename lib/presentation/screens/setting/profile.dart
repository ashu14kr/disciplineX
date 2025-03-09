import 'package:anti_procastination/constants.dart';
import 'package:anti_procastination/presentation/screens/analytics/analytics_screen.dart';
import 'package:anti_procastination/presentation/screens/setting/bounty.dart';
import 'package:anti_procastination/presentation/screens/onboarding/login.dart';
import 'package:anti_procastination/presentation/screens/wallet/wallet.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close,
            color: Colors.white,
            size: 30,
          ),
        ),
        title: Text(
          "Settings",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  "App",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.white),
                ),
                const SizedBox(height: 10),

                // Your content container
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.white,
                        blurRadius: 0.3,
                        offset: Offset(0.3, 0.3),
                      ),
                    ],
                    color: boxbgColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        SettingInfo(
                          title: 'Analytics',
                          icon: CupertinoIcons.chart_bar_alt_fill,
                          color: const Color.fromARGB(255, 0, 104, 152),
                          ontap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AnalyticsScreen()),
                            );
                          },
                        ),
                        const Divider(
                            height: 1,
                            thickness: 0.3,
                            color: Color.fromARGB(255, 103, 103, 103)),
                        SettingInfo(
                          title: 'Roadmap',
                          icon: CupertinoIcons.flag_fill,
                          color: const Color.fromARGB(255, 255, 147, 59),
                          ontap: () {},
                        ),
                        const Divider(
                            height: 1,
                            thickness: 0.3,
                            color: Color.fromARGB(255, 103, 103, 103)),
                        SettingInfo(
                          title: 'Wallet',
                          icon: CupertinoIcons.creditcard_fill,
                          color: const Color.fromARGB(255, 72, 206, 0),
                          ontap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Wallet()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "General",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.white),
                ),
                const SizedBox(height: 10),

                Container(
                  height: 325,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.white,
                        blurRadius: 0.3,
                        offset: Offset(0.3, 0.3),
                      ),
                    ],
                    color: boxbgColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        SettingInfo(
                            title: 'Website',
                            icon: CupertinoIcons.globe,
                            color: Color.fromARGB(255, 92, 205, 96),
                            ontap: () {}),
                        const Divider(
                            height: 1,
                            thickness: 0.3,
                            color: Color.fromARGB(255, 103, 103, 103)),
                        SettingInfo(
                            title: 'Follow on X',
                            icon: CupertinoIcons.xmark,
                            color: Color.fromARGB(255, 0, 0, 0),
                            ontap: () {}),
                        const Divider(
                            height: 1,
                            thickness: 0.3,
                            color: Color.fromARGB(255, 103, 103, 103)),
                        SettingInfo(
                            title: 'Privacy Policy',
                            icon: CupertinoIcons.lock,
                            color: Color.fromARGB(255, 236, 121, 196),
                            ontap: () {}),
                        const Divider(
                            height: 1,
                            thickness: 0.3,
                            color: Color.fromARGB(255, 103, 103, 103)),
                        SettingInfo(
                            title: 'Terms of Use',
                            icon: CupertinoIcons.doc_append,
                            color: Color.fromARGB(255, 109, 255, 114),
                            ontap: () {}),
                        const Divider(
                            height: 1,
                            thickness: 0.3,
                            color: Color.fromARGB(255, 103, 103, 103)),
                        SettingInfo(
                            title: 'Rate the app',
                            icon: CupertinoIcons.star,
                            color: Color.fromARGB(255, 132, 92, 205),
                            ontap: () {}),
                        const Divider(
                            height: 1,
                            thickness: 0.3,
                            color: Color.fromARGB(255, 103, 103, 103)),
                        SettingInfo(
                            title: 'Send feedback',
                            icon: CupertinoIcons.paperplane,
                            color: Color.fromARGB(255, 0, 0, 0),
                            ontap: () async {
                              await storage.deleteSignInInfo();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()));
                            }),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: MediaQuery.of(context).size.height / 10),

                Center(
                  child: Column(
                    children: [
                      Text(
                        "DiscplineX 1.0",
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Made with ❤️ and ☕️ by Ashutosh Kumar 2025",
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                    ],
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
