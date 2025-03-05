import 'package:anti_procastination/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddMilestone extends StatefulWidget {
  const AddMilestone({super.key});

  @override
  State<AddMilestone> createState() => _AddMilestoneState();
}

class _AddMilestoneState extends State<AddMilestone> {
  bool isStakes = false; // Toggle for Free or Stakes
  double stakeAmount = 10.0; // Default stake amount

  // List of icons for selection
  final List<IconData> icons = [
    CupertinoIcons.chevron_left_slash_chevron_right,
    CupertinoIcons.sportscourt,
    CupertinoIcons.person,
    CupertinoIcons.tree,
    CupertinoIcons.book,
    CupertinoIcons.textformat,
    CupertinoIcons.pencil,
    CupertinoIcons.person_solid,
    CupertinoIcons.moon_stars,
    CupertinoIcons.drop,
    CupertinoIcons.bag,
    CupertinoIcons.chart_bar_alt_fill,
    CupertinoIcons.airplane,
    CupertinoIcons.money_dollar,
    CupertinoIcons.chart_bar,
    CupertinoIcons.music_mic,
    CupertinoIcons.photo_camera,
    CupertinoIcons.person_2,
    CupertinoIcons.heart,
    CupertinoIcons.briefcase,
    CupertinoIcons.paintbrush,
  ];

  IconData? selectedIcon; // Selected icon

  final List<LinearGradient> gradients = [
    const LinearGradient(colors: [Colors.blue, Colors.purple]),
    const LinearGradient(colors: [Colors.red, Colors.orange]),
    const LinearGradient(colors: [Colors.green, Colors.teal]),
    const LinearGradient(colors: [Colors.indigo, Colors.blueAccent]),
    const LinearGradient(colors: [Colors.pink, Colors.deepPurple]),
  ];

  LinearGradient? selectedGradient;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      bottomNavigationBar: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 25),
          child: Container(
            width: 250,
            height: 60,
            decoration: BoxDecoration(
              color: mainColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.black,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                "Create Milestone",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text(
          "Create Milestone",
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
        ),
        centerTitle: true,
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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 15,
            ),
            const Text(
              "Name",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              style: const TextStyle(color: Colors.white),
              // controller: taskController,
              decoration: InputDecoration(
                hintText: "Enter Title...",
                fillColor: boxbgColor,
                filled: true,
                hintStyle:
                    const TextStyle(color: Color.fromARGB(255, 111, 111, 111)),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Select Mode",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                Switch(
                  activeTrackColor: Colors.green,
                  value: isStakes,
                  onChanged: (value) {
                    setState(() {
                      isStakes = value;
                    });
                  },
                ),
              ],
            ),
            Text(
              isStakes ? "Mode: Stakes" : "Mode: Free",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isStakes) ...[
              const SizedBox(height: 10),
              const Text(
                "Select Stake Amount",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Slider(
                value: stakeAmount,
                activeColor: mainColor,
                min: 10,
                max: 100,
                divisions: 9,
                label: stakeAmount.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    stakeAmount = value;
                  });
                },
              ),
              Text(
                "Selected Stakes: \$${stakeAmount.round()}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
            const SizedBox(height: 20),
            const Text(
              "Icons",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 15,
              children: icons.map((icon) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIcon = icon;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: boxbgColor,
                        border: Border.all(
                          color: selectedIcon == icon
                              ? Colors.white
                              : Colors.transparent,
                          width: 1,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 0.1,
                            offset: Offset(0.1, 0.1),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Icon(icon, size: 28, color: Colors.white),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              "Colors",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: gradients.map((gradient) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedGradient = gradient;
                    });
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: gradient,
                      shape: BoxShape.circle,
                      border: selectedGradient == gradient
                          ? Border.all(color: Colors.white, width: 5)
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
