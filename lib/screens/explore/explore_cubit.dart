import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:q_flow/model/company.dart';
import 'package:q_flow/model/enums/queue_length.dart';
import 'package:q_flow/model/enums/tech_skill.dart';
import 'package:q_flow/model/interview.dart';

import '../../model/enums/company_size.dart';

part 'explore_state.dart';

class ExploreCubit extends Cubit<ExploreState> {
  ExploreCubit(List<Company> companies) : super(ExploreInitial()) {
    initialLoad(companies);
  }

  var searchController = TextEditingController();

  CompanySize? selectedSize;
  TechSkill? selectedSkill;
  QueueLength? selectedQueue;

  List<Company> companies = [];
  List<Company> filteredCompanies = [];

  initialLoad(List<Company> companies) {
    this.companies = companies;
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
    if (companySize != null) {
      filteredCompanies = companies
          .where((company) => company.companySize == companySize)
          .toList();
    }
    if (selectedSkill != null) {}
  }

  CompanySize? companySize;

  emitUpdate() => emit(UpdateUIState());
}
