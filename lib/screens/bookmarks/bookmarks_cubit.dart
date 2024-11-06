import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:q_flow/managers/data_mgr.dart';
import 'package:q_flow/screens/bookmarks/network_functions.dart';

import '../../model/user/company.dart';
import '../../model/user/visitor.dart';
import '../company_details/company_details_screen.dart';

part 'bookmarks_state.dart';

class BookmarksCubit extends Cubit<BookmarksState> {
  BookmarksState? previousState;
  BookmarksCubit() : super(BookmarksInitial()) {
    initialLoad();
  }

  var dataMgr = GetIt.I.get<DataMgr>();

  var visitor = Visitor();
  List<Company> allCompanies = [];
  List<Company> bookmarkedCompanies = [];

  initialLoad() {
    try {
      if (dataMgr.visitor == null) throw Exception('Could'.tr());
      visitor = dataMgr.visitor!;
      allCompanies = dataMgr.companies;
      filterBookmarkedCompanies();
    } catch (e) {
      emitError(e.toString());
    }

    emitUpdate();
  }

  toggleBookmark(BuildContext context, String companyId) async {
    if (checkBookmark(companyId)) {
      await deleteBookmark(context, companyId);
    } else {
      await createBookmark(context, companyId);
    }
  }

  bool checkBookmark(String companyId) {
    if (visitor.bookmarkedCompanies != null) {
      return visitor.bookmarkedCompanies!.any((e) => e.companyId == companyId);
    }
    return false;
  }

  filterBookmarkedCompanies() {
    if (visitor.bookmarkedCompanies != null) {
      final bookmarkedCompanyIds = visitor.bookmarkedCompanies!
          .map((bookmark) => bookmark.companyId)
          .toSet();

      bookmarkedCompanies = allCompanies
          .where((company) => bookmarkedCompanyIds.contains(company.id))
          .toList();
    }
  }

  navigateToCompanyDetails(BuildContext context, Company company) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CompanyDetailsScreen(company: company)));
  }

  @override
  void emit(BookmarksState state) {
    previousState = this.state;
    super.emit(state);
  }

  emitUpdate() => emit(UpdateUIState());
  emitLoading() => emit(LoadingState());
  emitError(msg) => emit(ErrorState(msg));
}
