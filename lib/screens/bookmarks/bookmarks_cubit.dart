import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:q_flow/managers/data_mgr.dart';

import '../../model/user/company.dart';

part 'bookmarks_state.dart';

class BookmarksCubit extends Cubit<BookmarksState> {
  BookmarksCubit() : super(BookmarksInitial()) {
    initialLoad();
  }

  var dataMgr = GetIt.I.get<DataMgr>();

  List<Company> companies = [];

  initialLoad() {
    companies = dataMgr.companies;

    emitUpdate();
  }

  void emitUpdate() => emit(UpdateUIState());
}
