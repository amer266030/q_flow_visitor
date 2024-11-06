import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:q_flow/screens/bootcamp/bootcamp_cubit.dart';
import 'package:q_flow/supabase/supabase_visitor.dart';

extension NetworkFunctions on BootcampCubit {
  updateBootcamp(BuildContext context) async {
    try {
      emitLoading();
      if (dataMgr.visitor == null)
        throw Exception('CouldNot'.tr());

      if (bootcamp == null) throw Exception('NoBootcamp'.tr());

      dataMgr.visitor!.bootcamp = bootcamp;

      await SupabaseVisitor.updateProfile(
        visitor: dataMgr.visitor!,
        visitorId: dataMgr.visitor!.id!,
        resumeFile: null,
        avatarFile: null,
      );

      navigateToBottomNav(context);
    } catch (e) {
      emitError(e.toString());
    }
  }
}
