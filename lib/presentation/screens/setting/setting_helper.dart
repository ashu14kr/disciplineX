import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      DateTime(DateTime.now().year, 1, 2),
      DateTime(DateTime.now().year, 1, 3),
      DateTime(DateTime.now().year, 1, 4),
      DateTime(DateTime.now().year, 1, 5),
      DateTime(DateTime.now().year, 1, 6),
      DateTime(DateTime.now().year, 1, 7),
      DateTime(DateTime.now().year, 3, 4),
    ];
    final DateTime startDate = DateTime(2024, 8, 1); // Jan 1st of current year
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
                color: isDone
                    ? Colors.green
                    : const Color.fromARGB(255, 67, 89, 69),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          );
        },
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
