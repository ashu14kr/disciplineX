import 'dart:math';

import 'package:anti_procastination/constants.dart';
import 'package:anti_procastination/controllers/cubit/analytics_cubit.dart';
import 'package:anti_procastination/models/analytics_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../storage/model/local_user_model.dart';
import '../../../storage/storage.dart';
import '../setting/setting_helper.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  Storage storage = Storage();

  get() async {
    LocalUserModel? response = await storage.getSignInInfo();
    if (response?.uuid != null) {
      context.read<AnalyticsCubit>().getAnalytics(response!.uuid);
    }
  }

  @override
  void initState() {
    get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Analytics",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
        ),
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: BlocBuilder<AnalyticsCubit, AnalyticsState>(
          builder: (context, state) {
            if (state is AnalyticsInitial) {
              return SizedBox(
                height: MediaQuery.of(context).size.height / 1.2,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: mainColor,
                  ),
                ),
              );
            } else if (state is AnalyticsLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WeeklyActivityChart(
                    weeksData: state.analyticsModel!.weeks,
                  ),
                  const SizedBox(height: 15),
                  _buildActivityCalendar(context, state.analyticsModel),
                  const SizedBox(height: 15),
                  _buildTimeTracking(
                      state.analyticsModel?.totalMinSpend.toString()),
                  const SizedBox(height: 15),
                  _buildTimeComparison(state.analyticsModel),
                  const SizedBox(height: 15),
                ],
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  Widget _buildActivityCalendar(BuildContext context, AnalyticsModel? model) {
    return Container(
      height: 155,
      width: Size.infinite.width,
      decoration: BoxDecoration(
        color: boxbgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.white,
            blurRadius: 0.3,
            offset: Offset(
              0.3,
              0.3,
            ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Total active days: ${model!.activeDays.length}",
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(color: Colors.grey),
                ),
                // const SizedBox(
                //   width: 15,
                // ),
                // Text(
                //   "Max streak:3",
                //   style: Theme.of(context)
                //       .textTheme
                //       .labelLarge!
                //       .copyWith(color: Colors.grey),
                // ),
              ],
            ),
          ),
          Flexible(
              child: CalendarGrid(
            model: model,
          )),
        ],
      ),
    );
  }

  Widget _buildTimeTracking(String? mins) {
    return Container(
      decoration: BoxDecoration(
        color: boxbgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.white,
            blurRadius: 0.3,
            offset: Offset(
              0.3,
              0.3,
            ),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.timer, color: Colors.blueAccent, size: 20),
              SizedBox(width: 8),
              Text('Time Invested',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          Text(mins!,
              style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2)),
          Text('minutes',
              style: TextStyle(fontSize: 14, color: Colors.grey[400])),
        ],
      ),
    );
  }

  Widget _buildTimeComparison(AnalyticsModel? model) {
    String spendHr = model!.totalMinSpend > 60
        ? ("${model.totalMinSpend / 60}h").toString()
        : ("${model.totalMinSpend}mins").toString();
    return Container(
      decoration: BoxDecoration(
        color: boxbgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.white,
            blurRadius: 0.3,
            offset: Offset(
              0.3,
              0.3,
            ),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text('Spent',
                    style: TextStyle(fontSize: 14, color: Colors.grey[400])),
                Text(spendHr,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.greenAccent)),
              ],
            ),
          ),
          Container(
            height: 50,
            width: 1,
            color: Colors.grey[700],
          ),
          Expanded(
            child: Column(
              children: [
                Text('Planned',
                    style: TextStyle(fontSize: 14, color: Colors.grey[400])),
                const Text('8.0h',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          const Icon(Icons.hourglass_bottom,
              color: Colors.blueAccent, size: 40),
        ],
      ),
    );
  }

  Widget _buildProgressTrend() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple[900]!, Colors.blue[900]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.trending_up, color: Colors.white70, size: 20),
              SizedBox(width: 8),
              Text('Progress Trend',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 180,
            child: CustomPaint(
              painter: _TrendPainter(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final data = [0.8, 0.6, 0.7, 0.9, 0.5, 0.8, 0.7, 0.9];
    final paint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.greenAccent.withOpacity(0.3), Colors.transparent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTRB(0, 0, size.width, size.height));

    final path = Path();
    path.moveTo(0, size.height * (1 - data[0]));

    for (int i = 1; i < data.length; i++) {
      final x = size.width * (i / (data.length - 1));
      final y = size.height * (1 - data[i]);
      path.lineTo(x, y);
    }

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    // Draw grid
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 0.5;

    // Vertical grid
    for (int i = 1; i < data.length; i++) {
      final x = size.width * (i / data.length);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    // Horizontal grid
    for (int i = 1; i < 5; i++) {
      final y = size.height * (i / 5);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint..style = PaintingStyle.stroke);

    // Draw data points
    final circlePaint = Paint()
      ..color = Colors.greenAccent
      ..style = PaintingStyle.fill;

    for (int i = 0; i < data.length; i++) {
      final x = size.width * (i / (data.length - 1));
      final y = size.height * (1 - data[i]);
      canvas.drawCircle(Offset(x, y), 3, circlePaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

DateTime _currentWeekStart = _getStartOfWeek(DateTime.now());

DateTime _getStartOfWeek(DateTime date) {
  var startDate = date.subtract(Duration(days: date.weekday - 1));
  return DateTime(startDate.year, startDate.month, startDate.day);
}

String get _currentWeekRange {
  final endDate = _currentWeekStart.add(const Duration(days: 6));
  final format = DateFormat('MMM dd');
  return '${format.format(_currentWeekStart)} - ${format.format(endDate)}, ${endDate.year}';
}

class WeeklyActivityChart extends StatefulWidget {
  final Map<String, Map<String, double>> weeksData;

  const WeeklyActivityChart({super.key, required this.weeksData});

  @override
  _WeeklyActivityChartState createState() => _WeeklyActivityChartState();
}

class _WeeklyActivityChartState extends State<WeeklyActivityChart> {
  late DateTime _currentWeekStart;
  late List<DateTime> _availableWeeks;
  String _currentWeekRange = '';

  final List<String> _dayOrder = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun"
  ];

  @override
  void initState() {
    super.initState();
    _initializeAvailableWeeks();
    _currentWeekStart = _availableWeeks.last; // Start from the latest week
    _updateWeekRange();
  }

  /// Converts unordered week keys (yyyy-MM-dd) into a sorted list of DateTime objects
  void _initializeAvailableWeeks() {
    _availableWeeks = widget.weeksData.keys
        .map((week) => DateFormat('yyyy-MM-dd').parse(week))
        .toList()
      ..sort(); // Ensure ascending order
  }

  /// Updates the displayed week range text
  void _updateWeekRange() {
    DateTime weekEnd = _currentWeekStart.add(const Duration(days: 6));
    _currentWeekRange =
        "${DateFormat('MMM d').format(_currentWeekStart)} - ${DateFormat('MMM d, yyyy').format(weekEnd)}";
    setState(() {});
  }

  /// Moves to the previous available week
  void _previousWeek() {
    int currentIndex = _availableWeeks.indexOf(_currentWeekStart);
    if (currentIndex > 0) {
      setState(() {
        _currentWeekStart = _availableWeeks[currentIndex - 1];
        _updateWeekRange();
      });
    }
  }

  /// Moves to the next available week
  void _nextWeek() {
    int currentIndex = _availableWeeks.indexOf(_currentWeekStart);
    if (currentIndex < _availableWeeks.length - 1) {
      setState(() {
        _currentWeekStart = _availableWeeks[currentIndex + 1];
        _updateWeekRange();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String weekKey = DateFormat('yyyy-MM-dd').format(_currentWeekStart);
    Map<String, double> weekData = widget.weeksData[weekKey] ?? {};

    // Ensure the week data follows the correct day order & fill missing days with 0.0
    Map<String, double> sortedWeekData = {
      for (var day in _dayOrder) day: weekData[day] ?? 0.0
    };

    bool canGoBack = _currentWeekStart.isAfter(_availableWeeks.first);
    bool canGoForward = _currentWeekStart.isBefore(_availableWeeks.last);

    return Container(
      decoration: BoxDecoration(
        color: boxbgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.white,
            blurRadius: 0.3,
            offset: Offset(0.3, 0.3),
          )
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white70),
                  onPressed: canGoBack
                      ? _previousWeek
                      : null, // Disable if at first week
                ),
                Column(
                  children: [
                    const Text('Weekly Activity Minutes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                    Text(_currentWeekRange,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        )),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios,
                      color: Colors.white70),
                  onPressed: canGoForward
                      ? _nextWeek
                      : null, // Disable if at last week
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: CustomPaint(
              size: const Size(double.infinity, 250),
              painter: _VerticalChartPainter(
                weeklyData: sortedWeekData,
                maxValue: 10,
                barColor: Colors.green,
                labelColor: Colors.white,
              ),
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

// Add this in your state class
int _currentWeekOffset = 0;

Map<String, double> _generateWeeklyData(DateTime weekStart) {
  // Implement your actual data fetching here
  final random = Random();
  return {
    'Mon': random.nextDouble() * 300,
    'Tue': random.nextDouble() * 120,
    'Wed': random.nextDouble() * 120,
    'Thu': random.nextDouble() * 120,
    'Fri': random.nextDouble() * 120,
    'Sat': random.nextDouble() * 120,
    'Sun': random.nextDouble() * 120,
  };
}
