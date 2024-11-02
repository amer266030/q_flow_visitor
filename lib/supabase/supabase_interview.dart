import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../managers/data_mgr.dart';
import '../model/interview.dart';
import 'client/supabase_mgr.dart';

class SupabaseInterview {
  static final SupabaseClient supabase = SupabaseMgr.shared.supabase;
  static final String tableKey = 'interview';
  static final dataMgr = GetIt.I.get<DataMgr>();

  static Future<Interview> createInterview(Interview interview) async {
    var visitorId = supabase.auth.currentUser?.id;
    if (visitorId == null) throw Exception("Visitor ID not found");

    interview.visitorId = visitorId;

    try {
      final response = await supabase
          .from(tableKey)
          .insert(interview.toJson())
          .select()
          .single();

      return Interview.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
