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

  static Future<List<Interview>> fetchInterviews() async {
    var visitorId = supabase.auth.currentUser?.id;
    if (visitorId == null) throw Exception("Visitor ID not found");

    try {
      final response =
          await supabase.from(tableKey).select().eq('visitor_id', visitorId);

      return response.map((json) => Interview.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

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

  static Stream<List<Interview>> subscribeToInterviewChanges() {
    try {
      if (dataMgr.visitor?.id == null) {
        throw Exception('could not load user ID');
      }
      return supabase
          .from(tableKey)
          .stream(primaryKey: ['id'])
          .eq('status', 'Upcoming')
          .map((interviews) {
            return interviews
                .where((data) => data['visitor_id'] == dataMgr.visitor!.id)
                .map((data) => Interview.fromJson(data))
                .toList();
          });
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<String>> fetchScheduledInterviewIds() async {
    try {
      var visitorId = supabase.auth.currentUser?.id;
      if (visitorId == null) throw Exception("Visitor ID not found");

      final response = await SupabaseMgr.shared.supabase
          .from(tableKey)
          .select('id')
          .eq('visitor_id', visitorId)
          .eq('status', 'Upcoming');

      return (response as List)
          .map((interview) => interview['id'] as String)
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
