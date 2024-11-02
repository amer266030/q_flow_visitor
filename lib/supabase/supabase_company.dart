import 'package:get_it/get_it.dart';
import 'package:q_flow/model/social_links/social_link.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../managers/data_mgr.dart';
import '../model/interview.dart';
import '../model/skills/skill.dart';
import '../model/user/company.dart';
import 'client/supabase_mgr.dart';

class SupabaseCompany {
  static var supabase = SupabaseMgr.shared.supabase;
  static const String tableKey = 'company';

  static final dataMgr = GetIt.I.get<DataMgr>();

  static Future<List<Company>>? fetchCompanies() async {
    try {
      final response = await supabase
          .from(tableKey)
          .select('*, social_link(*), skill(*), interview(*)');

      final companies = (response as List).map((companyData) {
        final company = Company.fromJson(companyData);

        if (companyData['social_link'] != null) {
          company.socialLinks = (companyData['social_link'] as List)
              .map((link) => SocialLink.fromJson(link))
              .toList();
        }

        if (companyData['skill'] != null) {
          company.skills = (companyData['skill'] as List)
              .map((skill) => Skill.fromJson(skill))
              .toList();
        }

        if (companyData['interview'] != null) {
          company.interviews = (companyData['interview'] as List)
              .map((interview) => Interview.fromJson(interview))
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
