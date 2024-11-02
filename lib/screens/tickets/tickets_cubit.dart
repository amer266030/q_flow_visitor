import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:q_flow/extensions/date_ext.dart';
import 'package:q_flow/screens/rating/rating_screen.dart';

import '../../managers/data_mgr.dart';
import '../../model/user/company.dart';
import '../../model/enums/interview_status.dart';
import '../../model/interview.dart';

part 'tickets_state.dart';

class TicketsCubit extends Cubit<TicketsState> {
  TicketsCubit() : super(TicketsInitial()) {
    initialLoad();
  }
  var dataMgr = GetIt.I.get<DataMgr>();
  List<Interview> interviews = [];
  List<Interview> filteredInterviews = [];
  List<Company> companies = [];
  var selectedStatus = InterviewStatus.upcoming;

  initialLoad() {
    companies = dataMgr.companies;

    interviews = [
      Interview(
          createdAt: DateTime.now().toFormattedStringTimeOnly(),
          status: InterviewStatus.upcoming),
      Interview(
          createdAt: DateTime.now()
              .add(Duration(hours: 1, minutes: 12))
              .toFormattedStringTimeOnly(),
          status: InterviewStatus.completed),
      Interview(
          createdAt: DateTime.now()
              .add(Duration(hours: 2, minutes: 27))
              .toFormattedStringTimeOnly(),
          status: InterviewStatus.completed),
    ];
    filterInterviews();
    emitUpdate();
  }

  Company getSelectedCompany(String companyId) {
    return companies.first;
  }

  setSelectedStatus(int idx) {
    selectedStatus = InterviewStatus.values[idx];
    filterInterviews();
    emitUpdate();
  }

  filterInterviews() {
    filteredInterviews = interviews
        .where((interview) => interview.status == selectedStatus)
        .toList();
    emitUpdate();
  }

  navigateToRating(BuildContext context, Interview interview) {
    var selectedCompany = getSelectedCompany(interview.companyId ?? '');
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => RatingScreen(company: selectedCompany)));
  }

  emitUpdate() => emit(UpdateUIState());
}
