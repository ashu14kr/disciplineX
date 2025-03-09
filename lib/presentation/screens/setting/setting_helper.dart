import 'package:anti_procastination/models/analytics_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarGrid extends StatefulWidget {
  final AnalyticsModel model;
  const CalendarGrid({super.key, required this.model});

  @override
  _CalendarGridState createState() => _CalendarGridState();
}

class _CalendarGridState extends State<CalendarGrid> {
  final ScrollController _scrollController = ScrollController();
  List<DateTime> done = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToEnd();
      widget.model.activeDays.forEach((e) {
        done.add(DateFormat("dd-MM-yyyy").parse(e));
      });
      setState(() {});
    });
  }

  void _scrollToEnd() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateTime startDate = DateTime(2024, 8, 1); // Jan 1st of current year
    final DateTime currentDate = DateTime.now();
    final int totalDays = currentDate.difference(startDate).inDays +
        1; // Days from startDate to today

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 100, // Set a maximum height
          minHeight: 80, // Set a minimum height
        ),
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
            bool isDone = done.any((doneDay) =>
                doneDay.year == currentDay.year &&
                doneDay.month == currentDay.month &&
                doneDay.day == currentDay.day);

            return SizedBox(
              height: 2,
              width: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: isDone
                      ? Colors.green
                      : const Color.fromARGB(255, 67, 89, 69),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          },
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
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
        IconButton(
          onPressed: ontap,
          icon: const Icon(
            CupertinoIcons.forward,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}
