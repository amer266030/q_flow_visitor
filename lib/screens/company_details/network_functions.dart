import 'package:flutter/cupertino.dart';
import 'package:q_flow/screens/company_details/company_details_cubit.dart';

import '../../model/enums/interview_status.dart';
import '../../model/interview.dart';
import '../../supabase/supabase_interview.dart';

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

      await SupabaseInterview.createInterview(interview);

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
