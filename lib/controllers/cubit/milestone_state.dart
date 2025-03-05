part of 'milestone_cubit.dart';

sealed class MilestoneState extends Equatable {
  const MilestoneState();

  @override
  List<Object> get props => [];
}

final class MilestoneInitial extends MilestoneState {}

final class MilestoneLoaded extends MilestoneState {
  final List<ModelMilestone>? milestone;

  const MilestoneLoaded({required this.milestone});

  @override
  List<Object> get props => [milestone ?? []];
}
