import 'dart:async';

import 'package:anti_procastination/controllers/cubit/tasks_cubit.dart';
import 'package:anti_procastination/models/task_model.dart';
import 'package:anti_procastination/presentation/screens/home/addtask.dart';
import 'package:anti_procastination/presentation/screens/setting/profile.dart';
import 'package:anti_procastination/presentation/screens/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/task.dart';
import '../../../storage/model/local_user_model.dart';
import '../../../storage/storage.dart';
import 'home_helper.dart';

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

  // _checkAndResumeTask() async {
  //   TaskModel? tasker;
  //   try {
  //     tasker = taskModel.firstWhere((e) => e.startedAt != null);
  //   } catch (e) {
  //     tasker = null;
  //   }

  //   if (tasker == null) {
  //     return;
  //   }

  //   DateTime startedAt = DateTime.parse(tasker.startedAt!);
  //   Duration elapsed = DateTime.now().difference(startedAt);

  //   int totalHours = int.parse(tasker.completionTime.split(" ")[0]);
  //   Duration totalDuration = Duration(hours: totalHours);

  //   Duration remaining = totalDuration - elapsed;
  //   if (remaining.isNegative) {
  //     await task.updateTaskStatus(tasker.id);
  //     remaining = Duration.zero;
  //   }
  //   setState(() {
  //     _remainingSeconds = remaining.inSeconds;
  //   });

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text("Resuming task started at ${tasker.startedAt}"),
  //       duration: const Duration(seconds: 3),
  //     ),
  //   );

  //   _startTimer();
  // }

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

  // void _startTimer() {
  //   _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     if (_remainingSeconds > 0) {
  //       setState(() {
  //         _remainingSeconds--;
  //       });
  //     } else {
  //       timer.cancel();
  //       // Timer reached zero, perform any desired action here.
  //     }
  //   });
  // }

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
      context.read<TasksCubit>().getTasks(response!.uuid);
      // final tasks = await task.getTasks(response!.uuid);
      // tasks?.forEach((e) {
      //   setState(() {
      //     taskModel.add(e);
      //   });
      // });
      // _checkAndResumeTask();
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getTask();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: CustomFloatingBtn(
        size: size,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTaskScreen(),
            ),
          );
        },
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
                    child: BlocBuilder<TasksCubit, TasksState>(
                      buildWhen: (previous, current) => true,
                      builder: (context, state) {
                        if (state is TasksInitial) {
                          return Text(
                            "00 : 00 : 00",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.displayMedium,
                          );
                        } else if (state is TaskResumed) {
                          print(state.remainingSeconds);
                          return Text(
                            formatTime(
                              Duration(
                                seconds: state.remainingSeconds,
                              ),
                            ),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.displayMedium,
                          );
                        } else {
                          return Text(
                            "00 : 00 : 00",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.displayMedium,
                          );
                        }
                      },
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
                  // if (taskModel.any((e) => e.startedAt != null)) {
                  //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  //       content: Text("There is one onoging task!")));
                  //   return;
                  // }
                  // await task.updateTask(taskModel[0].id);
                  // int hours =
                  //     int.parse(taskModel[0].completionTime.substring(0, 1));
                  // _remainingSeconds = hours * 3600;
                  // _startTimer();
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
              height: 15,
            ),
            Expanded(
              child: BlocBuilder<TasksCubit, TasksState>(
                builder: (context, state) {
                  if (state is TasksInitial) {
                    return Container();
                  } else if (state is TasksLoaded) {
                    return ListView.builder(
                        itemCount: state.task?.length,
                        itemBuilder: (context, index) {
                          return TaskWidget(
                            size: size,
                            taskModel: state.task![index],
                            ontap: () async {
                              if (state.task!.any((e) => e.startedAt != null)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "There is one onoging task!")));
                                return;
                              }
                              await task.updateTask(state.task![index].id);
                              int hours = int.parse(state
                                  .task![index].completionTime
                                  .substring(0, 1));
                              _remainingSeconds = hours * 3600;
                              // context
                              //     .read<TasksCubit>()
                              //     .startTimer(_remainingSeconds, state.task!);
                            },
                          );
                        });
                  } else if (state is TaskResumed) {
                    return ListView.builder(
                        itemCount: state.task?.length,
                        itemBuilder: (context, index) {
                          return TaskWidget(
                            size: size,
                            taskModel: state.task![index],
                            ontap: () async {
                              if (state.task!.any((e) => e.startedAt != null)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "There is one onoging task!")));
                                return;
                              }
                              await task.updateTask(state.task![index].id);
                              int hours = int.parse(state
                                  .task![index].completionTime
                                  .substring(0, 1));
                              _remainingSeconds = hours * 3600;
                              // context
                              //     .read<TasksCubit>()
                              //     .startTimer(_remainingSeconds, state.task!);
                            },
                          );
                        });
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
