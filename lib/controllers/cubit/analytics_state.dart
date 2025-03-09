part of 'analytics_cubit.dart';

sealed class AnalyticsState extends Equatable {
  const AnalyticsState();

  @override
  List<Object> get props => [];
}

final class AnalyticsInitial extends AnalyticsState {}

final class AnalyticsLoaded extends AnalyticsState {
  final AnalyticsModel? analyticsModel;

  const AnalyticsLoaded({required this.analyticsModel});

  @override
  List<Object> get props => [analyticsModel ?? {}];
}
