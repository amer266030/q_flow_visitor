import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../managers/data_mgr.dart';
import 'client/supabase_mgr.dart';

class SupabaseQueue {
  static final SupabaseClient supabase = SupabaseMgr.shared.supabase;
  static final String tableKey = 'queue';
  static final dataMgr = GetIt.I.get<DataMgr>();

  Stream<int> getQueueLengthStream(String companyId) {
    final stream = supabase
        .from(tableKey)
        .stream(primaryKey: ['id'])
        .eq('companyId', companyId)
        .map((event) {
          // Calculate queue length whenever an event is triggered
          return event.length;
        });

    return stream;
  }
}
