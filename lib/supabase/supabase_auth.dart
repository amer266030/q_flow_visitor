import 'package:supabase_flutter/supabase_flutter.dart';

import 'client/supabase_mgr.dart';

class SupabaseAuth {
  static final SupabaseClient supabase = SupabaseMgr.shared.supabase;
  static final invitationTableKey = 'event_invited_user';

  static Future sendOTP(String email) async {
    try {
      final invitationCheck = await supabase
          .from(invitationTableKey)
          .select('is_company')
          .eq('email', email)
          .maybeSingle();

      if (invitationCheck == null) {
        throw Exception(
            "The provided email haven't been invited to an event. Please contact the organizer for support");
      } else if (invitationCheck['is_company'] == true) {
        throw Exception(
            "Access Denied!\nProvided email is intended for our Company App");
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
      print('Error verifying OTP: $e');
      rethrow;
    }
  }

  static Future signOut() async {
    try {
      var response = await supabase.auth.signOut();
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
