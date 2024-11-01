import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/bookmarks/bookmarked_company.dart';
import 'client/supabase_mgr.dart';

class SupabaseBookmark {
  static final SupabaseClient supabase = SupabaseMgr.shared.supabase;
  static final String tableKey = 'bookmarked_company';

  static Future<BookmarkedCompany> createBookmark(String companyId) async {
    var visitorId = supabase.auth.currentUser?.id;
    if (visitorId == null) throw Exception("Visitor ID not found");

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
    if (visitorId == null) throw Exception("Visitor ID not found");

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
