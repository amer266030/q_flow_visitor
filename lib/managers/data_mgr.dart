import 'package:q_flow/model/interview.dart';
import 'package:q_flow/model/user/company.dart';
import 'package:q_flow/model/user/visitor.dart';
import 'package:q_flow/supabase/supabase_company.dart';
import 'package:q_flow/supabase/supabase_visitor.dart';

class DataMgr {
  Visitor? visitor;
  List<Company> companies = [];

  DataMgr() {
    // MARK: - Moved fetch to Onboarding Screen
    // fetchData();
  }

  fetchData() async {
    await fetchVisitorData();
    await fetchCompanies();
  }

  // Visitor Functions

  Future<void> fetchVisitorData() async {
    try {
      await SupabaseVisitor.fetchProfile();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveVisitorData({required Visitor visitor}) async {
    this.visitor = visitor;
  }

  // Company Functions

  Future<void> fetchCompanies() async {
    try {
      final res = await SupabaseCompany.fetchCompanies();
      print(res?.length ?? 'No result');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveCompanies({required List<Company> companies}) async {
    this.companies = companies;
  }
}
