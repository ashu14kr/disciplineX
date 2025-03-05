import 'package:anti_procastination/core/services/task.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/milestone_model.dart';

part 'milestone_state.dart';

class MilestoneCubit extends Cubit<MilestoneState> {
  MilestoneCubit() : super(MilestoneInitial());

  Task task = Task();

  getMilestones(String uid) async {
    final milestone = await task.getMilestones(uid);
    emit(MilestoneLoaded(milestone: milestone));
  }
}
