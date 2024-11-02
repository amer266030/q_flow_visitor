import 'package:flutter/material.dart';
import 'package:q_flow/screens/bookmarks/bookmarks_cubit.dart';

import '../../model/bookmarks/bookmarked_company.dart';
import '../../supabase/supabase_bookmark.dart';

extension NetworkFunctions on BookmarksCubit {
  fetchBookmarks(BuildContext context) async {
    try {
      emitLoading();
      var bookmarks = await SupabaseBookmark.fetchBookmarks();
      visitor.bookmarkedCompanies = bookmarks;
      dataMgr.visitor = visitor;
      filterBookmarkedCompanies();
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
      filterBookmarkedCompanies();
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
      filterBookmarkedCompanies();
      emitUpdate();
    } catch (e) {
      emitError(e.toString());
    }
  }
}
