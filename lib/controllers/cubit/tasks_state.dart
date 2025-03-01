part of 'tasks_cubit.dart';

@immutable
sealed class TasksState extends Equatable {
  const TasksState();

  @override
  List<Object> get props => [];
}

final class TasksInitial extends TasksState {}

final class TasksLoaded extends TasksState {
  final List<TaskModel>? task;

  const TasksLoaded({required this.task});
}

final class TaskResumed extends TasksState {
  final int remainingSeconds;
  final List<TaskModel>? task;

  const TaskResumed({required this.remainingSeconds, required this.task});
}
