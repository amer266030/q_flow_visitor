import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:q_flow/supabase/supabase_visitor.dart';

import '../../supabase/supabase_auth.dart';
import 'auth_cubit.dart';

extension NetworkFunctions on AuthCubit {
  sendOTP(BuildContext context) async {
    try {
      emitLoading();

      await SupabaseAuth.sendOTP(emailController.text);
      toggleIsOtp();
    } catch (e) {
      emitError(e.toString());
    }
  }

  verifyOTP(BuildContext context, int otp) async {
    var stringOtp = '$otp'.padLeft(6, '0');
    try {
      emitLoading();
      await SupabaseAuth.verifyOTP(emailController.text, stringOtp);

      var visitor = await SupabaseVisitor.fetchProfile();

      var externalId = await OneSignal.User.getOnesignalId();

      if (visitor?.id != null) {
        visitor?.externalId = externalId;
        await SupabaseVisitor.updateProfile(
          visitor: visitor!,
          visitorId: visitor.id!,
          resumeFile: null,
          avatarFile: null,
        );
      }

      OneSignal.login(externalId ?? '');

      previousState = null;
      if (context.mounted) {
        if (dataMgr.visitor != null) {
          navigateToHome(context);
        } else {
          navigateToEditProfile(context);
        }
      }
    } catch (e) {
      emitError('Could not verify OTP\n${e.toString()}');
    }
  }
}
