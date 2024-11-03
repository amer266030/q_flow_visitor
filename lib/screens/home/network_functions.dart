import 'package:flutter/material.dart';
import 'package:q_flow/model/bookmarks/bookmarked_company.dart';
import 'package:q_flow/supabase/supabase_bookmark.dart';
import 'package:q_flow/supabase/supabase_queue.dart';

import '../../model/queue_entry.dart';
import '../../supabase/supabase_interview.dart';
import 'home_cubit.dart';

extension NetworkFunctions on HomeCubit {
  // Interviews

  Future<void> subscribeToScheduledQueue(String companyId) async {
    // Step 1: Fetch the IDs of scheduled interviews
    final scheduledInterviewIds =
        await SupabaseInterview.fetchScheduledInterviewIds(companyId);

    // Step 2: Subscribe to the QueueEntry stream and filter by scheduled interviews
    SupabaseQueue.subscribeToMultipleUpdates(
      interviewIds: scheduledInterviewIds,
      companyId: companyId,
    ).listen((queueEntries) {
      // Call updateQueuePositions to update interview positions and emit the update
      updateQueuePositions(queueEntries);
    });
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
