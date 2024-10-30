import 'package:q_flow/model/social_links/social_link.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'client/supabase_mgr.dart';

class SupabaseSocialLink {
  static final SupabaseClient supabase = SupabaseMgr.shared.supabase;
  static final String tableKey = 'social_link';

  static Future<void> upsertLinks(List<SocialLink> links) async {
    var visitorId = supabase.auth.currentUser?.id;
    if (visitorId == null) throw Exception("Visitor ID not found");

    try {
      final socialLinksData = links.map((link) {
        link.userId = visitorId;
        return link.toJson();
      }).toList();

      await supabase.from('social_links').upsert(socialLinksData);
    } catch (e) {
      rethrow;
    }
  }
}
