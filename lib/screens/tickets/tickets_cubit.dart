import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:q_flow/screens/rating/rating_screen.dart';
import 'package:q_flow/screens/tickets/network_functions.dart';

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

  navigateToRating(BuildContext context, Interview interview) async {
    var selectedCompany = getCompany(interview.companyId ?? '');
    if (interview.status == InterviewStatus.completed) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => RatingScreen(company: selectedCompany)));
      // bool canRate = await checkIfCanRate(selectedCompany.id ?? '');
      // if (canRate) {
      //   Navigator.of(context).push(MaterialPageRoute(
      //       builder: (context) => RatingScreen(company: selectedCompany)));
      // } else {
      //   emitError('This company has already been rated!');
      // }
    }
  }

  String getEmptyStateMessage(InterviewStatus status) {
    switch (status) {
      case InterviewStatus.upcoming:
        return 'No upcoming interviews found.';
      case InterviewStatus.completed:
        return 'No completed interviews found.';
      case InterviewStatus.cancelled:
        return 'No cancelled interviews found.';
      default:
        return 'No interviews found.';
    }
  }

  @override
  void emit(TicketsState state) {
    if (!isClosed) {
      previousState = this.state;
      super.emit(state);
    }
  }

  emitUpdate() => emit(UpdateUIState());
  emitLoading() => emit(LoadingState());
  emitError(msg) => emit(ErrorState(msg));
}
