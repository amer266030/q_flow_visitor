import 'package:flutter/material.dart';
import 'package:q_flow/screens/skills/skills_cubit.dart';

import '../../model/skills/skill.dart';
import '../../supabase/supabase_skill.dart';

extension NetworkFunctions on SkillsCubit {
  // Use for both insert and update
  Future updateSkills(BuildContext context) async {
    try {
      emitLoading();
      var techSkills = createSkills();
      await SupabaseSkill.updateSkills(techSkills);
      dataMgr.visitor?.skills = techSkills;

      if (context.mounted) {
        if (dataMgr.visitor?.bootcamp == null) {
          navigateToBootcamp(context);
        } else {
          navigateBack(context);
        }
      }
    } catch (e) {
      emitError("Error loading company details: $e");
    }
  }

  List<Skill> createSkills() {
    return skills
        .map((position) =>
            Skill(companyId: dataMgr.visitor?.id, techSkill: position))
        .toList();
  }
}
