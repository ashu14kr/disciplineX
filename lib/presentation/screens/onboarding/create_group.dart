import 'package:flutter/material.dart';

import '../../../constants.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  TextEditingController groupController = TextEditingController();
  double member = 5; // Default bet amount

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Create Group",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Task Name Input
              const Text("Group Name",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
              const SizedBox(height: 5),
              TextField(
                controller: groupController,
                decoration: InputDecoration(
                  hintText: "Enter group name...",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 20),

              const Text("Group Description",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
              const SizedBox(height: 5),
              TextField(
                controller: groupController,
                maxLines: 3,
                maxLength: 210,
                decoration: InputDecoration(
                  hintText: "Enter group description...",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 20),
              // Bet Amount Slider
              Text("Members count (${member.toStringAsFixed(0)})",
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 18)),
              Slider(
                value: member,
                min: 5,
                max: 12,
                divisions: 49,
                label: member.toStringAsFixed(0),
                onChanged: (value) => setState(() => member = value),
                activeColor: mainColor,
                inactiveColor: Colors.deepPurple[100],
              ),
              const SizedBox(height: 30),

              // Create Task Button
              Center(
                child: InkWell(
                  onTap: () {
                    // addTask();
                  },
                  child: Container(
                    width: 250,
                    height: 50,
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
                        "Create Group",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
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
