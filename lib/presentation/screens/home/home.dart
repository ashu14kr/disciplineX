import 'package:anti_procastination/constants.dart';
import 'package:anti_procastination/controllers/cubit/tasks_cubit.dart';
import 'package:anti_procastination/models/task_model.dart';
import 'package:anti_procastination/presentation/screens/home/addtask.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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
      backgroundColor: bgColor,
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
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      child: Text(
                        "Get back linkedin account engagement",
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.wallet,
                        size: 30,
                        color: Colors.transparent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Center(
                  child: BlocBuilder<TasksCubit, TasksState>(
                    builder: (context, state) {
                      if (state is TaskResumed) {
                        return CustomPaint(
                          painter: SquareProgressPainter(state.progress),
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
                                formatTime(
                                  Duration(
                                    seconds: state.remainingSeconds,
                                  ),
                                ),
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        );
                      } else if (state is TasksInitial) {
                        return CustomPaint(
                          painter: SquareProgressPainter(0.0),
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
                                "00:00:00",
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return CustomPaint(
                          painter: SquareProgressPainter(0.0),
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
                                "00:00:00",
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        );
                      }
                    },
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
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
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
                        color: Colors.white,
                      ),
                ),
                const SizedBox(
                  height: 15,
                ),
                BlocBuilder<TasksCubit, TasksState>(
                  builder: (context, state) {
                    if (state is TasksInitial) {
                      return Container();
                    } else if (state is TasksLoaded) {
                      return SizedBox(
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.task?.length,
                            itemBuilder: (context, index) {
                              return TaskCard(
                                model: state.task![index],
                                ontap: () async {
                                  if (state.task!
                                      .any((e) => e.startedAt != null)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text("There is one onoging task!"),
                                      ),
                                    );
                                    return;
                                  }
                                  EasyLoading.show();
                                  await task.updateTask(state.task![index].id);
                                  int min = state.task![index].completionTime;
                                  _remainingSeconds = min * 60;
                                  context.read<TasksCubit>().startTimer(
                                      _remainingSeconds, state.task!);
                                  getTask();
                                  EasyLoading.dismiss();
                                },
                              );
                            }),
                      );
                    } else if (state is TaskResumed) {
                      return SizedBox(
                        child: ListView.builder(
                            shrinkWrap:
                                true, // Prevents ListView from taking infinite height
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.task?.length,
                            itemBuilder: (context, index) {
                              return TaskCard(
                                model: state.task![index],
                                ontap: () async {
                                  if (state.task!
                                      .any((e) => e.startedAt != null)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text("There is one onoging task!"),
                                      ),
                                    );
                                    return;
                                  }
                                  EasyLoading.show();
                                  await task.updateTask(state.task![index].id);
                                  int min = state.task![index].completionTime;
                                  _remainingSeconds = min * 60;
                                  context.read<TasksCubit>().startTimer(
                                      _remainingSeconds, state.task!);
                                  getTask();
                                  EasyLoading.dismiss();
                                },
                              );
                            }),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                const SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
