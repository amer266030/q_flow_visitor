import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:q_flow/managers/data_mgr.dart';
import 'package:q_flow/model/user/company.dart';
import 'package:q_flow/model/enums/queue_length.dart';
import 'package:q_flow/model/enums/tech_skill.dart';
import 'package:q_flow/model/interview.dart';
import 'package:q_flow/screens/explore/network_functions.dart';

import '../../model/enums/company_size.dart';
import '../../model/user/visitor.dart';

part 'explore_state.dart';

class ExploreCubit extends Cubit<ExploreState> {
  ExploreState? previousState;
  ExploreCubit() : super(ExploreInitial()) {
    initialLoad();
  }

  var searchController = TextEditingController();

  CompanySize? selectedSize;
  TechSkill? selectedSkill;
  QueueLength? selectedQueue;

  var dataMgr = GetIt.I.get<DataMgr>();

  var visitor = Visitor();
  List<Company> companies = [];
  List<Company> filteredCompanies = [];

  initialLoad() {
    this.visitor = dataMgr.visitor ?? Visitor();
    this.companies = dataMgr.companies;
    filteredCompanies = companies;
    emitUpdate();
  }

  filterBySearch() {
    filteredCompanies = filteredCompanies
        .where((company) => company.name!
            .toLowerCase()
            .contains(searchController.text.toLowerCase()))
        .toList();
  }

  filterBySize(String str) {
    selectedSize =
        CompanySize.values.where((e) => e.value == str).toList().firstOrNull;
    filterCompanies();
    emitUpdate();
  }

  filterBySkill(String str) {
    selectedSkill =
        TechSkill.values.where((e) => e.value == str).toList().firstOrNull;
    filterCompanies();
    emitUpdate();
  }

  filterByQueueLength(String str) {
    selectedQueue =
        QueueLength.values.where((e) => e.value == str).toList().firstOrNull;
    filterCompanies();
    emitUpdate();
  }

  filterCompanies() {
    filteredCompanies = companies;
    if (selectedSize != null) {
      filteredCompanies = companies
          .where((company) => company.companySize == selectedSize)
          .toList();
    }

    if (selectedSkill != null) {
      filteredCompanies = filteredCompanies
          .where((company) => company.skills!.contains(selectedSkill))
          .toList();
    }

    if (selectedQueue != null) {
      filteredCompanies = filteredCompanies
          .where((company) => company.queueLength == selectedQueue)
          .toList();
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

  @override
  void emit(ExploreState state) {
    if (!isClosed) {
      previousState = this.state;
      super.emit(state);
    }
  }

  emitUpdate() => emit(UpdateUIState());
  emitLoading() => emit(LoadingState());
  emitError(msg) => emit(ErrorState(msg));
}
