import 'dart:async';

import 'package:anti_procastination/core/services/task.dart';
import 'package:anti_procastination/models/task_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit() : super(TasksInitial());

  Task task = Task();
  Timer? _timer;
  int remainingSecondsss = 0;

  void getTasks(String uid) async {
    final tasks = await task.getTasks(uid);

    emit(TasksLoaded(task: tasks));

    checkAndResumeTask(tasks);
  }

  checkAndResumeTask(List<TaskModel>? tasks) async {
    if (tasks == null || tasks.isEmpty) return;

    TaskModel? ongoingTask;
    try {
      ongoingTask = tasks.firstWhere((task) => task.startedAt != null);
    } catch (e) {
      ongoingTask = null;
    }

    if (ongoingTask == null) return;

    if (ongoingTask.startedAt == null) return;

    final DateTime startedAt = DateTime.parse(ongoingTask.startedAt!);
    final Duration elapsed = DateTime.now().difference(startedAt);
    final int totalHours = int.parse(ongoingTask.completionTime.split(" ")[0]);
    final Duration totalDuration = Duration(hours: totalHours);

    remainingSecondsss = (totalDuration - elapsed).inSeconds;

    // print(remainingSeconds);

    if (remainingSecondsss <= 0) {
      task.updateTaskStatus(ongoingTask.id);
      remainingSecondsss = 0;
    }

    if (remainingSecondsss > 0) {
      emit(TaskResumed(
        task: tasks,
        remainingSeconds: remainingSecondsss,
      ));
      startTimer(remainingSecondsss, tasks);
    }
  }

  void startTimer(int seconds, List<TaskModel>? tasks) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSecondsss > 0) {
        remainingSecondsss--;
        emit(
          TaskResumed(
            task: tasks != null ? List.from(tasks) : [],
            remainingSeconds: 1,
          ),
        );

        // print("Emitting: $remainingSecondsss");
      } else {
        timer.cancel();
      }
    });
  }
}
