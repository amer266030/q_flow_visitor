import 'package:flutter/cupertino.dart';
import 'package:q_flow/model/queue_entry.dart';
import 'package:q_flow/screens/company_details/company_details_cubit.dart';

import '../../model/enums/interview_status.dart';
import '../../model/interview.dart';
import '../../supabase/supabase_interview.dart';
import '../../supabase/supabase_queue.dart';

extension NetworkFunctions on CompanyDetailsCubit {
  createInterview(BuildContext context, String companyId) async {
    var visitor = dataMgr.visitor;
    try {
      emitLoading();
      if (visitor == null) throw Exception('Could not read profile data');
      var interview = Interview(
        visitorId: visitor.id,
        companyId: companyId,
        status: InterviewStatus.upcoming,
      );

      var newInterview = await SupabaseInterview.createInterview(interview);

      var queueEntry = QueueEntry(
        interviewId: newInterview.id,
        companyId: companyId,
        position: queueLength,
      );

      await SupabaseQueue.insertIntoQueue(queueEntry);

      Future.delayed(Duration(milliseconds: 50));
      if (context.mounted) {
        navigateToInterviewBooked(context);
      }
    } catch (e) {
      emitError(e.toString());
    }
  }

  handleQueueUpdate(List<Interview> event, String companyId) {
    final waitingInterviews = event
        .where(
            (interview) => interview.status == InterviewStatus.upcoming.value)
        .toList();

    final company = dataMgr.companies.firstWhere((c) => c.id == companyId);
    company.queueLength = waitingInterviews.length;

    company.interviews = waitingInterviews;

    emitUpdate();
  }
}
