import 'package:get_it/get_it.dart';
import 'package:q_flow/model/social_links/social_link.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../managers/data_mgr.dart';
import '../model/user/company.dart';
import 'client/supabase_mgr.dart';

class SupabaseCompany {
  static var supabase = SupabaseMgr.shared.supabase;
  static const String tableKey = 'company';
  static const String socialLinkTableKey = 'social_links';

  static Future<List<Company>>? fetchCompanies() async {
    try {
      var res = await supabase.from(tableKey).select();
      List<Company> companies = (res as List).map((item) {
        // Create Company object from fetched data
        final company = Company.fromJson(item);

        // Map the social links if they exist
        if (item['social_link'] != null) {
          company.socialLinks = (item['social_link'] as List)
              .map((link) => SocialLink.fromJson(link as Map<String, dynamic>))
              .toList();
        }

        return company;
      }).toList();
      var dataMgr = GetIt.I.get<DataMgr>();
      dataMgr.saveCompanyData(companies: companies);
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
