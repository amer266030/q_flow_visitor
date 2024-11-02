import 'package:flutter/material.dart';
import 'package:q_flow/model/bookmarks/bookmarked_company.dart';
import 'package:q_flow/supabase/supabase_bookmark.dart';

import 'home_cubit.dart';

extension NetworkFunctions on HomeCubit {
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
