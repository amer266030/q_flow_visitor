import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:q_flow/model/user/company.dart';
import 'package:q_flow/model/interview.dart';
import 'package:q_flow/screens/home/network_functions.dart';

import '../../managers/data_mgr.dart';
import '../../model/user/visitor.dart';
import '../company_details/company_details_screen.dart';
import '../explore/explore_screen.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeState? previousState;
  HomeCubit() : super(HomeInitial()) {
    initialLoad();
  }

  var dataMgr = GetIt.I.get<DataMgr>();

  var visitor = Visitor();
  List<Company> companies = [];

  initialLoad() {
    try {
      if (dataMgr.visitor == null) throw Exception('Could not load user');
      visitor = dataMgr.visitor!;
      companies = dataMgr.companies;
    } catch (e) {
      emitError(e.toString());
    }

    emitUpdate();
  }

  toggleBookmark(BuildContext context, String companyId) async {
    if (checkBookmark(companyId)) {
      await deleteBookmark(context, companyId);
    } else {
      await createBookmark(context, companyId);
    }
  }

  bool checkBookmark(String companyId) {
    if (visitor.bookmarkedCompanies != null) {
      return visitor.bookmarkedCompanies!.any((e) => e.companyId == companyId);
    }
    return false;
  }

  navigateToCompanyDetails(BuildContext context, Company company) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CompanyDetailsScreen(company: company)));
  }

  navigateToExplore(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ExploreScreen(companies: companies)));
  }

  @override
  void emit(HomeState state) {
    previousState = this.state;
    super.emit(state);
  }

  emitUpdate() => emit(UpdateUIState());
  emitLoading() => emit(LoadingState());
  emitError(msg) => emit(ErrorState(msg));
}
