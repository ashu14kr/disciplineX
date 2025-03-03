import 'package:anti_procastination/constants.dart';
import 'package:anti_procastination/presentation/screens/onboarding/ask_questions.dart';
import 'package:flutter/material.dart';

import 'helper_widget.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Select Tags"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Choose 1 tag that best represent your major goal!",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
              ),
            ),
            const SizedBox(height: 30),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: availableTags.map((tag) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTags = tag;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          selectedTags == tag ? mainColor : Colors.transparent,
                      border: Border.all(
                          color: selectedTags == tag ? mainColor : Colors.grey,
                          width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        tag,
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: selectedTags == tag
                                  ? Colors.white
                                  : Colors.black,
                            ),
                      ),
                    ),
                  ),
                );
                // FilterChip(
                //   label: Text(tag),
                //   selected: isSelected,
                //   onSelected: (bool selected) {
                //     setState(() {
                //       if (selected)
                //         selectedTags.add(tag);
                //       else
                //         selectedTags.remove(tag);
                //     });
                //   },
                //   selectedColor: Colors.deepPurple,
                //   checkmarkColor: Colors.white,
                // );
              }).toList(),
            ),
            // Next button; disabled until at least 3 tags are selected.
            const SizedBox(
              height: 40,
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  if (selectedTags.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please Select a Tag"),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AskQuestions(),
                      ),
                    );
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
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
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
    );
  }
}
