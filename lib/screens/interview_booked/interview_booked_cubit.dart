import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:q_flow/extensions/date_ext.dart';
import 'package:q_flow/model/user/company.dart';
import 'package:q_flow/model/interview.dart';
import 'package:q_flow/screens/bottom_nav/bottom_nav_screen.dart';

import '../../managers/data_mgr.dart';
import '../../model/enums/company_size.dart';
import '../../model/enums/interview_status.dart';

part 'interview_booked_state.dart';

class InterviewBookedCubit extends Cubit<InterviewBookedState> {
  InterviewBookedCubit() : super(InterviewBookedInitial()) {
    initialLoad();
  }

  var dataMgr = GetIt.I.get<DataMgr>();
  Company? company;
  Interview? interview;

  initialLoad() {
    company = Company(
      id: '2',
      name: 'XYZ Company',
      description:
          'XYZ is a startup company that is specialized in providing tech solutions based on client needs.',
      companySize: CompanySize.oneHundredTo200,
      establishedYear: '2015',
      logoUrl: null,
    );
    interview = Interview(
      createdAt: DateTime.now().toFormattedStringTimeOnly(),
      status: InterviewStatus.upcoming,
    );
    emitUpdate();
  }

  navigateToHome(BuildContext context) =>
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => BottomNavScreen()),
        (route) => false,
      );

  emitUpdate() => emit(UpdateUIState());
}
