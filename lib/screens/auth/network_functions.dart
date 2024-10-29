import 'package:flutter/material.dart';

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
      emitUpdate();
      if (context.mounted) {
        navigateToEditProfile(context);
      }
    } catch (e) {
      emitError('Could not verify OTP');
    }
  }
}
