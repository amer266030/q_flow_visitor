import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/user/company.dart';
import 'client/supabase_mgr.dart';

class SupabaseCompany {
  static var supabase = SupabaseMgr.shared.supabase;
  static const String tableKey = 'company';

  static Future<List<Company>>? fetchCompanies() async {
    try {
      var res = await supabase.from(tableKey).select();
      List<Company> companies = (res as List)
          .map((item) => Company.fromJson(item as Map<String, dynamic>))
          .toList();
      return companies;
    } on AuthException catch (_) {
      rethrow;
    } on PostgrestException catch (_) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
