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

  // Stream

  static Stream<List<Interview>> interviewStream() {
    try {
      var visitorId = supabase.auth.currentUser?.id;
      if (visitorId == null) throw Exception("Company ID not found");

      return supabase
          .from(tableKey)
          .stream(primaryKey: ['id'])
          .eq('visitor_id', visitorId)
          .order('created_at', ascending: false)
          .map((data) {
            return data.map((json) => Interview.fromJson(json)).toList();
          });
    } catch (e) {
      return const Stream<List<Interview>>.empty();
    }
  }

  // Fetch

  static Future<List<Interview>> fetchInterviews() async {
    var visitorId = supabase.auth.currentUser?.id;
    if (visitorId == null) throw Exception("Visitor ID not found");

    try {
      final response = await supabase
          .from(tableKey)
          .select()
          .eq('visitor_id', visitorId)
          .order('created_at', ascending: false);

      return response.map((json) => Interview.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Create

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

  // Update

  static Future updateInterview(Interview interview) async {
    try {
      if (interview.id == null) {
        throw Exception('Could not find an interview to update');
      }
      final response = await supabase
          .from(tableKey)
          .update(interview.toJson())
          .eq('id', interview.id!)
          .select()
          .single();

      return Interview.fromJson(response);
    } on AuthException catch (_) {
      rethrow;
    } on PostgrestException catch (_) {
      rethrow;
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
