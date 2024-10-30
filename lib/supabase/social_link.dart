import 'package:q_flow/model/enums/user_social_link.dart';
import 'package:q_flow/model/social_links/social_link.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'client/supabase_mgr.dart';

class SupabaseSocialLink {
  static final SupabaseClient supabase = SupabaseMgr.shared.supabase;
  static final String tableKey = 'social_link';

  static insertLinks(List<SocialLink> links) async {
    var visitorId = supabase.auth.currentUser?.id;
    if (visitorId == null) throw Exception("Visitor ID not found");

    try {
      final socialLinksData = links.map((link) {
        link.visitorId = visitorId;
        return link.toJson();
      }).toList();

      print(socialLinksData);

      var createdLinks =
          await supabase.from('social_link').insert(socialLinksData).select();
      return createdLinks;
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> updateLinks(List<SocialLink> links) async {
    var visitorId = supabase.auth.currentUser?.id;
    if (visitorId == null) throw Exception("Visitor ID not found");

    try {
      // Use Future.wait to run updates concurrently
      await Future.wait(links.map((link) async {
        link.visitorId = visitorId;

        await supabase
            .from(tableKey)
            .update(link.toJson())
            .eq('visitor_id', '${link.visitorId}')
            .eq('link_type', '${link.linkType?.value}');
      }));
    } catch (e) {
      rethrow;
    }
  }
}
