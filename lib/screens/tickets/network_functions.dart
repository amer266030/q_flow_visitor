import 'package:q_flow/screens/tickets/tickets_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../supabase/client/supabase_mgr.dart';
import '../../supabase/supabase_interview.dart';

extension NetworkFunctions on TicketsCubit {
  // Interviews

  Future fetchInterviews() async {
    try {
      var response = await SupabaseInterview.fetchInterviews();
      return response;
    } catch (e) {
      emitError(e.toString());
    }
  }

  Future<bool> checkIfCanRate(String companyId) async {
    final SupabaseClient supabase = SupabaseMgr.shared.supabase;
    final visitorId = dataMgr.visitor?.id ?? '';

    try {
      final result = await supabase.rpc('check_rating_exists', params: {
        'p_visitor_id': visitorId,
        'p_company_id': companyId,
      });
      print('check_rating_exists result: $result'); // Debug output

      // Ensure result is a boolean and defaults to false if null
      return (result is bool) ? result : false;
    } catch (error) {
      print('Error in checkIfCanRate: $error');
      return false;
    }
  }
}
