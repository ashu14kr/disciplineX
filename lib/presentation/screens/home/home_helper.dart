import 'dart:ui';

import 'package:anti_procastination/models/milestone_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../models/task_model.dart';

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

class TaskWidget extends StatelessWidget {
  const TaskWidget({
    super.key,
    required this.size,
    required this.taskModel,
    required this.ontap,
  });

  final Size size;
  final TaskModel taskModel;
  final VoidCallback ontap;

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
          color: const Color.fromARGB(255, 35, 35, 35),
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          ),
          // boxShadow: const [
          //   BoxShadow(
          //     color: mainColor,
          //     blurRadius: 3,
          //     offset: Offset(
          //       4,
          //       4,
          //     ),
          //   ),
          // ],
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
              SizedBox(
                width: size.width * 0.9,
                height: 24,
                child: Text(
                  taskModel.name,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
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
                    color: Colors.white,
                  ),
                  Text(
                    " ${taskModel.createdAt.day.toString()} ${monthName(taskModel.createdAt.month)}",
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: ontap,
                    child: Container(
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
                          style:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 22,
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
                          color: Colors.white,
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
                    "${taskModel.completionTime} Mins",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Colors.white,
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

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.ontap,
    required this.model,
  });

  final VoidCallback ontap;
  final TaskModel model;

  @override
  Widget build(BuildContext context) {
    String monthName(int month) {
      switch (month) {
        case 1:
          return "January";
        case 2:
          return "February";
        case 3:
          return "March";
        case 4:
          return "April";
        case 5:
          return "May";
        case 6:
          return "June";
        case 7:
          return "July";
        case 8:
          return "August";
        case 9:
          return "September";
        case 10:
          return "October";
        case 11:
          return "November";
        case 12:
          return "December";
        default:
          return "Unknown";
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        height: 164,
        width: Size.infinite.width,
        decoration: BoxDecoration(
            color: boxbgColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 0.3,
                offset: Offset(0.3, 0.3),
              )
            ]),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: model.priority == "Medium"
                          ? const Color.fromARGB(255, 213, 160, 0)
                          : model.priority == "Low"
                              ? Colors.green
                              : Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 3,
                      ),
                      child: Text(
                        model.priority,
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 9),
                  SizedBox(
                    width: 260,
                    child: Text(
                      model.name,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  const SizedBox(height: 9),
                  Row(
                    children: [
                      const Icon(
                        CupertinoIcons.clock,
                        color: Colors.grey,
                        size: 23,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        "${model.completionTime} Mins",
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 9),
                  Row(
                    children: [
                      Text(
                        "Date:",
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: Colors.grey),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        "${model.createdAt.day.toString()} ${monthName(model.createdAt.month)}",
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: ontap,
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: mainColor,
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: Icon(
                    model.startedAt == null
                        ? CupertinoIcons.play_arrow_solid
                        : CupertinoIcons.pause_solid,
                    shadows: const [
                      Shadow(
                        color: Color.fromARGB(255, 20, 20, 20),
                        blurRadius: 3,
                        offset: Offset(3, 5),
                      ),
                    ],
                    size: 40,
                    color: Colors.white,
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

class MileStoneCard extends StatelessWidget {
  const MileStoneCard({
    super.key,
    required this.ontap,
    required this.model,
  });

  final VoidCallback ontap;
  final ModelMilestone model;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color.fromARGB(255, 14, 14, 14),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 0.3,
            offset: Offset(0.3, 0.3),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 25,
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    gradient: gradients[model.gradient],
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: Icon(
                    icons[model.icon],
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        model.name,
                        overflow: TextOverflow.ellipsis,
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        model.activities == 0
                            ? "No Activities"
                            : "${model.activities} Activities",
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            model.stakes == null
                                ? "Free"
                                : "💰\$${model.stakes}",
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          Text(
                            "${model.expiryAt.difference(DateTime.now()).inDays} Days Left",
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                IconButton(
                  onPressed: ontap,
                  icon: const Icon(
                    CupertinoIcons.forward,
                    size: 25,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 15,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 2, 2, 2),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: ListView.builder(
                  itemCount: 7,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    List lis = model.active;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 3,
                      ),
                      child: Container(
                        height: 12,
                        width: 44,
                        decoration: BoxDecoration(
                          color: lis.contains(index)
                              ? Colors.green
                              : const Color.fromARGB(255, 67, 89, 69),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // LinearProgressIndicator(
            //   color: mainColor,
            //   backgroundColor: Colors.white,
            //   minHeight: 10,
            //   borderRadius: BorderRadius.circular(16),
            //   value: 0.7,
            // )
          ],
        ),
      ),
    );
  }
}

class CustomFloatingBtn extends StatelessWidget {
  const CustomFloatingBtn({
    super.key,
    required this.size,
    required this.onTap,
  });

  final Size size;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  onTap: onTap,
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
