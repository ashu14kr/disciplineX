import 'package:anti_procastination/presentation/screens/setting/bounty.dart';
import 'package:anti_procastination/presentation/screens/onboarding/login.dart';
import 'package:anti_procastination/storage/storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Settings",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const Center(
              //   child: CircleAvatar(
              //     backgroundColor: mainColor,
              //     radius: 35,
              //   ),
              // ),
              // const SizedBox(
              //   height: 15,
              // ),
              // Text(
              //   "Ashutosh Kumar",
              //   style: Theme.of(context)
              //       .textTheme
              //       .headlineSmall!
              //       .copyWith(fontWeight: FontWeight.w500),
              // ),
              // Container(
              //   height: 70,
              //   width: Size.infinite.width,
              //   decoration: BoxDecoration(
              //     border: Border.all(
              //       color: Colors.black,
              //     ),
              //     borderRadius: BorderRadius.circular(
              //       16,
              //     ),
              //   ),
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              Container(
                height: 120,
                width: Size.infinite.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.black,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 3,
                      offset: Offset(
                        2,
                        2,
                      ),
                    ),
                  ],
                ),
                child: const Column(
                  children: [
                    Flexible(child: CalendarGrid()),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "App",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: Size.infinite.width,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
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
                                  builder: (context) => const BountyScreen()));
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
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 325,
                width: Size.infinite.width,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
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
                      color: const Color.fromARGB(255, 0, 0, 0),
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
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                    textAlign: TextAlign.center,
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

class SettingInfo extends StatelessWidget {
  const SettingInfo({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.ontap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
        IconButton(
          onPressed: ontap,
          icon: const Icon(
            CupertinoIcons.forward,
            color: Colors.black,
          ),
        )
      ],
    );
  }
}

class CalendarGrid extends StatefulWidget {
  const CalendarGrid({super.key});

  @override
  _CalendarGridState createState() => _CalendarGridState();
}

class _CalendarGridState extends State<CalendarGrid> {
  final ScrollController _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToEnd();
    });
  }

  void _scrollToEnd() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> _done = [
      DateTime(DateTime.now().year, 1, 1),
      DateTime(DateTime.now().year, 1, 2),
      DateTime(DateTime.now().year, 1, 3),
      DateTime(DateTime.now().year, 1, 4),
      DateTime(DateTime.now().year, 1, 5),
      DateTime(DateTime.now().year, 1, 6),
      DateTime(DateTime.now().year, 1, 7),
      DateTime(DateTime.now().year, 2, 7),
    ];
    // final DateTime startDate =
    //     DateTime.now().subtract(const Duration(days: totalDays - 1));
    final DateTime startDate = DateTime(2022, 1, 1); // Jan 1st of current year
    final DateTime currentDate = DateTime.now();
    final int totalDays = currentDate.difference(startDate).inDays +
        1; // Days from startDate to today

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GridView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
        ),
        itemCount: totalDays,
        itemBuilder: (context, index) {
          DateTime currentDay = startDate.add(Duration(days: index));

          // Check if the day is in _done list
          bool isDone = _done.any((doneDay) =>
              doneDay.year == currentDay.year &&
              doneDay.month == currentDay.month &&
              doneDay.day == currentDay.day);
          return SizedBox(
            height: 2,
            width: 2,
            child: Container(
              decoration: BoxDecoration(
                color: isDone ? Colors.green : Colors.green[100],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          );
        },
      ),
    );
  }
}
