import 'package:q_flow/model/user/company.dart';
import 'package:q_flow/model/user/visitor.dart';
import 'package:q_flow/supabase/supabase_profile.dart';

class DataMgr {
  Visitor? visitor;
  List<Company> companies = [];

  final companyKey = 'company';

  DataMgr() {
    // fetchData();
  }

  fetchData() async {
    await fetchVisitorData();
  }

  // Company Functions

  Future<void> fetchVisitorData() async {
    try {
      await SupabaseVisitor.fetchProfile();
    } catch (_) {}
  }

  Future<void> saveVisitorData({required Visitor visitor}) async {
    this.visitor = visitor;
  }
}
