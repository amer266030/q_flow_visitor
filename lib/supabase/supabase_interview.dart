import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../managers/data_mgr.dart';
import '../model/interview.dart';
import 'client/supabase_mgr.dart';

class SupabaseInterview {
  static final SupabaseClient supabase = SupabaseMgr.shared.supabase;
  static final String tableKey = 'interview';
  static final dataMgr = GetIt.I.get<DataMgr>();

  // Home Stream

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

  // Home Queue Length Stream

  static Stream<List<Interview>> subscribeToMultipleUpdates({
    required List<String> companyIds,
  }) {
    return supabase
        .from(tableKey)
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: true)
        .map((interviews) {
          return interviews
              .where((entry) => companyIds.contains(entry['company_id']))
              .map((entry) => Interview.fromJson(entry))
              .toList();
        });
  }

  // Company Details Queue Length Stream

  static Stream<int> getQueueLengthStream({
    required String companyId,
  }) {
    return supabase
        .from(tableKey)
        .stream(primaryKey: ['id'])
        .eq('company_id', companyId)
        .map((interviews) {
          final upcomingInterviews = interviews
              .where((entry) => entry['status'] == 'Upcoming')
              .toList();
          return upcomingInterviews.length;
        });
  }

  // Fetch

  static Future<List<Interview>> fetchInterviews() async {
    var visitorId = supabase.auth.currentUser?.id;
    if (visitorId == null) throw Exception("VisitorIDNotFound".tr());

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
    if (visitorId == null) throw Exception("VisitorIDNotFound".tr());

    interview.visitorId = visitorId;

    try {
      // Call the check functions before creating the interview
      await supabase.rpc('check_upcoming_interviews',
          params: {'p_visitor_id': visitorId});
      await supabase.rpc('check_existing_company_interview', params: {
        'p_visitor_id': visitorId,
        'p_company_id': interview.companyId,
      });
      await supabase.rpc('check_company_queue_status',
          params: {'p_company_id': interview.companyId});

      // If all checks pass, insert the interview
      final response = await supabase
          .from(tableKey)
          .insert(interview.toJson())
          .select()
          .single();

      return Interview.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception("Failed to create interview: ${e.message}");
    } catch (e) {
      throw Exception("Failed to create interview: ${e.toString()}");
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
        throw Exception('Could'.tr());
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
      if (visitorId == null) throw Exception("VisitorIDNotFound".tr());

      final response = await SupabaseMgr.shared.supabase
          .from(tableKey)
          .select('company_id')
          .eq('visitor_id', visitorId)
          .eq('status', 'Upcoming');

      return (response as List)
          .map((interview) => interview['company_id'] as String)
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
