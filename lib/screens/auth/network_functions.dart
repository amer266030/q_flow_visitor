import 'dart:math';

import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:q_flow/supabase/supabase_visitor.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../supabase/client/supabase_mgr.dart';
import '../../supabase/supabase_auth.dart';
import 'auth_cubit.dart';

extension NetworkFunctions on AuthCubit {
  static late String? userID;

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
      await SupabaseVisitor.fetchProfile();

      await OneSignal.login(Random().nextInt(99999).toString());
      userID = await OneSignal.User.getExternalId();
      print('userID: $userID');
      Supabase.instance.client.from('visitor').update({
        'external_id': userID,
      }).eq('f_name', 'Abdullah');
      if (context.mounted) {
        if (dataMgr.visitor != null) {
          navigateToHome(context);
        } else {
          navigateToEditProfile(context);
        }
      }
    } catch (e) {
      emitError('Could not verify OTP');
    }
  }
}
