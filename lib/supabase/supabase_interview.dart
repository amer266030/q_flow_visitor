import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:q_flow/model/enums/interview_status.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../managers/data_mgr.dart';
import '../model/interview.dart';
import 'client/supabase_mgr.dart';

class SupabaseQueue {
  static final SupabaseClient supabase = SupabaseMgr.shared.supabase;
  static final String tableKey = 'queue';
  static final dataMgr = GetIt.I.get<DataMgr>();
  StreamSubscription<List<Map<String, dynamic>>>? interviewSubscription;

  void subscribeToQueueUpdates(String companyId) {
    interviewSubscription = supabase
        .from(tableKey)
        .stream(primaryKey: ['id'])
        .eq('company_id', companyId)
        .listen((event) {
          handleQueueUpdate(event, companyId);
        });
  }

  void unsubscribeFromQueueUpdates() {
    interviewSubscription?.cancel();
    interviewSubscription = null;
  }

  // MARK: - move this function to a 'Cubit' to handle UI updates

  void handleQueueUpdate(List<Map<String, dynamic>> event, String companyId) {
    // Filter events to get only 'waiting' interviews
    final waitingInterviews = event
        .where((interview) =>
            interview['status'] == InterviewStatus.upcoming.value)
        .toList();

    // Update the company's queue length
    final company = dataMgr.companies.firstWhere((c) => c.id == companyId);
    company.queueLength = waitingInterviews.length;

    // Optionally update interview details
    company.interviews =
        waitingInterviews.map((data) => Interview.fromJson(data)).toList();

    // Trigger UI update if needed
    // notifyListeners();
  }
}
