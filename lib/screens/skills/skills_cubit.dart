import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:q_flow/screens/bootcamp/bootcamp_screen.dart';

import '../../managers/data_mgr.dart';
import '../../model/enums/tech_skill.dart';

part 'skills_state.dart';

class SkillsCubit extends Cubit<SkillsState> {
  SkillsCubit() : super(SkillsInitial()) {
    initialLoad();
  }

  SkillsState? previousState;
  final dataMgr = GetIt.I.get<DataMgr>();
  List<TechSkill> skills = [];

  initialLoad() {
    var visitor = dataMgr.visitor;
    if (visitor?.skills != null) {
      for (var skill in visitor!.skills!) {
        if (skill.techSkill != null) {
          skills.contains(skill.techSkill!)
              ? skills.remove(skill.techSkill!)
              : skills.add(skill.techSkill!);
        }
      }
    }
  }

  navigateBack(BuildContext context) => Navigator.of(context).pop();

  navigateToBootcamp(BuildContext context) =>
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const BootcampScreen()));

  positionTapped(TechSkill position) {
    skills.contains(position) ? skills.remove(position) : skills.add(position);
    emitUpdate();
  }

  @override
  void emit(SkillsState state) {
    previousState = this.state;
    super.emit(state);
  }

  emitLoading() => emit(LoadingState());
  emitUpdate() => emit(UpdateUIState());
  emitError(msg) => emit(ErrorState(msg));
}
