import 'package:anti_procastination/core/services/task.dart';
import 'package:anti_procastination/models/analytics_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'analytics_state.dart';

class AnalyticsCubit extends Cubit<AnalyticsState> {
  AnalyticsCubit() : super(AnalyticsInitial());

  Task task = Task();

  Future<void> getAnalytics(String uid) async {
    // try {
    emit(AnalyticsInitial());
    final data = await task.getAnalytics(uid);
    if (data != null) {
      print(data.weeks.entries.first.value.entries.first.value);
      emit(AnalyticsLoaded(analyticsModel: data));
    } else {
      print("No analytics data found.");
    }
    // } catch (e) {
    //   print("Failed to load analytics: $e");
    // }
  }
}
