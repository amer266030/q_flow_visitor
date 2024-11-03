import 'package:q_flow/model/rating/company_rating_question.dart';
import 'package:q_flow/model/user/company.dart';
import 'package:q_flow/model/user/visitor.dart';
import 'package:q_flow/supabase/supabase_company.dart';
import 'package:q_flow/supabase/supabase_rating.dart';
import 'package:q_flow/supabase/supabase_visitor.dart';

class DataMgr {
  Visitor? visitor;
  List<Company> companies = [];
  List<CompanyRatingQuestion> ratingQuestions = [];

  DataMgr() {
    // MARK: - Moved fetch to Onboarding Screen
    // fetchData();
  }

  fetchData() async {
    await _fetchVisitorData();
    await _fetchCompanies();
    await _fetchRatingQuestions();
  }

  // Visitor Functions

  Future<void> _fetchVisitorData() async {
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

  Future<void> _fetchCompanies() async {
    try {
      await SupabaseCompany.fetchCompanies();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveCompanies({required List<Company> companies}) async {
    this.companies = companies;
  }

  // Rating Questions
  Future<void> _fetchRatingQuestions() async {
    try {
      ratingQuestions = await SupabaseRating.fetchQuestions() ?? [];
    } catch (e) {
      rethrow;
    }
  }
}
