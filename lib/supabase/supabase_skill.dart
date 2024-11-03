import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/skills/skill.dart';
import 'client/supabase_mgr.dart';

class SupabaseSkill {
  static final SupabaseClient supabase = SupabaseMgr.shared.supabase;
  static const String tableKey = 'skill';

  static updateSkills(List<Skill> skills) async {
    var visitorId = supabase.auth.currentUser?.id;
    if (visitorId == null) throw Exception("Visitor ID not found");

    try {
      await supabase.from(tableKey).delete().eq('visitor_id', visitorId);

      List<Map<String, dynamic>> skillsData = skills.map((skill) {
        skill.visitorId = visitorId;
        return skill.toJson();
      }).toList();

      var result = await supabase.from(tableKey).insert(skillsData).select();

      return result.map((json) => Skill.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
