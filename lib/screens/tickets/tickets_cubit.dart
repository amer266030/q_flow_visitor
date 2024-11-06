import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:q_flow/screens/rating/rating_screen.dart';
import 'package:q_flow/screens/tickets/network_functions.dart';
import 'package:q_flow/utils/validations.dart';

import '../../managers/data_mgr.dart';
import '../../model/user/company.dart';
import '../../model/enums/interview_status.dart';
import '../../model/interview.dart';

part 'tickets_state.dart';

class TicketsCubit extends Cubit<TicketsState> {
  TicketsState? previousState;
  TicketsCubit() : super(TicketsInitial()) {
    initialLoad();
  }
  var dataMgr = GetIt.I.get<DataMgr>();
  List<Interview> interviews = [];
  List<Interview> filteredInterviews = [];
  List<Company> companies = [];
  var selectedStatus = InterviewStatus.upcoming;

  initialLoad() async {
    companies = dataMgr.companies;
    interviews = await fetchInterviews();
    filterInterviews();
    emitUpdate();
  }

  Company getCompany(String companyId) {
    return companies.where((c) => c.id == companyId).toList().firstOrNull ??
        Company();
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
    var selectedCompany = getCompany(interview.companyId ?? '');
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => RatingScreen(company: selectedCompany)));
  }

  @override
  void emit(TicketsState state) {
    if (!isClosed) {
      previousState = this.state;
      super.emit(state);
    }
  }

  String getEmptyStateMessage(InterviewStatus status) {
    switch (status) {
      case InterviewStatus.upcoming:
        return 'NoUpcomingInterview'.tr();
      case InterviewStatus.completed:
        return 'NoCompleted'.tr();
      case InterviewStatus.cancelled:
        return 'NoCancelled'.tr();
      default:
        return 'NotFound'.tr();
    }
  }

  emitUpdate() => emit(UpdateUIState());
  emitLoading() => emit(LoadingState());
  emitError(msg) => emit(ErrorState(msg));
}
