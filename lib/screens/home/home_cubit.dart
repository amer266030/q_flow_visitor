import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:q_flow/model/enums/interview_status.dart';
import 'package:q_flow/model/user/company.dart';
import 'package:q_flow/screens/home/network_functions.dart';

import '../../managers/data_mgr.dart';
import '../../model/interview.dart';
import '../../model/queue_entry.dart';
import '../../model/user/visitor.dart';
import '../../supabase/supabase_interview.dart';
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
  List<StreamSubscription<List<QueueEntry>>> queueSubscriptions = [];
  List<QueueEntry> scheduledQueue = [];

  void initialLoad() async {
    try {
      if (dataMgr.visitor == null) throw Exception('Could not load user');
      visitor = dataMgr.visitor!;
      companies = dataMgr.companies;

      // Subscribing to interview updates
      for (var interview in visitor.interviews ?? []) {
        if (interview.companyId != null &&
            interview.status == InterviewStatus.upcoming) {
          await subscribeToScheduledQueue();
          await subscribeToInterviewUpdates();
        }
      }
    } catch (e) {
      emitError(e.toString());
    }
    emitUpdate();
  }

  void updateInterviewList(List<Interview> newInterviews) async {
    await cancelSubscriptions();

    visitor.interviews = newInterviews;
    final interviewCopy = List<Interview>.from(visitor.interviews ?? []);

    for (var interview in interviewCopy) {
      if (interview.companyId != null &&
          interview.status == InterviewStatus.upcoming) {
        await subscribeToScheduledQueue();
      }
    }

    emitUpdate();
  }

  Future<void> cancelSubscriptions() async {
    for (var subscription in queueSubscriptions) {
      await subscription.cancel();
    }
    queueSubscriptions.clear();
  }

  @override
  Future<void> close() async {
    await cancelSubscriptions();
    return super.close();
  }

  Company? getCompany(String companyId) {
    return companies.where((c) => c.id == companyId).toList().firstOrNull;
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
    if (!isClosed) {
      previousState = this.state;
      super.emit(state);
    }
  }

  emitUpdate() => emit(UpdateUIState());
  emitLoading() => emit(LoadingState());
  emitError(msg) => emit(ErrorState(msg));
}
