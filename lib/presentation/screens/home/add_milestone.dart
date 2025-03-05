import 'package:anti_procastination/constants.dart';
import 'package:anti_procastination/core/services/task.dart';
import 'package:anti_procastination/storage/storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../../../controllers/cubit/milestone_cubit.dart';

class AddMilestone extends StatefulWidget {
  const AddMilestone({super.key});

  @override
  State<AddMilestone> createState() => _AddMilestoneState();
}

class _AddMilestoneState extends State<AddMilestone> {
  bool isStakes = false; // Toggle for Free or Stakes
  double stakeAmount = 10.0; // Default stake amount

  final TextEditingController name = TextEditingController();
  Task task = Task();
  Storage storage = Storage();

  // List of icons for selection
  final List<Map<String, IconData>> iconsList = [
    {'code': CupertinoIcons.chevron_left_slash_chevron_right},
    {'sports': CupertinoIcons.sportscourt},
    {'person': CupertinoIcons.person},
    {'nature': CupertinoIcons.tree},
    {'education': CupertinoIcons.book},
    {'text': CupertinoIcons.textformat},
    {'writing': CupertinoIcons.pencil},
    {'user': CupertinoIcons.person_solid},
    {'night': CupertinoIcons.moon_stars},
    {'water': CupertinoIcons.drop},
    {'shopping': CupertinoIcons.bag},
    {'analytics': CupertinoIcons.chart_bar_alt_fill},
    {'travel': CupertinoIcons.airplane},
    {'finance': CupertinoIcons.money_dollar},
    {'stats': CupertinoIcons.chart_bar},
    {'music': CupertinoIcons.music_mic},
    {'photography': CupertinoIcons.photo_camera},
    {'community': CupertinoIcons.person_2},
    {'health': CupertinoIcons.heart},
    {'business': CupertinoIcons.briefcase},
    {'art': CupertinoIcons.paintbrush},
  ];

  IconData? selectedIcon; // Selected icon
  String iconData = "code";
  String gradientData = "Red-Orange";

  final List<Map<String, LinearGradient>> gradientsList = [
    {
      "Blue-Purple": const LinearGradient(colors: [Colors.blue, Colors.purple])
    },
    {
      "Red-Orange": const LinearGradient(colors: [Colors.red, Colors.orange])
    },
    {
      "Green-Teal": const LinearGradient(colors: [Colors.green, Colors.teal])
    },
    {
      "Indigo-Blue":
          const LinearGradient(colors: [Colors.indigo, Colors.blueAccent])
    },
    {
      "Pink-Purple":
          const LinearGradient(colors: [Colors.pink, Colors.deepPurple])
    },
  ];

  LinearGradient? selectedGradient;

  void createMilestone() async {
    if (name.text.isEmpty) {
      EasyLoading.showToast("Pls enter name");
    } else {
      EasyLoading.show();
      final response = await storage.getSignInInfo();
      if (response != null) {
        task.addMilestone(name.text, 0, isStakes ? stakeAmount : null, iconData,
            gradientData, response.uuid);
        context.read<MilestoneCubit>().getMilestones(response.uuid);
        EasyLoading.dismiss();
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      bottomNavigationBar: GestureDetector(
        onTap: () {
          createMilestone();
        },
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
              controller: name,
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
              children: iconsList.map((icon) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIcon = icon.values.first;
                        iconData = icon.keys.first;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: boxbgColor,
                        border: Border.all(
                          color: selectedIcon == icon.values.first
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
                      child: Icon(icon.values.first,
                          size: 28, color: Colors.white),
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
              children: gradientsList.map((gradient) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedGradient = gradient.values.first;
                      gradientData = gradient.keys.first;
                    });
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: gradient.values.first,
                      shape: BoxShape.circle,
                      border: selectedGradient == gradient.values.first
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
