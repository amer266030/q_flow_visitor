import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:q_flow/extensions/date_ext.dart';
import 'package:q_flow/screens/rating_screen.dart';

import '../../model/company.dart';
import '../../model/enums/company_size.dart';
import '../../model/enums/interview_status.dart';
import '../../model/interview.dart';

part 'tickets_state.dart';

class TicketsCubit extends Cubit<TicketsState> {
  TicketsCubit() : super(TicketsInitial()) {
    initialLoad();
  }

  List<Interview> interviews = [];
  List<Interview> filteredInterviews = [];
  List<Company> companies = [];
  var selectedStatus = InterviewStatus.upcoming;

  initialLoad() {
    companies = [
      Company(
        id: '2',
        name: 'XYZ Company',
        description:
            'XYZ is a startup company that is specialized in providing tech solutions based on client needs.',
        companySize: CompanySize.oneHundredTo200,
        establishedYear: 2015,
        logoUrl: null,
      )
    ];
    interviews = [
      Interview(
          timeOfBooking: DateTime.now().toFormattedStringTimeOnly(),
          positionInQueue: 12,
          status: InterviewStatus.upcoming),
      Interview(
          timeOfBooking: DateTime.now()
              .add(Duration(hours: 1, minutes: 12))
              .toFormattedStringTimeOnly(),
          positionInQueue: 0,
          status: InterviewStatus.completed),
      Interview(
          timeOfBooking: DateTime.now()
              .add(Duration(hours: 2, minutes: 27))
              .toFormattedStringTimeOnly(),
          positionInQueue: 0,
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
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => RatingScreen(company: selectedCompany)));
  }

  emitUpdate() => emit(UpdateUIState());
}
