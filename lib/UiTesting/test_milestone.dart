import 'package:anti_procastination/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MilestonesScreen extends StatelessWidget {
  const MilestonesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 15, 15, 15),
      // appBar: AppBar(
      //   title: Text("Your Milestones"),
      //   centerTitle: true,
      // ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: const [
                    // MileStoneCard(),
                    // SizedBox(
                    //   height: 15,
                    // ),
                    // MileStoneCard(),
                    // SizedBox(
                    //   height: 15,
                    // ),
                    // MileStoneCard(),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) => const AddMilestoneScreen()),
              //     );
              //   },
              //   child: const Text("Add New Milestone"),
              // )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMilestoneCard(String title, String activities, String progress,
      IconData icon, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(activities,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(progress, style: const TextStyle(color: Colors.grey)),
          ],
        ),
        trailing:
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ),
    );
  }
}

class MileStoneCard extends StatelessWidget {
  const MileStoneCard({
    super.key,
    required this.ontap,
  });

  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color.fromARGB(255, 22, 22, 22),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 1,
            offset: Offset(1, 2),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 25,
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.red, Colors.red, Colors.orange],
                    ),
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: const Icon(
                    Icons.fitness_center_rounded,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Get back linkedin account engagement",
                        overflow: TextOverflow.ellipsis,
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "2 Activities",
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "💰\$500",
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          Text(
                            "5 Days Left",
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                IconButton(
                  onPressed: ontap,
                  icon: const Icon(
                    CupertinoIcons.forward,
                    size: 25,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            LinearProgressIndicator(
              color: mainColor,
              backgroundColor: Colors.white,
              minHeight: 10,
              borderRadius: BorderRadius.circular(16),
              value: 0.7,
            )
          ],
        ),
      ),
    );
  }
}

class AddMilestoneScreen extends StatelessWidget {
  const AddMilestoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Milestone")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Milestone Title",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const TextField(
                decoration: InputDecoration(
                    hintText: "E.g. Run 10km", border: OutlineInputBorder())),
            const SizedBox(height: 16),
            const Text("Deadline",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const TextField(
                decoration: InputDecoration(
                    hintText: "Select Date", border: OutlineInputBorder())),
            const SizedBox(height: 16),
            const Text("Description",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const TextField(
                decoration: InputDecoration(
                    hintText: "Describe your goal",
                    border: OutlineInputBorder())),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Save Milestone"),
            ),
          ],
        ),
      ),
    );
  }
}
