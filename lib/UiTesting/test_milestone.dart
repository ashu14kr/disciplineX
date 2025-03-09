import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/animation.dart';
import 'package:vector_math/vector_math.dart' as math;

class GoalRoadmapScreen extends StatefulWidget {
  @override
  _GoalRoadmapScreenState createState() => _GoalRoadmapScreenState();
}

class _GoalRoadmapScreenState extends State<GoalRoadmapScreen>
    with SingleTickerProviderStateMixin {
  final ConfettiController _confettiController =
      ConfettiController(duration: const Duration(seconds: 2));
  late AnimationController _animationController;
  int _currentMonthIndex = 0;

  final List<MonthGoal> _months = [
    MonthGoal(
      title: "Foundation Month",
      tasks: [
        Task("Basic Research", 0.2),
        Task("Skill Assessment", 0.3),
        Task("Resource Setup", 0.5),
      ],
    ),
    MonthGoal(
      title: "Development Phase",
      tasks: [
        Task("Core Projects", 0.4),
        Task("Mentor Meetings", 0.3),
        Task("Progress Review", 0.3),
      ],
    ),
    MonthGoal(
      title: "Advanced Stage",
      tasks: [
        Task("Complex Projects", 0.5),
        Task("Portfolio Setup", 0.3),
        Task("Community Building", 0.2),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Dream Progress Path",
            style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          _buildTimeline(),
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: [Colors.cyan, Colors.purple, Colors.white],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _advanceProgress,
        child: Icon(Icons.rocket_launch, color: Colors.white),
        backgroundColor: Colors.cyan,
      ),
    );
  }

  Widget _buildTimeline() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      itemCount: _months.length,
      itemBuilder: (context, index) => _buildMonthCard(_months[index], index),
    );
  }

  Widget _buildMonthCard(MonthGoal month, int index) {
    final isCurrent = index == _currentMonthIndex;
    final isCompleted = index < _currentMonthIndex;
    final totalProgress = month.tasks
        .fold(0.0, (sum, task) => sum + (task.completed ? task.weight : 0));

    return Padding(
      padding: EdgeInsets.only(bottom: 40),
      child: Stack(
        children: [
          // Timeline connector
          if (index > 0)
            Positioned(
              left: 35,
              top: -40,
              child: Container(
                height: 50,
                width: 2,
                color: isCompleted ? Colors.cyan : Colors.grey[800],
              ),
            ),

          AnimatedContainer(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isCurrent ? Colors.cyan : Colors.transparent,
                width: 2,
              ),
              boxShadow: [
                if (isCurrent)
                  BoxShadow(
                      color: Colors.cyan.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 2),
              ],
            ),
            child: Column(
              children: [
                // Month Header
                ListTile(
                  leading: _buildProgressIndicator(totalProgress, index),
                  title: Text("Month ${index + 1}",
                      style: TextStyle(color: Colors.white70)),
                  subtitle: Text(month.title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  trailing: _buildStatusIcon(isCompleted),
                ),

                // Tasks
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ...month.tasks
                          .map((task) => _buildTaskItem(task, isCompleted))
                          .toList(),
                      SizedBox(height: 16),
                      _buildProgressBar(totalProgress),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(double progress, int index) {
    return SizedBox(
      width: 50,
      height: 50,
      child: Stack(
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 3,
            backgroundColor: Colors.grey[800],
            // valueColor: AlwaysStoppedAnimation<Color>(
            //     index <= _currentMonthIndex ? Colors.cyan : Colors.grey[600]),
          ),
          Center(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: progress >= 1.0
                  ? Icon(Icons.check, color: Colors.cyan, size: 20)
                  : Text("${(progress * 100).toInt()}%",
                      style: TextStyle(color: Colors.white70)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(Task task, bool isMonthCompleted) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color:
            task.completed ? Colors.cyan.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          child: task.completed
              ? Icon(Icons.check_circle, color: Colors.cyan)
              : Icon(Icons.radio_button_unchecked, color: Colors.grey[600]),
        ),
        title: Text(task.title,
            style: TextStyle(
                color: task.completed ? Colors.cyan : Colors.white70,
                decoration:
                    task.completed ? TextDecoration.lineThrough : null)),
        trailing: Text("${(task.weight * 100).toInt()}%",
            style: TextStyle(color: Colors.grey[600])),
        onTap: () => !isMonthCompleted ? _toggleTask(task) : null,
      ),
    );
  }

  Widget _buildProgressBar(double progress) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: progress),
      duration: Duration(milliseconds: 800),
      curve: Curves.easeOutExpo,
      builder: (context, value, _) {
        return LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.grey[800],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan),
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        );
      },
    );
  }

  Widget _buildStatusIcon(bool isCompleted) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: isCompleted
          ? Icon(Icons.verified, color: Colors.cyan)
          : Icon(Icons.access_time_filled, color: Colors.grey[600]),
    );
  }

  void _toggleTask(Task task) {
    setState(() {
      task.completed = !task.completed;
      if (_months[_currentMonthIndex].completionProgress >= 1.0) {
        _confettiController.play();
      }
    });
  }

  void _advanceProgress() {
    if (_currentMonthIndex < _months.length - 1) {
      setState(() {
        _currentMonthIndex++;
        _animationController.reset();
        _animationController.forward();
      });
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}

class MonthGoal {
  final String title;
  final List<Task> tasks;

  double get completionProgress =>
      tasks.fold(0.0, (sum, task) => sum + (task.completed ? task.weight : 0));

  MonthGoal({required this.title, required this.tasks});
}

class Task {
  final String title;
  final double weight;
  bool completed;

  Task(this.title, this.weight, [this.completed = false]);
}
