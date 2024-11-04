import 'package:flutter/material.dart';
import 'package:q_flow/managers/alert_manger.dart';
import 'package:q_flow/screens/profile/profile_cubit.dart';
import 'package:q_flow/supabase/supabase_auth.dart';

extension NetworkFunctions on ProfileCubit {
  void logout(BuildContext context) {
    AlertManager().showDefaultAlert(
      context: context,
      title: 'Logout Confirmation',
      secondaryBtnText: 'Cancel',
      primaryBtnText: 'Logout',
      message: 'Are you sure you want to log out?',
      onConfirm: () async {
        try {
          emitLoading();
          await SupabaseAuth.signOut();
          previousState = null;
          if (context.mounted) navigateToOnBoarding(context);
        } catch (e) {
          emitError(e.toString());
        }
      },
      onCancel: () {
        // Optional: Handle any cancellation logic if necessary
      },
    );
  }
}
