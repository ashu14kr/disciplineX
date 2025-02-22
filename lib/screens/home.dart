import 'dart:async';
import 'dart:ui';

import 'package:anti_procastination/constants.dart';
import 'package:anti_procastination/models/task_model.dart';
import 'package:anti_procastination/screens/addtask.dart';
import 'package:anti_procastination/screens/profile.dart';
import 'package:anti_procastination/screens/wallet.dart';
import 'package:flutter/material.dart';

import '../core/services/task.dart';
import '../storage/model/local_user_model.dart';
import '../storage/storage.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Storage storage = Storage();
  Task task = Task();
  List<TaskModel> taskModel = [];
  int _remainingSeconds = 0;
  Timer? _timer;
  bool _isRunning = false;

  _checkAndResumeTask() async {
    TaskModel? tasker;
    try {
      tasker = taskModel.firstWhere((e) => e.startedAt != null);
    } catch (e) {
      tasker = null;
    }

    if (tasker == null) {
      return;
    }

    DateTime startedAt = DateTime.parse(tasker.startedAt!);
    Duration elapsed = DateTime.now().difference(startedAt);

    int totalHours = int.parse(tasker.completionTime.split(" ")[0]);
    Duration totalDuration = Duration(hours: totalHours);

    Duration remaining = totalDuration - elapsed;
    if (remaining.isNegative) {
      await task.updateTaskStatus(tasker.id);
      remaining = Duration.zero;
    }
    setState(() {
      _remainingSeconds = remaining.inSeconds;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Resuming task started at ${tasker.startedAt}"),
        duration: const Duration(seconds: 3),
      ),
    );

    _startTimer();
  }

  double _calculateProgress() {
    // Attempt to find the first task with a non-null startedAt.
    TaskModel tasker;
    try {
      tasker = taskModel.firstWhere((e) => e.startedAt != null);
    } catch (e) {
      // No task found with a startedAt value.
      return 0.0;
    }

    // Extract total hours from the completionTime string (e.g., "1 hour")
    int totalHours = int.parse(tasker.completionTime.split(" ")[0]);
    int totalDurationSeconds = totalHours * 3600;

    // Guard against divide-by-zero.
    if (totalDurationSeconds == 0) return 0.0;

    // Calculate and return the progress fraction (0.0 to 1.0)
    return _remainingSeconds / totalDurationSeconds;
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
        // Timer reached zero, perform any desired action here.
      }
    });
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  getTask() async {
    LocalUserModel? response = await storage.getSignInInfo();
    if (response?.uuid != null) {
      final tasks = await task.getTasks(response!.uuid);
      tasks?.forEach((e) {
        setState(() {
          taskModel.add(e);
        });
      });
      _checkAndResumeTask();
    }
  }

  @override
  void initState() {
    getTask();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          left: 30,
        ),
        child: Container(
          height: 80,
          width: size.width,
          color: Colors.transparent,
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: mainColor,
                    borderRadius: BorderRadius.circular(
                      50,
                    ),
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 9.5,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddTaskScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 3,
                            offset: Offset(
                              2,
                              2,
                            ),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(
                          50,
                        ),
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.black,
                        size: 40,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(
          "DisciplineX",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Profile(),
              ),
            );
          },
          icon: const Icon(
            Icons.settings_outlined,
            size: 30,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Wallet(),
                ),
              );
            },
            icon: const Icon(
              Icons.wallet,
              size: 30,
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            Center(
              child: CustomPaint(
                painter: SquareProgressPainter(_calculateProgress()),
                child: Container(
                  height: size.height * 0.1,
                  width: size.width * 0.7,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(
                      16,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      // "04 : 32 : 04",
                      formatTime(Duration(seconds: _remainingSeconds)),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: InkWell(
                onTap: () async {
                  if (taskModel.any((e) => e.startedAt != null)) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("There is one onoging task!")));
                    return;
                  }
                  await task.updateTask(taskModel[0].id);
                  int hours =
                      int.parse(taskModel[0].completionTime.substring(0, 1));
                  _remainingSeconds = hours * 3600;
                  _startTimer();
                },
                child: Container(
                  height: size.height * 0.05,
                  width: size.width * 0.4,
                  decoration: BoxDecoration(
                    // color: const Color.fromARGB(255, 238, 255, 175),
                    color: taskModel.any((e) => e.startedAt != null)
                        ? const Color.fromARGB(255, 255, 255, 255)
                        : Colors.lightGreen,
                    borderRadius: BorderRadius.circular(
                      12,
                    ),
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),

                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 3,
                        offset: Offset(
                          3,
                          2,
                        ),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "DO IT NOW",
                      textAlign: TextAlign.center,
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: 19,
                              ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              "TASKS",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: taskModel.length,
                  itemBuilder: (context, index) {
                    return TaskWidget(
                      size: size,
                      taskModel: taskModel[index],
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskWidget extends StatelessWidget {
  const TaskWidget({
    super.key,
    required this.size,
    required this.taskModel,
  });

  final Size size;
  final TaskModel taskModel;

  @override
  Widget build(BuildContext context) {
    String monthName(int month) {
      switch (month) {
        case 1:
          return "Jan";
        case 2:
          return "Feb";
        case 3:
          return "Mar";
        case 4:
          return "Apr";
        case 5:
          return "May";
        case 6:
          return "Jun";
        case 7:
          return "Jul";
        case 8:
          return "Aug";
        case 9:
          return "Sep";
        case 10:
          return "Oct";
        case 11:
          return "Nov";
        case 12:
          return "Dec";
        default:
          return "Unknown";
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
        height: 160,
        width: size.width * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          ),
          boxShadow: const [
            BoxShadow(
              color: mainColor,
              blurRadius: 12,
              offset: Offset(
                4,
                4,
              ),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 25,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(
                    4,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    taskModel.priority,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                taskModel.name,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                  ),
                  Text(
                    " ${taskModel.createdAt.day.toString()} ${monthName(taskModel.createdAt.month)}",
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: Colors.black,
                        ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Container(
                    height: 35,
                    width: size.width * 0.3,
                    decoration: BoxDecoration(
                      color: taskModel.startedAt != null
                          ? Colors.lightGreen
                          : mainColor,
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        taskModel.startedAt != null ? "Running" : "START NOW",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 35,
                  ),
                  const Icon(
                    Icons.price_change,
                    color: Color.fromARGB(255, 122, 171, 102),
                    size: 24,
                  ),
                  Text(
                    "\$${taskModel.bet}",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                  ),
                  const SizedBox(
                    width: 14,
                  ),
                  const Icon(
                    Icons.lock_clock,
                    color: Colors.red,
                    size: 24,
                  ),
                  Text(
                    "${taskModel.completionTime}",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class RPSCustomPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     // Purple shadow (downward only)
//     Paint shadowPaint = Paint()
//       ..color = mainColor
//       ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

//     Path shadowPath = Path();
//     shadowPath.moveTo(size.width * -0.0001006,
//         size.height * -0.0054031 + 10); // Shift downward
//     shadowPath.lineTo(size.width * 0.0007368, size.height * 0.4946233 + 10);
//     shadowPath.lineTo(size.width * 0.0015659, size.height * 0.9960709 + 10);
//     shadowPath.lineTo(size.width * 0.2924189, size.height * 0.9960709 + 10);
//     shadowPath.lineTo(size.width * 0.5424297, size.height * 0.6360462 + 10);
//     shadowPath.lineTo(size.width * 1.0007883, size.height * 0.6360462 + 10);
//     shadowPath.lineTo(size.width * 0.9999509, size.height * -0.0039818 + 10);
//     shadowPath.lineTo(size.width * -0.0001006, size.height * -0.0054031 + 10);
//     shadowPath.close();

//     canvas.drawPath(shadowPath, shadowPaint);

//     // Layer 1 (main white shape)
//     Paint paintFill0 = Paint()
//       ..color = const Color.fromARGB(255, 255, 255, 255)
//       ..style = PaintingStyle.fill
//       ..strokeWidth = size.width * 0.00
//       ..strokeCap = StrokeCap.butt
//       ..strokeJoin = StrokeJoin.miter;

//     Path path0 = Path();
//     path0.moveTo(size.width * -0.0001006, size.height * -0.0054031);
//     path0.lineTo(size.width * 0.0007368, size.height * 0.4946233);
//     path0.lineTo(size.width * 0.0015659, size.height * 0.9960709);
//     path0.lineTo(size.width * 0.2924189, size.height * 0.9960709);
//     path0.lineTo(size.width * 0.5424297, size.height * 0.6360462);
//     path0.lineTo(size.width * 1.0007883, size.height * 0.6360462);
//     path0.lineTo(size.width * 0.9999509, size.height * -0.0039818);
//     path0.lineTo(size.width * -0.0001006, size.height * -0.0054031);
//     path0.close();

//     canvas.drawPath(path0, paintFill0);

//     // Stroke (border)
//     Paint paintStroke0 = Paint()
//       ..color = const Color.fromARGB(255, 0, 0, 0)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2
//       ..strokeCap = StrokeCap.round
//       ..strokeJoin = StrokeJoin.bevel;

//     canvas.drawPath(path0, paintStroke0);

//     // Corner Borders
//     Paint cornerBorderPaint = Paint()
//       ..color = Colors.black
//       ..strokeWidth = 4.0 // Bold border width
//       ..style = PaintingStyle.stroke;

//     // Top-left corner
//     canvas.drawLine(
//       Offset(0, 0),
//       Offset(size.width * 0.05, 0), // Horizontal
//       cornerBorderPaint,
//     );
//     canvas.drawLine(
//       Offset(0, 0),
//       Offset(0, size.height * 0.1), // Vertical
//       cornerBorderPaint,
//     );

//     // Top-right corner
//     canvas.drawLine(
//       Offset(size.width, 0),
//       Offset(size.width * 0.9, 0.5), // Horizontal
//       cornerBorderPaint,
//     );
//     canvas.drawLine(
//       Offset(size.width, 0),
//       Offset(size.width, size.height * 0.1), // Vertical
//       cornerBorderPaint,
//     );

//     // Bottom-left corner
//     canvas.drawLine(
//       Offset(0, size.height),
//       Offset(size.width * 0.05, size.height), // Horizontal
//       cornerBorderPaint,
//     );
//     canvas.drawLine(
//       Offset(0, size.height),
//       Offset(0, size.height * 0.9), // Vertical
//       cornerBorderPaint,
//     );
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }

class SquareProgressPainter extends CustomPainter {
  final double progress; // Progress value between 0 and 1

  SquareProgressPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = 12.0;
    double cornerRadius = 20.0;

    // Black Border Paint
    Paint borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Background Paint
    Paint backgroundPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Progress Paint (Blue Fill)
    Paint progressPaint = Paint()
      ..color = mainColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth - 2 // Thinner to allow black border
      ..strokeCap = StrokeCap.round;

    // Progress Border Paint (Black Border)
    Paint progressBorderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Tracking Circle Paint (Blue Fill)
    Paint circlePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Tracking Circle Border Paint (Black Border)
    Paint circleBorderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw Black Border (Outer Border of Full Square)
    Path borderPath = Path()
      ..addRRect(RRect.fromRectAndCorners(
        Offset.zero & size,
        topLeft: Radius.circular(cornerRadius),
        topRight: Radius.circular(cornerRadius),
        bottomLeft: Radius.circular(cornerRadius),
        bottomRight: Radius.circular(cornerRadius),
      ));
    canvas.drawPath(borderPath, borderPaint);

    // Draw Background Path (Grey Stroke)
    Path backgroundPath = Path()
      ..addRRect(RRect.fromRectAndCorners(
        Offset.zero & size,
        topLeft: Radius.circular(cornerRadius),
        topRight: Radius.circular(cornerRadius),
        bottomLeft: Radius.circular(cornerRadius),
        bottomRight: Radius.circular(cornerRadius),
      ));
    canvas.drawPath(backgroundPath, backgroundPaint);

    // Draw Progress Path
    PathMetrics pathMetrics = backgroundPath.computeMetrics();
    Path progressPath = Path();
    Offset? trackingCirclePosition;

    for (PathMetric metric in pathMetrics) {
      double progressLength = metric.length * progress;

      // Draw Black Border for Progress Path
      canvas.drawPath(
        metric.extractPath(0, progressLength),
        progressBorderPaint,
      );

      // Draw Blue Progress Path Inside Border
      progressPath.addPath(
        metric.extractPath(0, progressLength),
        Offset.zero,
      );

      // Find the position of the progress circle
      trackingCirclePosition =
          metric.getTangentForOffset(progressLength)?.position;
    }

    canvas.drawPath(progressPath, progressPaint);

    // Draw Tracking Circle (Blue Fill + Black Border)
    if (trackingCirclePosition != null) {
      canvas.drawCircle(trackingCirclePosition, strokeWidth, circlePaint);
      canvas.drawCircle(trackingCirclePosition, strokeWidth, circleBorderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
