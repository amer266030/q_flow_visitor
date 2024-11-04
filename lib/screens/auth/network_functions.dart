import 'dart:math';

import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:q_flow/supabase/supabase_visitor.dart';

import '../../local_data/one_data.dart';
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

      //________________________________________________
      final oneSignalId = Random().nextInt(99999).toString();
      await OneSignal.login(oneSignalId);
      print('User ID: $oneSignalId');
      oneData = oneSignalId;
      print('oneData: $oneData');
      //________________________________________________
      await SupabaseVisitor.fetchProfile();
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
