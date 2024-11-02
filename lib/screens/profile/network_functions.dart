import 'package:flutter/material.dart';
import 'package:q_flow/screens/profile/profile_cubit.dart';
import 'package:q_flow/supabase/supabase_auth.dart';

extension NetworkFunctions on ProfileCubit {
  logout(BuildContext context) async {
    try {
      emitLoading();
      await SupabaseAuth.signOut();
      previousState = null;
      if (context.mounted) navigateToOnBoarding(context);
    } catch (e) {
      emitError(e.toString());
    }
  }
}
