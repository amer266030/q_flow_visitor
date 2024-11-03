import 'package:flutter/material.dart';
import 'package:q_flow/screens/bootcamp/bootcamp_cubit.dart';
import 'package:q_flow/supabase/supabase_visitor.dart';

extension NetworkFunctions on BootcampCubit {
  updateBootcamp(BuildContext context) async {
    try {
      emitLoading();
      if (dataMgr.visitor == null)
        throw Exception('Could not retrieve user data');

      if (bootcamp == null) throw Exception('No bootcamp selected!');

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
