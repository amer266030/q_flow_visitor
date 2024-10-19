import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:q_flow/model/company.dart';
import 'package:q_flow/model/enums/company_size.dart';
import 'package:q_flow/model/interview.dart';

import '../explore/explore_screen.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial()) {
    initialLoad();
  }

  List<Interview> interviews = [];
  List<Company> companies = [];

  initialLoad() {
    interviews = [
      Interview(timeOfBooking: '10:30 AM', positionInQueue: 5, companyId: '1'),
      Interview(timeOfBooking: '10:42 AM', positionInQueue: 12, companyId: '1')
    ];

    companies = List.generate(
      5,
      (index) => Company(
        id: '${index + 1}',
        name: 'ABC Company',
        description:
            'XYZ is a startup company that is specialized in providing tech solutions based on client needs.',
        companySize: CompanySize.oneHundredTo200,
        establishedYear: 2015,
        logoUrl: null,
      ),
    );

    emitUpdate();
  }

  navigateToExplore(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ExploreScreen(companies: companies)));
  }

  emitUpdate() => emit(UpdateUIState());
}
