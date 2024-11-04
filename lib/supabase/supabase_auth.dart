import 'package:easy_localization/easy_localization.dart';
import 'package:get_it/get_it.dart';
import 'package:q_flow/managers/data_mgr.dart';
import 'package:q_flow/supabase/supabase_interview.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'client/supabase_mgr.dart';

class SupabaseAuth {
  static final SupabaseClient supabase = SupabaseMgr.shared.supabase;
  static final invitationTableKey = 'event_invited_user';
  static final dataMgr = GetIt.I.get<DataMgr>();

  static Future sendOTP(String email) async {
    try {
      final invitationCheck = await supabase
          .from(invitationTableKey)
          .select('is_company')
          .eq('email', email)
          .maybeSingle();

      if (invitationCheck == null) {
        throw Exception(
            "TheProvidedEmail".tr());
      } else if (invitationCheck['is_company'] == true) {
        throw Exception(
            "AccessDenied".tr());
      }
      // Sign-in after check
      var response = await supabase.auth.signInWithOtp(email: email);
      return response;
    } on AuthException catch (_) {
      rethrow;
    } on PostgrestException catch (_) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  static Future verifyOTP(String email, String otp) async {
    print(email);
    print(otp);
    try {
      final response = await supabase.auth.verifyOTP(
        email: email,
        token: otp,
        type: OtpType.email,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future signOut() async {
    try {
      var response = await supabase.auth.signOut();
      dataMgr.visitor = null;
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
