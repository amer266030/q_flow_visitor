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
    await fetchCompanyData();
  }

  // Visitor Functions

  Future<void> fetchVisitorData() async {
    try {
      await SupabaseVisitor.fetchProfile();
    } catch (_) {}
  }

  Future<void> saveVisitorData({required Visitor visitor}) async {
    this.visitor = visitor;
  }

  // Company Functions

  Future<void> fetchCompanyData() async {
    try {
      await SupabaseCompany.fetchCompanies();
    } catch (_) {}
  }

  Future<void> saveCompanyData({required List<Company> companies}) async {
    this.companies = companies;
  }
}
