import 'package:flutter/material.dart';
import 'package:q_flow/model/bookmarks/bookmarked_company.dart';
import 'package:q_flow/supabase/supabase_bookmark.dart';
import '../../model/enums/interview_status.dart';
import '../../model/interview.dart';
import '../../supabase/supabase_interview.dart';
import 'home_cubit.dart';

extension NetworkFunctions on HomeCubit {
  // Interviews

  Future<void> subscribeToScheduledQueue({List<String>? interviewIds}) async {
    final scheduledInterviewIds =
        interviewIds ?? await SupabaseInterview.fetchScheduledInterviewIds();

    final subscription = SupabaseInterview.subscribeToMultipleUpdates(
      companyIds: scheduledInterviewIds,
    ).listen((companyInterviews) {
      final companyUpcomingInterviews = companyInterviews
          .where((interview) => interview.status == InterviewStatus.upcoming)
          .toList();
      // Group interviews by company ID
      var companyGroupedInterviews = <String, List<Interview>>{};

      for (var interview in companyUpcomingInterviews) {
        companyGroupedInterviews
            .putIfAbsent(interview.companyId ?? '', () => [])
            .add(interview);
      }

      // Process each company's interviews individually
      for (var entry in companyGroupedInterviews.entries) {
        String companyId = entry.key;
        List<Interview> interviewsForCompany = entry.value;

        int index = 1; // Reset index for each company
        for (var interview in interviewsForCompany) {
          if (interview.visitorId == visitor.id) {
            var relevantInterview = interviews.firstWhere(
                (i) => i.companyId == companyId && i.visitorId == visitor.id);

            relevantInterview.positionInQueue = index;
          }
          index++;
        }
      }

      // Emit the updated interviews list to ensure the changes propagate
      HomeCubit.interviewController.add(List<Interview>.from(interviews));
      emitUpdate();
    });

    queueSubscriptions.add(subscription);
  }

  // Bookmarks

  fetchBookmarks(BuildContext context) async {
    try {
      emitLoading();
      var bookmarks = await SupabaseBookmark.fetchBookmarks();
      visitor.bookmarkedCompanies = bookmarks;
      dataMgr.visitor = visitor;
      emitUpdate();
      return bookmarks;
    } catch (e) {
      emitError(e.toString());
    }
  }

  createBookmark(BuildContext context, String companyId) async {
    try {
      emitLoading();
      await SupabaseBookmark.createBookmark(companyId);
      visitor.bookmarkedCompanies
          ?.add(BookmarkedCompany(visitorId: visitor.id, companyId: companyId));
      dataMgr.visitor = visitor;
      emitUpdate();
    } catch (e) {
      emitError(e.toString());
    }
  }

  deleteBookmark(BuildContext context, String companyId) async {
    try {
      emitLoading();
      await SupabaseBookmark.deleteBookmark(companyId);
      visitor.bookmarkedCompanies
          ?.removeWhere((bm) => bm.companyId == companyId);
      dataMgr.visitor = visitor;
      emitUpdate();
    } catch (e) {
      emitError(e.toString());
    }
  }
}
