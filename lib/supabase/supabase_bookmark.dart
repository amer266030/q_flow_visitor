import 'package:easy_localization/easy_localization.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/bookmarks/bookmarked_company.dart';
import 'client/supabase_mgr.dart';

class SupabaseBookmark {
  static final SupabaseClient supabase = SupabaseMgr.shared.supabase;
  static final String tableKey = 'bookmarked_company';

  static Future<List<BookmarkedCompany>> fetchBookmarks() async {
    var visitorId = supabase.auth.currentUser?.id;
    if (visitorId == null) throw Exception("VisitorIDNotFound".tr());

    var response =
        await supabase.from(tableKey).select().eq('visitor_id', visitorId);
    return response.map((json) => BookmarkedCompany.fromJson(json)).toList();
  }

  static Future<BookmarkedCompany> createBookmark(String companyId) async {
    var visitorId = supabase.auth.currentUser?.id;
    if (visitorId == null) throw Exception("VisitorIDNotFound".tr());

    try {
      // Create a new bookmarked company instance
      var bookmark =
          BookmarkedCompany(visitorId: visitorId, companyId: companyId);
      var response = await supabase
          .from(tableKey)
          .insert(bookmark.toJson())
          .select()
          .single();

      return BookmarkedCompany.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> deleteBookmark(String companyId) async {
    var visitorId = supabase.auth.currentUser?.id;
    if (visitorId == null) throw Exception("VisitorIDNotFound".tr());

    try {
      await supabase
          .from(tableKey)
          .delete()
          .eq('visitor_id', visitorId)
          .eq('company_id', companyId);
    } catch (e) {
      rethrow;
    }
  }
}
