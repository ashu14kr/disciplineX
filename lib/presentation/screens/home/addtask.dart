import 'package:anti_procastination/constants.dart';
import 'package:anti_procastination/models/milestone_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controllers/cubit/tasks_cubit.dart';
import '../../../core/services/task.dart';
import '../../../storage/storage.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key, required this.model});

  final ModelMilestone model;

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TextEditingController taskController = TextEditingController();
  double betAmount = 1;
  String selectedPriority = "Medium";
  double selectedTime = 1;

  Storage storage = Storage();
  Task task = Task();

  addTask() async {
    if (taskController.text.isNotEmpty) {
      EasyLoading.show();
      final response = await storage.getSignInInfo();
      if (response != null) {
        await task.addTask(
          taskController.text,
          selectedPriority,
          selectedTime.toInt(),
          "NotCompleted",
          widget.model.id,
          response.uuid,
        );
        task.updateMilestoneActivity(
            widget.model.id, widget.model.activities += 1);
        context
            .read<TasksCubit>()
            .getTasks(response.uuid, widget.model, context);
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
          addTask();
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
                "Create Task",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: SafeArea(
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
                        CupertinoIcons.clear,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                    Text(
                      'Create New Task',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    const Icon(
                      Icons.abc,
                      color: Colors.transparent,
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                // Task Name Input
                const Text(
                  "Task Name",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  controller: taskController,
                  decoration: InputDecoration(
                    fillColor: boxbgColor,
                    filled: true,
                    hintText: "Enter task...",
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 111, 111, 111)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 20),

                // Priority Selection
                const Text(
                  "Priority Level",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Colors.white,
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
                            : boxbgColor,
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
                              Text(
                                priority,
                                style: TextStyle(
                                  color: selectedPriority == priority
                                      ? Colors.white
                                      : Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                // Time to Complete
                Text(
                  "Select Minutes (${selectedTime.toStringAsFixed(0) == "1" ? "${selectedTime.toStringAsFixed(0)} Min" : "${selectedTime.toStringAsFixed(0)} Mins"})",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                Slider(
                  value: selectedTime,
                  min: 1,
                  max: 180,
                  divisions: 49,
                  label: selectedTime.toStringAsFixed(0),
                  onChanged: (value) => setState(() => selectedTime = value),
                  activeColor: mainColor,
                  inactiveColor: Colors.deepPurple[100],
                ),
                // const SizedBox(height: 20),
                // // Bet Amount Slider
                // Text(
                //   "Bet Amount (\$${betAmount.toStringAsFixed(0)})",
                //   style: const TextStyle(
                //     fontWeight: FontWeight.w500,
                //     fontSize: 18,
                //     color: Colors.white,
                //   ),
                // ),
                // Slider(
                //   value: betAmount,
                //   min: 1,
                //   max: 50,
                //   divisions: 49,
                //   label: "\$${betAmount.toStringAsFixed(0)}",
                //   onChanged: (value) => setState(() => betAmount = value),
                //   activeColor: mainColor,
                //   inactiveColor: Colors.deepPurple[100],
                // ),
                // const SizedBox(height: 30),

                // // Create Task Button
                // Center(
                //   child: InkWell(
                //     onTap: () {
                //       addTask();
                //     },
                //     child: Container(
                //       width: 250,
                //       height: 50,
                //       decoration: BoxDecoration(
                //         color: mainColor,
                //         borderRadius: BorderRadius.circular(18),
                //         border: Border.all(
                //           color: Colors.black,
                //           width: 2,
                //         ),
                //       ),
                //       child: Center(
                //         child: Text(
                //           "Create Task",
                //           style:
                //               Theme.of(context).textTheme.bodyLarge!.copyWith(
                //                     color: Colors.white,
                //                     fontWeight: FontWeight.w600,
                //                   ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
