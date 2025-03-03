import 'package:anti_procastination/constants.dart';
import 'package:anti_procastination/presentation/screens/onboarding/groups.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'helper_widget.dart';

class AskQuestions extends StatefulWidget {
  const AskQuestions({super.key});

  @override
  State<AskQuestions> createState() => _AskQuestionsState();
}

class _AskQuestionsState extends State<AskQuestions> {
  final TextEditingController goal = TextEditingController();
  final TextEditingController detailedgoal = TextEditingController();
  final TextEditingController outcome = TextEditingController();
  int index = 1;
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<QuestionModel> questions = [
      QuestionModel(
        question: "What is your major goal?",
        widget: customTextEdit(
          hint: 'Enter your major goal',
          label: 'Goal Title',
          controller: goal,
          error: 'Please enter your goal title',
        ),
      ),
      QuestionModel(
        question: "Plz describe your goal in detail?",
        widget: customTextEdit(
          hint: 'Describe your goal in detail',
          label: 'Goal Description',
          controller: detailedgoal,
          error: 'Please describe your goal',
        ),
      ),
      QuestionModel(
        question: "what you want to achieve?",
        widget: customTextEdit(
          hint: 'Enter your desired outcome',
          label: 'Desired Outcome',
          controller: outcome,
          error: 'Please enter your desired outcome',
        ),
      ),
      QuestionModel(
        question: "What is your Deadline?",
        widget: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: InkWell(
              onTap: () => _selectDate(context),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.black),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      selectedDate == null
                          ? "Select Deadline"
                          : "Deadline: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              LinearProgressIndicator(
                value: index / questions.length,
                minHeight: 10,
                color: mainColor,
                borderRadius: BorderRadius.circular(
                  12,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if ((index - 1) > 0) {
                        setState(() {
                          index--;
                        });
                      }
                    },
                    child: const Icon(
                      CupertinoIcons.back,
                      size: 30,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    questions[index - 1].question,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              questions[index - 1].widget,
              const SizedBox(
                height: 40,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    if ((index - 1) < questions.length - 1) {
                      if (index == 1) {
                        if (goal.text.isNotEmpty) {
                          setState(() {
                            index++;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please add a goal"),
                            ),
                          );
                        }
                      } else if (index == 2) {
                        if (detailedgoal.text.isNotEmpty) {
                          setState(() {
                            index++;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please discribe your goal"),
                            ),
                          );
                        }
                      } else if (index == 3) {
                        if (outcome.text.isNotEmpty) {
                          setState(() {
                            index++;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please add expected outcome"),
                            ),
                          );
                        }
                      }
                    } else if (index == 4) {
                      if (selectedDate != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Groups(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please add a deadline"),
                          ),
                        );
                      }
                    }
                  },
                  child: Container(
                    width: 130,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Next",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: Colors.white,
                                ),
                          ),
                        ],
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
