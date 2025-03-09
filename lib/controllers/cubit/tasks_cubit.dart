import 'dart:async';

import 'package:anti_procastination/core/services/task.dart';
import 'package:anti_procastination/models/milestone_model.dart';
import 'package:anti_procastination/models/task_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit() : super(TasksInitial());

  Task task = Task();
  Timer? _timer;
  int remainingSecondsss = 0;
  int total = 0;
  String uuid = "";

  void getWeeksData(String uid, ModelMilestone model) async {
    emit(TasksWaiting());
    final tasks = await task.getCompTasks(uid, model.id);
    emit(TasksMinutes(task: tasks));
  }

  void getTasks(String uid, ModelMilestone model, BuildContext context) async {
    _timer?.cancel();
    emit(TasksInitial());
    final tasks = await task.getTasks(uid, model.id);
    uuid = uid;
    emit(TasksLoaded(task: tasks));
    checkAndResumeTask(tasks, model, context);
  }

  checkAndResumeTask(List<TaskModel>? tasks, ModelMilestone model,
      BuildContext context) async {
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
    final int totalHours = ongoingTask.completionTime;
    final Duration totalDuration = Duration(minutes: totalHours);

    remainingSecondsss = (totalDuration - elapsed).inSeconds;
    total = totalDuration.inSeconds;

    if (remainingSecondsss <= 0) {
      task.updateTaskStatus(ongoingTask.id);
      task.updateMileStone(model.id, model.expiryAt);
      task.updateDayMinutes(uuid, ongoingTask.completionTime.toDouble());
      final utasks = await task.getTasks(uuid, model.id);
      emit(TasksLoaded(task: utasks));
      remainingSecondsss = 0;
    }

    if (remainingSecondsss > 0) {
      startTimer(remainingSecondsss, tasks, model, context);
    }
  }

  void startTimer(int seconds, List<TaskModel>? tasks, ModelMilestone mid,
      BuildContext context) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSecondsss > 0) {
        remainingSecondsss--;
        emit(
          TaskResumed(
            remainingSecondsss / total,
            task: tasks,
            remainingSeconds: remainingSecondsss,
          ),
        );
      } else {
        timer.cancel();
        checkAndResumeTask(tasks, mid, context);
      }
    });
  }
}
