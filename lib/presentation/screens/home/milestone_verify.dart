import 'package:anti_procastination/constants.dart';
import 'package:anti_procastination/models/milestone_model.dart';
import 'package:anti_procastination/models/task_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../controllers/cubit/tasks_cubit.dart';
import '../../../storage/model/local_user_model.dart';
import '../../../storage/storage.dart';

class MilestoneVerificationScreen extends StatefulWidget {
  const MilestoneVerificationScreen({super.key, required this.model});

  final ModelMilestone model;

  @override
  _MilestoneVerificationScreenState createState() =>
      _MilestoneVerificationScreenState();
}

class _MilestoneVerificationScreenState
    extends State<MilestoneVerificationScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  bool isCompleted = true;

  Map<String, double> weekMap = {};
  Storage storage = Storage();

  Map<String, double> getWeekWithDistributedMinutes(
      DateTime startDate, DateTime endDate, List<TaskModel>? tasks) {
    Map<String, double> weekMap = {};

    // Initialize map with days from startDate to endDate
    DateTime currentDate = startDate;
    while (currentDate.isBefore(endDate) ||
        currentDate.isAtSameMomentAs(endDate)) {
      String dayName = DateFormat('EEE').format(currentDate);
      weekMap[dayName] = 0; // Default minutes set to 0
      currentDate = currentDate.add(const Duration(days: 1));
    }

    if (tasks == null || tasks.isEmpty) return weekMap;

    // Sort tasks by start date
    tasks.sort((a, b) =>
        DateTime.parse(a.startedAt!).compareTo(DateTime.parse(b.startedAt!)));

    for (var task in tasks) {
      if (task.startedAt != null) {
        DateTime taskDate = DateTime.parse(task.startedAt!);
        double remainingMinutes = task.completionTime.toDouble();

        while (remainingMinutes > 0) {
          String dayName = DateFormat("EEE").format(taskDate);

          double dailyMinutes = remainingMinutes.clamp(0, 1440);
          if (weekMap.containsKey(dayName)) {
            weekMap[dayName] = (weekMap[dayName] ?? 0) + dailyMinutes;
          }

          remainingMinutes -= dailyMinutes;
          taskDate = taskDate.add(const Duration(days: 1));
        }
      }
    }

    return weekMap;
  }

  getTask() async {
    LocalUserModel? response = await storage.getSignInInfo();
    if (response?.uuid != null) {
      context.read<TasksCubit>().getWeeksData(response!.uuid, widget.model);
    }
  }

  @override
  void initState() {
    super.initState();
    // weekMap = getWeekWithMinutes(widget.model.createdAt, widget.model.expiryAt);
    getTask();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      bottomNavigationBar: GestureDetector(
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
                "Marked As Completed",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Center(
                      child: Text(
                        'Milestone Verification',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.transparent),
                      onPressed: () => {},
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                BlocBuilder<TasksCubit, TasksState>(builder: (context, state) {
                  if (state is TasksWaiting) {
                    return Container(
                      child: const Text(
                        "data",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  } else if (state is TasksMinutes) {
                    weekMap = getWeekWithDistributedMinutes(
                      widget.model.createdAt,
                      widget.model.expiryAt,
                      state.task,
                    );
                    return VerticalActivityChart(
                      weeklyData: weekMap,
                      maxValue: 300,
                      barColor: Colors.green,
                      labelColor: Colors.white,
                    );
                  } else {
                    return Container(
                      child: const Text(
                        "data",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }
                }),
                const SizedBox(height: 20),
                // Stats Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    _buildStatCard('Total Activities',
                        '${widget.model.activities}', Icons.list_alt),
                    _buildStatCard('Completed', '9', Icons.check_box),
                    _buildStatCard('Pending', '3', Icons.pending_actions),
                    _buildStatCard(
                        'Active Days',
                        '${widget.model.active.length}/7',
                        Icons.calendar_today),
                  ],
                ),
                const SizedBox(height: 20),

                // Dates
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          'Start: ${DateFormat("dd-MM-yyyy").format(widget.model.createdAt)}',
                          style: const TextStyle(color: Colors.white54)),
                      Text(
                          'End: ${DateFormat("dd-MM-yyyy").format(widget.model.expiryAt)}',
                          style: const TextStyle(color: Colors.white54)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Verification Images
                // const Text('Verification Proofs',
                //     style: TextStyle(color: Colors.white, fontSize: 18)),
                // const SizedBox(height: 10),
                // Row(
                //   children: [
                //     _buildImagePreview('assets/img1.jpg'),
                //     const SizedBox(width: 10),
                //     _buildImagePreview('assets/img2.jpg'),
                //     const SizedBox(width: 10),
                //     _buildImagePreview('assets/img3.jpg'),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      color: boxbgColor,
      shadowColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.white54, size: 30),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                        const TextStyle(color: Colors.white54, fontSize: 12)),
                Text(
                  value,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(String assetPath) {
    return Expanded(
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // image: DecorationImage(
          //   image: AssetImage(assetPath),
          //   fit: BoxFit.cover,
          // ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white24),
          ),
        ),
      ),
    );
  }
}

class VerticalActivityChart extends StatelessWidget {
  final Map<String, double> weeklyData;
  final double maxValue;
  final Color barColor;
  final Color labelColor;

  const VerticalActivityChart({
    super.key,
    required this.weeklyData,
    required this.maxValue,
    this.barColor = Colors.blueAccent,
    this.labelColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: boxbgColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.white,
            blurRadius: 0.3,
            offset: Offset(0.3, 0.3),
          )
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          const Text('Weekly Activity Minutes',
              style: TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 20),
          CustomPaint(
            size: const Size(double.infinity, 250),
            painter: _VerticalChartPainter(
              weeklyData: weeklyData,
              maxValue: maxValue,
              barColor: barColor,
              labelColor: labelColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _VerticalChartPainter extends CustomPainter {
  final Map<String, double> weeklyData;
  final double maxValue;
  final Color barColor;
  final Color labelColor;

  _VerticalChartPainter({
    required this.weeklyData,
    required this.maxValue,
    required this.barColor,
    required this.labelColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final values = weeklyData.values.toList();
    final labels = weeklyData.keys.toList();
    final barWidth = size.width / values.length - 15;
    final chartHeight = size.height - 50;
    final valuePerUnit = chartHeight / maxValue;

    // Draw background grid
    final gridPaint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 0.8;

    for (double i = 0; i <= maxValue; i += 100) {
      final y = chartHeight - (i * valuePerUnit);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw gradient bars
    final barGradient = LinearGradient(
      colors: [
        barColor.withOpacity(0.8),
        barColor.withOpacity(0.4),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    for (int i = 0; i < values.length; i++) {
      final barHeight = values[i] * valuePerUnit;
      final x = i * (barWidth + 15) + 8;

      // Bar shadow
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTRB(x + 3, chartHeight - barHeight + 3, x + barWidth + 3,
              chartHeight + 3),
          const Radius.circular(4),
        ),
        Paint()..color = Colors.black.withOpacity(0.3),
      );

      // Main bar with gradient
      final barRect =
          Rect.fromLTRB(x, chartHeight - barHeight, x + barWidth, chartHeight);
      canvas.drawRRect(
        RRect.fromRectAndRadius(barRect, const Radius.circular(4)),
        Paint()..shader = barGradient.createShader(barRect),
      );

      // Animated value popup
      if (values[i] > 0) {
        final bubblePaint = Paint()
          ..color = barColor
          ..style = PaintingStyle.fill;

        final textY = chartHeight - barHeight - 25;

        // Draw connecting line
        canvas.drawLine(
          Offset(x + barWidth / 2, chartHeight - barHeight),
          Offset(x + barWidth / 2, textY + 15),
          Paint()
            ..color = barColor.withOpacity(0.5)
            ..strokeWidth = 1,
        );

        // Draw value bubble
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset(x + barWidth / 2, textY),
              width: 40,
              height: 20,
            ),
            const Radius.circular(10),
          ),
          bubblePaint,
        );

        _drawText(
          canvas,
          text: '${values[i].toInt()}',
          x: x + barWidth / 2,
          y: textY - 6,
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        );
      }

      // Day labels
      _drawText(
        canvas,
        text: labels[i],
        x: x + barWidth / 2,
        y: chartHeight + 15,
        color: labelColor.withOpacity(0.8),
        fontSize: 12,
      );
    }
  }

  void _drawText(
    Canvas canvas, {
    required String text,
    required double x,
    required double y,
    required Color color,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    final textStyle = TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      shadows: [
        Shadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 2,
          offset: const Offset(1, 1),
        )
      ],
    );

    final textSpan = TextSpan(text: text, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(x - textPainter.width / 2, y),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
