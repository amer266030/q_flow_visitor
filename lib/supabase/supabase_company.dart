import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../managers/data_mgr.dart';
import '../model/social_links/social_link.dart';
import '../model/user/company.dart';
import 'client/supabase_mgr.dart';

class SupabaseCompany {
  static var supabase = SupabaseMgr.shared.supabase;
  static const String tableKey = 'company';
  static final dataMgr = GetIt.I.get<DataMgr>();

  static Future<List<Company>>? fetchCompanies() async {
    try {
      final response =
          await supabase.from(tableKey).select('*, social_link(*)');

      final companies = (response as List).map((companyData) {
        final company = Company.fromJson(companyData);

        if (companyData['social_link'] != null) {
          company.socialLinks = (companyData['social_link'] as List)
              .map((link) => SocialLink.fromJson(link))
              .toList();
        }
        return company;
      }).toList();

      dataMgr.companies = companies;

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
