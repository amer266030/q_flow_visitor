import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:q_flow/model/user/company.dart';
import 'package:q_flow/model/enums/company_size.dart';
import 'package:q_flow/model/interview.dart';

import '../../managers/data_mgr.dart';
import '../company_details/company_details_screen.dart';
import '../explore/explore_screen.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial()) {
    initialLoad();
  }

  var visitor = GetIt.I.get<DataMgr>().visitor;
  var companies = GetIt.I.get<DataMgr>().companies;
  List<Interview> interviews = [];

  initialLoad() {
    interviews = [
      // Interview(timeOfBooking: '10:30 AM', positionInQueue: 5, companyId: '1'),
      // Interview(timeOfBooking: '10:42 AM', positionInQueue: 12, companyId: '1')
    ];

    emitUpdate();
  }

  navigateToCompanyDetails(BuildContext context, Company company) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CompanyDetailsScreen(company: company)));
  }

  navigateToExplore(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ExploreScreen(companies: companies)));
  }

  emitUpdate() => emit(UpdateUIState());
}
