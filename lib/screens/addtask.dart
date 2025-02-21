import 'package:anti_procastination/constants.dart';
import 'package:flutter/material.dart';

import '../core/services/task.dart';
import '../storage/model/local_user_model.dart';
import '../storage/storage.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TextEditingController taskController = TextEditingController();
  double betAmount = 1; // Default bet amount
  String selectedPriority = "Medium";
  String selectedTime = "30 min";

  List<String> timeOptions = ["30 min", "1 hour", "2 hours", "3+ hours"];
  Storage storage = Storage();
  Task task = Task();

  addTask() async {
    final response = await storage.getSignInInfo();
    if (response != null) {
      await task.addTask(taskController.text, selectedPriority, selectedTime,
          "NotCompleted", betAmount.toInt(), response.uuid);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Create New Task",
            style: Theme.of(context).textTheme.headlineSmall),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Name Input
            const Text("Task Name",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
            const SizedBox(height: 5),
            TextField(
              controller: taskController,
              decoration: InputDecoration(
                hintText: "Enter task...",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20),

            // Priority Selection
            const Text(
              "Priority Level",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ["High", "Medium", "Low"].map((priority) {
                Color priorityColor = priority == "High"
                    ? Colors.red
                    : priority == "Medium"
                        ? Colors.orange
                        : Colors.green;
                IconData icon = priority == "High"
                    ? Icons.whatshot
                    : priority == "Medium"
                        ? Icons.flash_on
                        : Icons.access_time;

                return GestureDetector(
                  onTap: () => setState(() => selectedPriority = priority),
                  child: Card(
                    color: selectedPriority == priority
                        ? priorityColor
                        : const Color.fromARGB(255, 255, 255, 255),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Row(
                        children: [
                          Icon(
                            icon,
                            color: selectedPriority == priority
                                ? Colors.white
                                : mainColor,
                          ),
                          const SizedBox(width: 5),
                          Text(priority,
                              style: TextStyle(
                                  color: selectedPriority == priority
                                      ? Colors.white
                                      : Colors.black)),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Time to Complete
            const Text("Select Time",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
            const SizedBox(height: 5),
            DropdownButtonFormField<String>(
              value: selectedTime,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              items: timeOptions.map((time) {
                return DropdownMenuItem(value: time, child: Text(time));
              }).toList(),
              onChanged: (value) => setState(() => selectedTime = value!),
            ),
            const SizedBox(height: 20),

            // Bet Amount Slider
            Text("Bet Amount (\$${betAmount.toStringAsFixed(0)})",
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
            Slider(
              value: betAmount,
              min: 1,
              max: 50,
              divisions: 49,
              label: "\$${betAmount.toStringAsFixed(0)}",
              onChanged: (value) => setState(() => betAmount = value),
              activeColor: mainColor,
              inactiveColor: Colors.deepPurple[100],
            ),
            const SizedBox(height: 30),

            // Create Task Button
            Center(
              child: InkWell(
                onTap: () {
                  addTask();
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
                      "Create Task",
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
    );
  }
}
