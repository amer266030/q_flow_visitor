import 'package:flutter/material.dart';
import 'package:q_flow/model/bookmarks/bookmarked_company.dart';
import 'package:q_flow/supabase/supabase_bookmark.dart';
import 'package:q_flow/supabase/supabase_queue.dart';

import '../../model/queue_entry.dart';
import '../../supabase/supabase_interview.dart';
import 'home_cubit.dart';

extension NetworkFunctions on HomeCubit {
  // Interviews

  Future<void> subscribeToInterviewUpdates() async {
    SupabaseInterview.subscribeToInterviewChanges().listen((newInterviews) {
      updateInterviewList(newInterviews);
    });
  }

  Future<void> subscribeToScheduledQueue({List<String>? interviewIds}) async {
    final scheduledInterviewIds =
        interviewIds ?? await SupabaseInterview.fetchScheduledInterviewIds();

    final subscription = SupabaseQueue.subscribeToMultipleUpdates(
      interviewIds: scheduledInterviewIds,
    ).listen((queueEntries) {
      updateQueuePositions(queueEntries);
    });
    queueSubscriptions.add(subscription);
  }

  void updateQueuePositions(List<QueueEntry> queueEntries) {
    // Update the positionInQueue for each interview in visitor.interviews
    for (var interview in visitor.interviews ?? []) {
      final queueEntry = queueEntries.firstWhere(
        (q) => q.interviewId == interview.id,
        orElse: () => QueueEntry(position: null),
      );
      interview.positionInQueue = queueEntry.position;
    }

    emitUpdate();
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
