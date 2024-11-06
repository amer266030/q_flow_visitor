import 'package:q_flow/screens/tickets/tickets_cubit.dart';

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
}
