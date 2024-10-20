import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:q_flow/model/enums/tech_skill.dart';
import 'package:q_flow/screens/interview_booked/interview_booked_screen.dart';

part 'company_details_state.dart';

class CompanyDetailsCubit extends Cubit<CompanyDetailsState> {
  CompanyDetailsCubit() : super(CompanyDetailsInitial()) {
    initialLoad();
  }

  List<TechSkill> skills = [];

  initialLoad() {
    skills = TechSkill.values.sublist(0, 5);
    emitUpdateUI();
  }

  navigateToInterviewBooked(BuildContext context) =>
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => InterviewBookedScreen()));

  navigateBack(BuildContext context) => Navigator.of(context).pop();

  emitUpdateUI() => emit(UpdateUIState());
}
